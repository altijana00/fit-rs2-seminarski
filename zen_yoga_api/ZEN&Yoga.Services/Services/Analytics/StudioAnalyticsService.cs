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
    public class StudioAnalyticsService : IStudioAnalyticsService
    {

        private readonly ZenYogaDbContext _dbContext;
        public StudioAnalyticsService(ZenYogaDbContext dbContext)
        {
            _dbContext = dbContext;
        }
        public async Task<float> GetByStudio(int studioId)
        {
            float paymentsAmount = 0;

            var payments = await _dbContext.Payments.Where(p => p.StudioId == studioId).ToListAsync();

            paymentsAmount = 50 * (payments.Count);

            return paymentsAmount;
        }

        public async Task<int> GetNumberofParticipants(int studioId)
        {
            int participantsNumber = 0;
            
            var participants = await _dbContext.Payments.Where(p => p.StudioId == studioId).ToListAsync();

            participantsNumber = participants.Count;

            return participantsNumber;
        }

        public async Task<List<StudioParticipantsByCityResponse>> GetMostPopularStudioCities()
        {

            var studios = await _dbContext.Studios.ToListAsync();

            var cityTotals = new Dictionary<string, int>();

            foreach (var s in studios)
            {
                var participants = await GetNumberofParticipants(s.Id);
                var city = await _dbContext.Cities.FirstOrDefaultAsync(c => c.Id == s.CityId);

                if (city != null && participants>0) 
                {
                    if (cityTotals.ContainsKey(city.Name))
                        cityTotals[city.Name] += participants;
                    else
                        cityTotals[city.Name] = participants;
                }

                
            }

            return cityTotals
                .Select(ct => new StudioParticipantsByCityResponse
                {
                    CityName = ct.Key,
                    NumberOfParticipants = ct.Value
                })
                .OrderByDescending(x => x.NumberOfParticipants)
                .Take(3)
                .ToList();

        }

        public async Task<int> GetNumberofEmployees(int studioId)
        {
            int employeesNumber = 0;

            var employees = await _dbContext.Instructors.Where(i => i.StudioId == studioId).ToListAsync();

            employeesNumber = employees.Count;

            return employeesNumber;
        }
    }
}
