using ZEN_Yoga.Models.Requests;
using ZEN_Yoga.Models.Responses;
using ZEN_Yoga.Models.SearchObjects;
using ZEN_Yoga.Services.Interfaces.Base;

namespace ZEN_Yoga.Services.Interfaces.Notification
{
    public interface IGetNotificationService : IGetService<Models.Notification, NotificationResponse>
    {
        Task<PagedResponse<NotificationResponse>> GetNotificationsQuery(NotificationQuery notificationQuery, PagedRequest request);

        Task<List<NotificationResponse>> GetByUserId(int userId);
    }
}
