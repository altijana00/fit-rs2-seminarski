using AutoMapper;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ZEN_Yoga.Models;
using ZEN_Yoga.Models.Responses;
using ZEN_Yoga.Services.Interfaces.SubscriptionType;

namespace ZEN_Yoga.Services.Services.SubscriptionType
{
    public class GetSubscriptionTypeService : IGetSubscriptionTypeService
    {
        private readonly ZenYogaDbContext _dbContext;
        private readonly IMapper _mapper;

        public GetSubscriptionTypeService(ZenYogaDbContext dbContext, IMapper mapper)
        {
            _dbContext = dbContext;
            _mapper = mapper;
        }

        public async Task<List<SubscriptionTypeResponse>> GetAll()
        {
            var subscriptions = await _dbContext.SubscriptionTypes.ToListAsync();
            return _mapper.Map<List<SubscriptionTypeResponse>>(subscriptions);
        }

        public async Task<SubscriptionTypeResponse> GetById(int id)
        {
            var subscriptionType = await _dbContext.SubscriptionTypes.FirstOrDefaultAsync(s => s.Id == id);
            return _mapper.Map<SubscriptionTypeResponse>(subscriptionType);
        }
    }
}
