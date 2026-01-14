using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Options;
using RabbitMQ.Client;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.Json;
using System.Threading.Tasks;
using ZEN_Yoga.Models;
using ZEN_Yoga.Services.Configurations;
using ZEN_Yoga.Services.Interfaces.Payment;

namespace ZEN_Yoga.Services.Services.Payment
{

    public class PaymentService : IPaymentService
    {
        private readonly ZenYogaDbContext _dbContext;

        private readonly RabbitMqSettings _rabbitMqSettings;

        public PaymentService(ZenYogaDbContext dbContext, IOptions<RabbitMqSettings> options)
        {
            _dbContext = dbContext;
            _rabbitMqSettings = options.Value;
        }

        public async Task<bool> AddPayment(int userId, int studioId)
        {
            var payment = await _dbContext.Payments.FirstOrDefaultAsync(ss => ss.StudioId == studioId && ss.UserId == userId);

            if (payment != null)
            {
                return false;
            }

           


            var factory = new ConnectionFactory()
            {
                HostName = _rabbitMqSettings.Host!,
                Port = int.Parse(_rabbitMqSettings.Port!),
                UserName = _rabbitMqSettings.User!,
                Password = _rabbitMqSettings.Password!
            };

            using var connection = await factory.CreateConnectionAsync();
            using var channel = await connection.CreateChannelAsync();

            await channel.QueueDeclareAsync(
                queue: "events",
                durable: false,
                autoDelete: false,
                exclusive: false,
                arguments: null
            );

            var paymentMessage = new Models.Payment()
            {
                UserId = userId,
                StudioId = studioId,
                SubscriptionTypeId = 1,
                CreatedAt = DateTime.Now,
                PaymentDate = DateTime.Now,
                Amount = 50,
                Status = "procsessing"
            };

            var body = Encoding.UTF8.GetBytes(JsonSerializer.Serialize(paymentMessage));

            await channel.BasicPublishAsync("", "events", body);

            return true;
        }

    

        public async Task<bool> IsUserPaidMember(int userId, int studioId)
        {
            var payment = await _dbContext.Payments.FirstOrDefaultAsync(ss => ss.StudioId == studioId && ss.UserId == userId);

            return payment == null ? false : true;
            
        }
    }
}
