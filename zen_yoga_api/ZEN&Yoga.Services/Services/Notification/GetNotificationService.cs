using AutoMapper;
using Microsoft.EntityFrameworkCore;
using ZEN_Yoga.Models;
using ZEN_Yoga.Models.Requests;
using ZEN_Yoga.Models.Responses;
using ZEN_Yoga.Models.SearchObjects;
using ZEN_Yoga.Services.Interfaces.Notification;
using static Microsoft.EntityFrameworkCore.DbLoggerCategory;

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
        public async Task<PagedResponse<NotificationResponse>> GetAll(PagedRequest request)
        {
            var query = _dbContext.Notifications
                                  .AsNoTracking()
                                  .OrderByDescending(r => r.Id);

            var totalCount = await query.CountAsync();

            var result = await query
                .Skip((request.Page - 1) * request.PageSize)
                .Take(request.PageSize)
                .ToListAsync();

            return new PagedResponse<NotificationResponse>
            {
                Items = _mapper.Map<List<NotificationResponse>>(result),
                TotalCount = totalCount,
                Page = request.Page,
                PageSize = request.PageSize
            };
        }

        public async Task<NotificationResponse> GetById(int id)
        {
            var notification = await _dbContext.Notifications.AsNoTracking().FirstOrDefaultAsync(c => c.Id == id);

            return _mapper.Map<NotificationResponse>(notification);
        }

        public async Task<List<NotificationResponse>> GetByUserId(int userId)
        {
            var notifications = await _dbContext.Notifications.AsNoTracking().Where(c => c.UserId == userId).ToListAsync();

            return _mapper.Map<List<NotificationResponse>>(notifications).OrderByDescending(n => n.Id).ToList();
        }

        public async Task<PagedResponse<NotificationResponse>> GetNotificationsQuery(NotificationQuery notificationQuery, PagedRequest request)
        {
            IQueryable<ZEN_Yoga.Models.Notification> query = _dbContext.Notifications.AsNoTracking().AsQueryable();

            if (!string.IsNullOrWhiteSpace(notificationQuery.Search))
            {
                var search = notificationQuery.Search.ToLower();

                query = query.Where(u =>
                    u.Title.ToLower().Contains(search)

                );
            }

            query = query.OrderByDescending(c => c.Id);
            var totalCount = await query.CountAsync();

            var results = await query
               .Skip((request.Page - 1) * request.PageSize)
               .Take(request.PageSize)
               .ToListAsync();


            return new PagedResponse<NotificationResponse>
            {
                Items = _mapper.Map<List<NotificationResponse>>(results),
                TotalCount = totalCount,
                Page = request.Page,
                PageSize = request.PageSize
            };


        }
    }
}
