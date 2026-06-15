using Microsoft.EntityFrameworkCore;
using ZEN_Yoga.Models;
using ZEN_Yoga.Models.Responses;
using ZEN_Yoga.Services.Interfaces.Analytics;

namespace ZEN_Yoga.Services.Services.Analytics
{
    public class StudioAnalyticsService : IStudioAnalyticsService
    {

        private readonly ZenYogaDbContext _dbContext;
        public StudioAnalyticsService(ZenYogaDbContext dbContext)
        {
            _dbContext = dbContext;
        }


        public async Task<float> GetByStudio(int studioId)
        {

            var membershipPrice = await _dbContext.Studios
                .Where(s => s.Id == studioId)
                .Select(s => s.MembershipPrice)
                .FirstOrDefaultAsync();

            var participantCount = await _dbContext.Payments
                .CountAsync(p => p.StudioId == studioId);

            return membershipPrice * participantCount;

        }

        public async Task<int> GetNumberofParticipants(int studioId)
        {
            return await _dbContext.Payments.CountAsync(p => p.StudioId == studioId);
        }
     

        public async Task<List<StudioParticipantsByCityResponse>> GetMostPopularStudioCities()
        {
            return await _dbContext.Studios
                .Where(s => _dbContext.Payments.Any(p => p.StudioId == s.Id))
                .GroupJoin(
                    _dbContext.Payments,
                    s => s.Id,
                    p => p.StudioId,
                    (s, payments) => new { s.CityId, ParticipantCount = payments.Count() }
                )
                .Join(
                    _dbContext.Cities,
                    s => s.CityId,
                    c => c.Id,
                    (s, c) => new { c.Name, s.ParticipantCount }
                )
                .GroupBy(x => x.Name)
                .Select(g => new StudioParticipantsByCityResponse
                {
                    CityName = g.Key,
                    NumberOfParticipants = g.Sum(x => x.ParticipantCount)
                })
                .OrderByDescending(x => x.NumberOfParticipants)
                .Take(3)
                .ToListAsync();

        }
        
    }
}
