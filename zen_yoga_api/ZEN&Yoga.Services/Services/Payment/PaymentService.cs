using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Options;
using RabbitMQ.Client;
using Stripe;
using Stripe.TestHelpers;
using Stripe.V2;
using System.Text;
using System.Text.Json;
using System.Text.RegularExpressions;
using ZEN_Yoga.Models;
using ZEN_Yoga.Models.Enums;
using ZEN_Yoga.Models.Responses;
using ZEN_Yoga.Services.Configurations;
using ZEN_Yoga.Services.Interfaces.Payment;

namespace ZEN_Yoga.Services.Services.Payment
{
    public class PaymentService : IPaymentService
    {
        private readonly ZenYogaDbContext _dbContext;
        private readonly RabbitMqSettings _rabbitMqSettings;
        private readonly StripeSettings _stripeSettings;
        private ConnectionFactory _connectionFactory;

        public PaymentService(ZenYogaDbContext dbContext, IOptions<RabbitMqSettings> options, IOptions<StripeSettings> stripeSettingsOptions)
        {
            _dbContext = dbContext;
            _rabbitMqSettings = options.Value;
            _stripeSettings = stripeSettingsOptions.Value;
            StripeConfiguration.ApiKey = _stripeSettings.SecretKey;
            _connectionFactory = new ConnectionFactory()
            {
                HostName = _rabbitMqSettings.Host!,
                Port = int.Parse(_rabbitMqSettings.Port!),
                UserName = _rabbitMqSettings.User!,
                Password = _rabbitMqSettings.Password!
            };
        }

        public async Task<bool> AddPayment(int userId, int studioId, int amount, string paymentIntentId)
        {
            var payment = await _dbContext.Payments.FirstOrDefaultAsync(ss => ss.StudioId == studioId && ss.UserId == userId);

            if (payment != null)
            {
                return false;
            }

            await SendMessageToRabbitMQ(userId, studioId, amount, paymentIntentId);

          

            return true;
        }

        public async Task<CreateIntentResponse> CreatePaymentIntentAsync(string amount, string currency)
        {
            var amountInCents = (int.Parse(amount) * 100).ToString();

            var customer = await new Stripe.CustomerService().CreateAsync(new CustomerCreateOptions());

            var ephemeralKey = await new EphemeralKeyService().CreateAsync(
                new EphemeralKeyCreateOptions
                {
                    Customer = customer.Id,
                    StripeVersion = _stripeSettings.StripeVersion
                }
            );

            var paymentIntent = await new PaymentIntentService().CreateAsync(
                new PaymentIntentCreateOptions
                {
                    Amount = long.Parse(amountInCents),
                    Currency = currency,
                    Customer = customer.Id,
                    AutomaticPaymentMethods = new PaymentIntentAutomaticPaymentMethodsOptions
                    {
                        Enabled = true
                    }
                }
            );

            return new CreateIntentResponse(
                ClientSecret: paymentIntent.ClientSecret,
                Customer: customer.Id,
                EphemeralKey: ephemeralKey.Secret
            );
        }

        public async Task<bool> IsUserPaidMember(int userId, int studioId)
        {
            var payment = await _dbContext.Payments.FirstOrDefaultAsync(ss => ss.StudioId == studioId && ss.UserId == userId);

            return payment == null ? false : true;
        }

        public async Task<bool> RefundPayment(int userId, int studioId)
        {
            var payment = await _dbContext.Payments.FirstOrDefaultAsync(ss => ss.StudioId == studioId && ss.UserId == userId);
            var paymentIntentService = new PaymentIntentService();
            var paymentIntent = await paymentIntentService.GetAsync(payment!.PaymentIntentId);

            if (paymentIntent.Status != "succeeded")
                return false;

            var paymentRefundService = new Stripe.RefundService();
            var options = new RefundCreateOptions
            {
                PaymentIntent = payment!.PaymentIntentId,
                Reason = RefundReasons.RequestedByCustomer,
            };

            var result = await paymentRefundService.CreateAsync(options);

            await SendMessageToRabbitMQ(userId, studioId, result.Amount, paymentIntent.Id);
            return true;
        }

        private async Task SendMessageToRabbitMQ(int userId, int studioId, decimal amount, string paymentIntentId)
        {
            using var connection = await _connectionFactory.CreateConnectionAsync();
            using var channel = await connection.CreateChannelAsync();

            await channel.QueueDeclareAsync(
                queue: _rabbitMqSettings.QueueName!,
                durable: false,
                autoDelete: false,
                exclusive: false,
                arguments: null
            );

            var paymentMessage = new Models.Payment()
            {
                UserId = userId,
                StudioId = studioId,
                CreatedAt = DateTime.Now,
                PaymentDate = DateTime.Now,
                Amount = amount,
                Status = PaymentStatus.Processing.ToString(),
                PaymentIntentId = paymentIntentId
            };

            var body = Encoding.UTF8.GetBytes(JsonSerializer.Serialize(paymentMessage));
            await channel.BasicPublishAsync("", _rabbitMqSettings.QueueName!, body);
        }
    }
}