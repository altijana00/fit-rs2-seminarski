using AutoMapper;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ZEN_Yoga.Models;
using ZEN_Yoga.Models.Requests;
using ZEN_Yoga.Services.Interfaces.StudioSubscription;

namespace ZEN_Yoga.Services.Services.StudioSubscription
{
    public class UpsertStudioSubscriptionService : IUpsertStudioSubscriptionService<AddStudioSubscription>
    {
        private readonly ZenYogaDbContext _dbContext;
        private readonly IMapper _mapper;

        public UpsertStudioSubscriptionService(ZenYogaDbContext dbContext, IMapper mapper)
        {
            _dbContext = dbContext;
            _mapper = mapper;
        }

      

        public async Task<bool> Add(int studioId, int subscriptionTypeId, AddStudioSubscription addStudioSubscription)
        {
            var exists = await _dbContext.StudioSubscriptions.FirstOrDefaultAsync(ss => ss.StudioId == studioId && ss.SubscriptionTypeId == subscriptionTypeId);
            var studio = await _dbContext.Studios.FirstOrDefaultAsync(s => s.Id == studioId);
            var subscriptionType = await _dbContext.SubscriptionTypes.FirstOrDefaultAsync(st => st.Id == subscriptionTypeId);


            if (exists == null && studio != null && subscriptionType != null)
            {
                var studioSubscription = new Models.StudioSubscription
                {
                    StudioId = studioId,
                    Studio = studio,
                    SubscriptionTypeId = subscriptionTypeId,
                    SubscriptionType = subscriptionType,
                    Price = addStudioSubscription.Price,
                    Description = addStudioSubscription.Description
                };

                await _dbContext.StudioSubscriptions.AddAsync(studioSubscription);
                await _dbContext.SaveChangesAsync();
                return true;
            }
            return false;


        }
        

        public async Task Edit(EditSubscription editSubscription, int id)
        {
            var subscription = await _dbContext.StudioSubscriptions.FirstOrDefaultAsync(ss => ss.Id == id);

            if (subscription != null)
            {

                subscription.Description = editSubscription.Description;
                subscription.Price = editSubscription.Price;

                await _dbContext.SaveChangesAsync();
            }
        }
    }
}
