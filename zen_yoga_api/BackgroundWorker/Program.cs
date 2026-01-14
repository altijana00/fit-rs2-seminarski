using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using ZEN_Yoga.Models;

using Microsoft.EntityFrameworkCore;

await Host.CreateDefaultBuilder(args)
    .ConfigureServices((hostContext, services) =>
    {
        services.AddDbContext<ZenYogaDbContext>(options =>
            options.UseSqlServer("server=DESKTOP-S0V3M5R\\SQLEXPRESS;database=190015;User Id=test;Password=seminarski123;trusted_connection=true; Trust Server Certificate=true"));

        services.AddHostedService<RabbitMqListener>();
    }).RunConsoleAsync();
