using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ZEN_Yoga.Models;
using ZEN_Yoga.Models.Exceptions;
using ZEN_Yoga.Services.Interfaces.SubscriptionType;

namespace ZEN_Yoga.Services.Services.SubscriptionType
{
    public class SubscriptionTypeValidatorService : ISubscriptionTypeValidatorService
    {
        private readonly ZenYogaDbContext _dbContext;


        public SubscriptionTypeValidatorService(ZenYogaDbContext dbContext)
        {
            _dbContext = dbContext;

        }
        public async Task<bool> ValidateSubscriptionTypeId(int id)
        {
            var subscriptionType = await _dbContext.SubscriptionTypes.FirstOrDefaultAsync(s => s.Id == id);

            if (subscriptionType == null)
            {
                throw new SubscriptionTypeNotFoundException("Invalid subscription type!");

            }

            return true;
        }
    }
}
