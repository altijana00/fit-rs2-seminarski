using Microsoft.AspNetCore.Mvc;
using ZEN_Yoga.Services.Interfaces.Notification;

namespace ZEN_YogaWebAPI.Controllers
{
    [Route("api/[controller]")]
    public class NotificationController : ControllerBase
    {
        private readonly INotificationService _notificationService;

        public NotificationController(INotificationService notificationService)
        {
            _notificationService = notificationService;
        }
    }
}
