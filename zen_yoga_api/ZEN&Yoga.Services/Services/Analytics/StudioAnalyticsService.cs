using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ZEN_Yoga.Models;
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

        public async Task<int> GetNumberofEmployees(int studioId)
        {
            int employeesNumber = 0;

            var employees = await _dbContext.Instructors.Where(i => i.StudioId == studioId).ToListAsync();

            employeesNumber = employees.Count;

            return employeesNumber;
        }
    }
}
