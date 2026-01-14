using Microsoft.EntityFrameworkCore;
using ZEN_Yoga.Models;
using ZEN_Yoga.Services.Interfaces.UserStudio;

namespace ZEN_Yoga.Services.Services.UserStudio
{
    public class UpsertUserStudioService : IUpsertUserStudioService
    {
        private readonly ZenYogaDbContext _dbContext;

        public UpsertUserStudioService(ZenYogaDbContext dbContext)
        {
            _dbContext = dbContext;
        }

        public async Task<bool> Add(int userId, int studioId, int subscriptionTypeId)
        {
            var subscription = await _dbContext.StudioSubscriptions.FirstOrDefaultAsync(ss => ss.StudioId == studioId && ss.SubscriptionTypeId == subscriptionTypeId);

            if (subscription == null)
            {
                return false;
            }

            var subType = await _dbContext.SubscriptionTypes.FindAsync(subscription.SubscriptionTypeId);

            if (subType == null)
            {
                return false;



            }

            var days = subType.DurationInDays;
            var userStudio = new Models.UserStudio()
            {
                UserId = userId,
                StudioId = studioId,
                JoinedAt = DateTime.Now,
                SubscriptionStart = DateTime.Now,
                SubscriptionEnd = DateTime.Now.AddDays(days),
                isActive = true,

            };
            await _dbContext.UsersStudios.AddAsync(userStudio);
            await _dbContext.SaveChangesAsync();
            return true;





        }
    }
}
