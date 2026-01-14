using AutoMapper;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ZEN_Yoga.Models;
using ZEN_Yoga.Models.Responses;
using ZEN_Yoga.Services.Interfaces.StudioSubscription;

namespace ZEN_Yoga.Services.Services.StudioSubscription
{
    public class GetStudioSubscriptionService : IGetStudioSubscriptionService
    {
        private readonly ZenYogaDbContext _dbContext;
        private readonly IMapper _mapper;

        public GetStudioSubscriptionService(ZenYogaDbContext dbContext, IMapper mapper)
        {
            _dbContext = dbContext;
            _mapper = mapper;
        }
        public async Task<List<StudioSubscriptionResponse>> GetAll()
        {


            var subscriptions = await _dbContext.StudioSubscriptions
                .Include(ss => ss.Studio)
                .Include(ss => ss.SubscriptionType)
                .Select(ss => new StudioSubscriptionResponse
                {
                    Id = ss.Id,
                    StudioId = ss.StudioId,
                    SubscriptionTypeId = ss.SubscriptionTypeId,
                    Name = ss.SubscriptionType.Name,
                    Description = ss.SubscriptionType.Description + " " + ss.Description,
                    DurationInDays = ss.SubscriptionType.DurationInDays,
                    Price = ss.Price


                }).ToListAsync();

            return _mapper.Map<List<StudioSubscriptionResponse>>(subscriptions);



        }

        public async Task<StudioSubscriptionResponse> GetById(int id)
        {
            var subscriptions = await GetAll();

            return subscriptions.FirstOrDefault(s => s.Id == id);
        }
    }
}
