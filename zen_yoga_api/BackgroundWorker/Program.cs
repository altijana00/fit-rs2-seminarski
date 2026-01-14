using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using ZEN_Yoga.Models;

using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;

await Host.CreateDefaultBuilder(args)
    .ConfigureServices((hostContext, services) =>
    {
        services.AddDbContext<ZenYogaDbContext>(options =>
            options.UseSqlServer(hostContext.Configuration.GetConnectionString("DefaultConnection")));

        services.AddHostedService<RabbitMqListener>();
    }).RunConsoleAsync();
