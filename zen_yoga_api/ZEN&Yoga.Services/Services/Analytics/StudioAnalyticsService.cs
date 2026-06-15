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
        //public async Task<float> GetByStudio(int studioId)
        //{
        //    float paymentsAmount = 0;

        //    var payments = await _dbContext.Payments.Where(p => p.StudioId == studioId).ToListAsync();

        //    var studio = await _dbContext.Studios.FirstOrDefaultAsync(s => s.Id == studioId);

        //    paymentsAmount = studio!.MembershipPrice * (payments.Count);

        //    return paymentsAmount;
        //}



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
        //public async Task<int> GetNumberofParticipants(int studioId)
        //{
        //    int participantsNumber = 0;

        //    var participants = await _dbContext.Payments.Where(p => p.StudioId == studioId).ToListAsync();

        //    participantsNumber = participants.Count;

        //    return participantsNumber;
        //}

        public async Task<int> GetNumberofParticipants(int studioId)
        {
            return await _dbContext.Payments.CountAsync(p => p.StudioId == studioId);
        }

        //public async Task<List<StudioParticipantsByCityResponse>> GetMostPopularStudioCities()
        //{

        //    var studios = await _dbContext.Studios.ToListAsync();

        //    var cityTotals = new Dictionary<string, int>();

        //    foreach (var s in studios)
        //    {
        //        var participants = await GetNumberofParticipants(s.Id);
        //        var city = await _dbContext.Cities.FirstOrDefaultAsync(c => c.Id == s.CityId);

        //        if (city != null && participants>0) 
        //        {
        //            if (cityTotals.ContainsKey(city.Name))
        //                cityTotals[city.Name] += participants;
        //            else
        //                cityTotals[city.Name] = participants;
        //        }


        //    }

        //    return cityTotals
        //        .Select(ct => new StudioParticipantsByCityResponse
        //        {
        //            CityName = ct.Key,
        //            NumberOfParticipants = ct.Value
        //        })
        //        .OrderByDescending(x => x.NumberOfParticipants)
        //        .Take(3)
        //        .ToList();

        //}

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

        // TODO CHECK USED OR NOT ?
        public async Task<int> GetNumberofEmployees(int studioId)
        {
            int employeesNumber = 0;

            var employees = await _dbContext.Instructors.Where(i => i.StudioId == studioId).ToListAsync();

            employeesNumber = employees.Count;

            return employeesNumber;
        }
    }
}
