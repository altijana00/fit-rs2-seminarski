using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ZEN_Yoga.Models;
using ZEN_Yoga.Services.Interfaces.SubscriptionType;

namespace ZEN_Yoga.Services.Services.SubscriptionType
{
    public class DeleteSubscriptionTypeService : IDeleteSubscriptionTypeService
    {
        private readonly ZenYogaDbContext _dbContext;


        public DeleteSubscriptionTypeService(ZenYogaDbContext dbContext)
        {

            _dbContext = dbContext;

        }

        public async Task<bool> Delete(int id)
        {
            var subscriptionType = await _dbContext.SubscriptionTypes.FirstOrDefaultAsync(u => u.Id == id);
            var payments = await _dbContext.Payments.Where(u=> u.SubscriptionTypeId == id).ToListAsync();

            if (subscriptionType != null)
            {
                if (payments.Any())
                {
                    return false;
                }

                _dbContext.Remove(subscriptionType);
                await _dbContext.SaveChangesAsync();
                return true;
            }
            return false;
        }
    }
}
