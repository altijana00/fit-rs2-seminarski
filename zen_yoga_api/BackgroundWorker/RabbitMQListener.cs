using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using RabbitMQ.Client;
using Stripe;
using System.Text;
using System.Text.Json;
using ZEN_Yoga.Models;
using ZEN_Yoga.Models.Enums;

public class RabbitMqListener : BackgroundService
{
    private readonly IServiceScopeFactory _scopeFactory;
    private readonly string _rabbitHost;
    private readonly string _rabbitQueue;

    public RabbitMqListener(IServiceScopeFactory scopeFactory, IConfiguration configuration)
    {
        _rabbitHost = configuration["RabbitMQ:Host"] ?? throw new ArgumentNullException("RabbitMQ:Host");
        _rabbitQueue = configuration["RabbitMQ:Queue"] ?? throw new ArgumentNullException("RabbitMQ:Queue");
        _scopeFactory = scopeFactory;
        StripeConfiguration.ApiKey = configuration["StripeSettings:SecretKey"] ?? throw new ArgumentNullException("StripeSettings:SecretKey");
    }

    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        var factory = new ConnectionFactory() { HostName = _rabbitHost };
        using var connection = await factory.CreateConnectionAsync();
        using var channel = await connection.CreateChannelAsync();

        await channel.QueueDeclareAsync(
            queue: _rabbitQueue,
            durable: false,
            autoDelete: false,
            exclusive: false,
            arguments: null
        );

        while (!stoppingToken.IsCancellationRequested)
        {
            var result = await channel.BasicGetAsync(_rabbitQueue, true);

            if (result != null)
            {
                var message = Encoding.UTF8.GetString(result.Body.ToArray());

                var paymentMessage = JsonSerializer.Deserialize<ZEN_Yoga.Models.Payment>(message, new JsonSerializerOptions
                {
                    PropertyNameCaseInsensitive = true
                });

                var service = new PaymentIntentService();
                var paymentIntent = await service.GetAsync(paymentMessage!.PaymentIntentId);
                paymentMessage.Status = MapPaymentProcessingStatus(paymentIntent.Status).ToString();
                

                using var scope = _scopeFactory.CreateScope();
                var dbContext = scope.ServiceProvider.GetRequiredService<ZenYogaDbContext>();

                await dbContext.Payments.AddAsync(paymentMessage!, stoppingToken);
                await dbContext.SaveChangesAsync(stoppingToken);
            }

            await Task.Delay(1000, stoppingToken);
        }
    }

    private PaymentStatus MapPaymentProcessingStatus(string status)
    {
        return status switch
        {   
            "succeeded" => PaymentStatus.Succeeded,
            "canceled" => PaymentStatus.Canceled,
            "requires_capture" => PaymentStatus.Requires_Capture,
            "requires_reauthorization" => PaymentStatus.Requires_Reauthorization,
            "requires_confirmation" => PaymentStatus.Requires_Confirmation,
            "requires_action" => PaymentStatus.Requires_Action,
            _ => PaymentStatus.Processing
        };
    }
}
