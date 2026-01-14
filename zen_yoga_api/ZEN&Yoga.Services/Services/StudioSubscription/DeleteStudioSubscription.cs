using AutoMapper;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ZEN_Yoga.Models;
using ZEN_Yoga.Services.Interfaces.Base;
using ZEN_Yoga.Services.Interfaces.StudioSubscription;

namespace ZEN_Yoga.Services.Services.StudioSubscription
{
    public class DeleteStudioSubscription : IDeleteStudioSubscriptionService
    {
        private readonly ZenYogaDbContext _dbContext;
       
        public DeleteStudioSubscription(ZenYogaDbContext dbContext)
        {
            _dbContext = dbContext;
          
        }
        public async Task<bool> Delete(int id)
        {
            if (id != 0)
            {
                var subscription = await
                    _dbContext.StudioSubscriptions.FirstOrDefaultAsync(ss => ss.Id == id);

                if (subscription != null)
                {
                    _dbContext.Remove(subscription);
                    await _dbContext.SaveChangesAsync();
                    return true;
                }
                return false;

            }
            return false;
        }
    }
}
