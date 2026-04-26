using AutoMapper;
using Microsoft.EntityFrameworkCore;
using ZEN_Yoga.Models;
using ZEN_Yoga.Models.Responses;
using ZEN_Yoga.Models.SearchObjects;
using ZEN_Yoga.Services.Interfaces.Notification;

namespace ZEN_Yoga.Services.Services.Notifications
{
    public class GetNotificationService : IGetNotificationService
    {
        private readonly ZenYogaDbContext _dbContext;
        private readonly IMapper _mapper;

        public GetNotificationService(ZenYogaDbContext dbContext, IMapper mapper)
        {
            _dbContext = dbContext;
            _mapper = mapper;

        }
        public async Task<List<NotificationResponse>> GetAll()
        {
            var notifications = await _dbContext.Notifications.ToListAsync();

            return _mapper.Map<List<NotificationResponse>>(notifications);
        }

        public async Task<NotificationResponse> GetById(int id)
        {
            var notification = await _dbContext.Notifications.FirstOrDefaultAsync(c => c.Id == id);

            return _mapper.Map<NotificationResponse>(notification);
        }

        public async Task<List<NotificationResponse>> GetByUserId(int userId)
        {
            var notifications = await _dbContext.Notifications.Where(c => c.UserId == userId).ToListAsync();

            return _mapper.Map<List<NotificationResponse>>(notifications);
        }

        public async Task<List<NotificationResponse>> GetNotificationsQuery(NotificationQuery notificationQuery)
        {
            IQueryable<ZEN_Yoga.Models.Notification> notifications = _dbContext.Notifications.AsQueryable();

            if (!string.IsNullOrWhiteSpace(notificationQuery.Search))
            {
                var search = notificationQuery.Search.ToLower();

                notifications = notifications.Where(u =>
                    u.Title.ToLower().Contains(search)

                );
            }


            var result = await notifications.ToListAsync();
            return _mapper.Map<List<NotificationResponse>>(result);
        }
    }
}
