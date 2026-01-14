using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using RabbitMQ.Client;
using System.Text.Json;
using System.Text;
using ZEN_Yoga.Models;
using Microsoft.Extensions.Configuration;

public class RabbitMqListener : BackgroundService
{
    private readonly IServiceScopeFactory _scopeFactory;
    private readonly string _rabbitHost;
    private readonly string _rabbitQueue;


    public RabbitMqListener(IServiceScopeFactory scopeFactory, IConfiguration configuration)
    {
        _rabbitHost = configuration["RabbitMQ:Host"] ?? "rabbitmq";
        _rabbitQueue = configuration["RabbitMQ:Queue"] ?? "rabbitmq";

        _scopeFactory = scopeFactory;
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

                using var scope = _scopeFactory.CreateScope();
                var dbContext = scope.ServiceProvider.GetRequiredService<ZenYogaDbContext>();

                await dbContext.Payments.AddAsync(paymentMessage, stoppingToken);
                await dbContext.SaveChangesAsync(stoppingToken);
            }

            await Task.Delay(1000, stoppingToken);
        }
    }
}
