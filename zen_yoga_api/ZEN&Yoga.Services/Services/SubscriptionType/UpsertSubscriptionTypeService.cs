using AutoMapper;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ZEN_Yoga.Models;
using ZEN_Yoga.Models.Requests;
using ZEN_Yoga.Services.Interfaces.Studio;
using ZEN_Yoga.Services.Interfaces.SubscriptionType;

namespace ZEN_Yoga.Services.Services.SubscriptionType
{
    public class UpsertSubscriptionTypeService : IUpsertSubscriptionTypeService<AddSubscriptionType>
    {
        private readonly IMapper _mapper;
        private readonly ZenYogaDbContext _dbContext;


        public UpsertSubscriptionTypeService(IMapper mapper, ZenYogaDbContext dbContext)
        {
            _dbContext = dbContext;
            _mapper = mapper;

        }

        public async Task Add(AddSubscriptionType addSubscriptionType)
        {
            var subscriptionType = _mapper.Map<Models.SubscriptionType>(addSubscriptionType);

            await _dbContext.SubscriptionTypes.AddAsync(subscriptionType);

            await _dbContext.SaveChangesAsync();
        }

        public async Task Edit(EditSubscriptionType editSubscriptionType, int id)
        {
            var subscriptionType = await _dbContext.SubscriptionTypes.FirstOrDefaultAsync(u => u.Id == id);

            if (subscriptionType != null)
            {
                _mapper.Map(editSubscriptionType, subscriptionType);

                await _dbContext.SaveChangesAsync();
            }
        }
    }
}
