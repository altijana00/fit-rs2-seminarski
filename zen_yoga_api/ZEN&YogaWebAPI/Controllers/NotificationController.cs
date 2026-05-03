using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;
using ZEN_Yoga.Models.Enums;
using ZEN_Yoga.Models.Requests;
using ZEN_Yoga.Models.Responses;
using ZEN_Yoga.Models.SearchObjects;
using ZEN_Yoga.Services.Interfaces.Notification;

namespace ZEN_YogaWebAPI.Controllers
{
    [Route("api/[controller]")]
    public class NotificationController : ControllerBase
    {

        private readonly ILogger<NotificationController> _logger;
        public NotificationController(ILogger<NotificationController> logger)
        {
            _logger = logger;
        }

        [Authorize(Roles = "1")]
        [HttpGet("getAll")]
        public async Task<ActionResult<List<NotificationResponse>>> GetAll([FromServices] IGetNotificationService getNotificationService)
        {
            var notifications = await getNotificationService.GetAll();

            if (notifications == null)
            {
                _logger.LogInformation("No notifications found");
                return NoContent();
            }
            _logger.LogInformation($"Notifications retrieved: {notifications.Count}");
            return Ok(notifications);
        }

        [Authorize(Roles = "1")]
        [HttpGet("getById")]
        public async Task<ActionResult<NotificationResponse>> GetById([FromServices] IGetNotificationService getNotificationService, int id)
        {
            var notification = await getNotificationService.GetById(id);

            if (notification == null)
            {
                _logger.LogInformation("No notifications found");

                return NoContent();
            }
            _logger.LogInformation($"Notification retrieved (ID): {id}");
            return Ok(notification);
        }

        [Authorize(Roles = "1")]
        [HttpGet("getNotificationsQuery")]
        public async Task<ActionResult<List<NotificationResponse>>> GetNotificationsQuery([FromServices] IGetNotificationService getNotificationService, [FromQuery] NotificationQuery notificationQuery)
        {
            var nofications = await getNotificationService.GetNotificationsQuery(notificationQuery);

            if (nofications == null)
            {
                _logger.LogInformation("No notifications found");
                return NoContent();
            }
            _logger.LogInformation($"Successfully retrieved notification with query: {notificationQuery.Search} ");

            return Ok(nofications);
        }

        [Authorize(Roles = "1")]
        [HttpPost("add")]
        public async Task<IActionResult> AddNotification([FromBody] AddNotification addNotification, [FromServices] IUpsertNotificationService<AddNotification> upsertNotificationService)
        {
            if (upsertNotificationService == null)
            {
                _logger.LogInformation($"Attempt to add notification with bad data");
                return BadRequest();

            }

            await upsertNotificationService.Add(addNotification);
            _logger.LogInformation($"Success: Added notification");
            return Ok(new { Message = "Notification added successfully!" });
        }

        [Authorize(Roles = "1")]
        [HttpPut("edit")]
        public async Task<IActionResult> EditNotification([FromBody] EditNotification editNotification, int id, [FromServices] IUpsertNotificationService<AddNotification> upsertNotificationService)
        {
            if (editNotification == null)
            {
                _logger.LogInformation($"Attempt to edit notification with bad data");

                return BadRequest();
            }

            await upsertNotificationService.Edit(editNotification, id);
            _logger.LogInformation($"Success: Edited notification");
            return Ok(new { Message = "Changes saved successfully!" });
        }

        [Authorize(Roles = "1, 2, 3, 4")]
        [HttpGet("getByUserId")]
        public async Task<ActionResult<NotificationResponse>> GetByUserId([FromServices] IGetNotificationService getNotificationService, int userId)
        {
            var userIdClaim = User.FindFirst("id")?.Value;
            var userRole = User.FindFirst(ClaimTypes.Role)?.Value;

            if (int.Parse(userIdClaim!) != userId && int.Parse(userRole!) != (int)RoleType.Admin)
            {
                _logger.LogWarning($"Unauthorized attempt to read  notifications by user: {userId}");
                return Unauthorized();
            }

            var notifications = await getNotificationService.GetByUserId(userId);

            if (!notifications.Any())
            {
                _logger.LogInformation($"No notifications found for userID: {userId}");
                return NoContent();
            }
            _logger.LogInformation($"Notifications: {notifications.Count} retrieved for userId: {userId}");
            return Ok(notifications);
        }

        [Authorize(Roles = "1, 2, 3, 4")]
        [HttpDelete("delete")]
        public async Task<IActionResult> Delete(int id, int userId, [FromServices] IDeleteNotificationService deleteService)
        {

            var userIdClaim = User.FindFirst("id")?.Value;
            var userRole = User.FindFirst(ClaimTypes.Role)?.Value;

            if (int.Parse(userIdClaim!) != userId && int.Parse(userRole!) != (int)RoleType.Admin)
            {
                _logger.LogWarning($"Unauthorized attempt to delete  notifications by user: {userId}");
                return Unauthorized();
            }


            if (await deleteService.Delete(id))
            {
                _logger.LogInformation($"Deleted notification {id}");
                return Ok(new { Message = "Notification deleted!" });
            }
            _logger.LogInformation("There is no valid notification to delete!");
            return BadRequest(new { Message = "There is no valid notification to delete!" });
        }

        [Authorize(Roles = "1, 2, 3, 4")]
        [HttpPatch("toggleReadNotification")]
        public async Task<IActionResult> ToggleReadNotification(int id, int userId, [FromServices] IUpsertNotificationService<AddNotification> upsertNotificationService)
        {
            var userIdClaim = User.FindFirst("id")?.Value;
            var userRole = User.FindFirst(ClaimTypes.Role)?.Value;

            if (int.Parse(userIdClaim!) != userId && int.Parse(userRole!) != (int)RoleType.Admin) return Unauthorized();

            if (upsertNotificationService == null)
            {
                return BadRequest();

            }

            await upsertNotificationService.ToggleReadNotification(id);
            return Ok(new { Message = "Notification edited successfully!" });
        }

    }
}
