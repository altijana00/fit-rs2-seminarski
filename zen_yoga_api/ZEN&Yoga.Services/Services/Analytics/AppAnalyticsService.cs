using AutoMapper;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ZEN_Yoga.Models;
using ZEN_Yoga.Models.Responses;
using ZEN_Yoga.Services.Interfaces.Analytics;

namespace ZEN_Yoga.Services.Services.Analytics
{
    public class AppAnalyticsService : IAppAnalyticsService
    {
        
        private readonly ZenYogaDbContext _dbContext;

        public AppAnalyticsService(ZenYogaDbContext dbContext)
        {
            
            _dbContext = dbContext;
        }

        public async Task<AppAnalytics> GetAppAnalytics()
        {
            var studios = await _dbContext.Studios.CountAsync();
            var users = await _dbContext.Users.CountAsync();


            var appAnalytics = new AppAnalytics()
            {
                CreatedAt = DateTime.Now,
                TotalStudios = studios,
                TotalUsers = users
            };


            await _dbContext.AppAnalytics.AddAsync(appAnalytics);
            await _dbContext.SaveChangesAsync();

            return appAnalytics;
        }
    }
}
