using AutoMapper;
using Microsoft.EntityFrameworkCore;
using ZEN_Yoga.Models;
using ZEN_Yoga.Models.Requests;
using ZEN_Yoga.Services.Interfaces.Notification;

namespace ZEN_Yoga.Services.Services.Notifications
{
    public class UpsertNotificationService : IUpsertNotificationService<AddNotification>
    {
        private readonly IMapper _mapper;
        private readonly ZenYogaDbContext _dbContext;

        public UpsertNotificationService(IMapper mapper, ZenYogaDbContext dbContext)
        {
            _dbContext = dbContext;
            _mapper = mapper;
        }

        public async Task Add(AddNotification addNotification)
        {
            var notification = _mapper.Map<Notification>(addNotification);
            notification.IsRead = false;
            notification.CreatedAt = DateTime.Now;

            await _dbContext.Notifications.AddAsync(notification);

            await _dbContext.SaveChangesAsync();
        }

        public async Task Edit(EditNotification editNotification, int id)
        {
            var notification = await _dbContext.Notifications.FirstOrDefaultAsync(u => u.Id == id);

            if (notification != null)
            {
                _mapper.Map(editNotification, notification);
                await _dbContext.SaveChangesAsync();
            }
        }

        public async Task ToggleReadNotification(int id)
        {
            var notification = await _dbContext.Notifications.FirstOrDefaultAsync(u => u.Id == id);

            if (notification != null)
            {
                notification.IsRead = !notification.IsRead;
                await _dbContext.SaveChangesAsync();
            }
        }
    }
}