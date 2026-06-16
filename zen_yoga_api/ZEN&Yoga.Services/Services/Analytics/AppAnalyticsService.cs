using Microsoft.EntityFrameworkCore;
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
                CreatedAt = DateTime.UtcNow,
                TotalStudios = studios,
                TotalUsers = users
            };


            await _dbContext.AppAnalytics.AddAsync(appAnalytics);
            await _dbContext.SaveChangesAsync();

            return appAnalytics;
        }

        public async Task<ParticipantAnalyticsResponse> GetAppAnalyticsForParticipant(int userId)
        {

            var numberOfStudios = await _dbContext.Payments.CountAsync(p => p.UserId == userId);
            var numberOfClasses = await _dbContext.UserClasses.CountAsync(uc=> uc.UserId == userId);


            var appAnalytics = new ParticipantAnalyticsResponse()
            {
                NumberOfStudios = numberOfStudios,
                NumberOfClasses = numberOfClasses
            };

            return appAnalytics;
        }
    }
}
