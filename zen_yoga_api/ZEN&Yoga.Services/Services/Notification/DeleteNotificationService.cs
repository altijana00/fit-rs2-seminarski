using Microsoft.EntityFrameworkCore;
using ZEN_Yoga.Models;
using ZEN_Yoga.Services.Interfaces.Notification;

namespace ZEN_Yoga.Services.Services.Notifications
{
    public class DeleteNotificationService : IDeleteNotificationService
    {
        private readonly ZenYogaDbContext _dbContext;

        public DeleteNotificationService(ZenYogaDbContext dbContext)
        {
            _dbContext = dbContext;
        }

        public async Task<bool> Delete(int id)
        {
            var notification = await _dbContext.Notifications.FirstOrDefaultAsync(i => i.Id == id);

            if (notification != null)
            {
                _dbContext.Remove(notification);
                await _dbContext.SaveChangesAsync();
                return true;
            }

            return false;
        }
    }
}
