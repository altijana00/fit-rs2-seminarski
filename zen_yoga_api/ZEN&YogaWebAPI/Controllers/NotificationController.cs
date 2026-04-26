using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Security.Claims;
using ZEN_Yoga.Models;
using ZEN_Yoga.Models.Enums;
using ZEN_Yoga.Models.Requests;
using ZEN_Yoga.Models.Responses;
using ZEN_Yoga.Models.SearchObjects;
using ZEN_Yoga.Services.Interfaces.City;
using ZEN_Yoga.Services.Interfaces.Class;
using ZEN_Yoga.Services.Interfaces.Notification;

namespace ZEN_YogaWebAPI.Controllers
{
    [Route("api/[controller]")]
    public class NotificationController : ControllerBase
    {

        [Authorize(Roles = "1")]
        [HttpGet("getAll")]
        public async Task<ActionResult<List<NotificationResponse>>> GetAll([FromServices] IGetNotificationService getNotificationService)
        {
            var notifications = await getNotificationService.GetAll();

            if (notifications == null)
            {
                return NoContent();
            }
            return Ok(notifications);
        }

        [Authorize(Roles = "1")]
        [HttpGet("getById")]
        public async Task<ActionResult<NotificationResponse>> GetById([FromServices] IGetNotificationService getNotificationService, int id)
        {
            var notification = await getNotificationService.GetById(id);

            if (notification == null)
            {
                return NoContent();
            }
            return Ok(notification);
        }

        [Authorize(Roles = "1")]
        [HttpGet("getNotificationsQuery")]
        public async Task<ActionResult<List<NotificationResponse>>> GetNotificationsQuery([FromServices] IGetNotificationService getNotificationService, [FromQuery] NotificationQuery notificationQuery)
        {
            var nofications = await getNotificationService.GetNotificationsQuery(notificationQuery);

            if (nofications == null)
            {
                return NoContent();
            }
            return Ok(nofications);
        }

        [Authorize(Roles = "1")]
        [HttpPost("add")]
        public async Task<IActionResult> AddNotification([FromBody] AddNotification addNotification, [FromServices] IUpsertNotificationService<AddNotification> upsertNotificationService)
        {
            if (upsertNotificationService == null)
            {
                return BadRequest();

            }

            await upsertNotificationService.Add(addNotification);
            return Ok(new { Message = "Notification added successfully!" });
        }

        [Authorize(Roles = "1")]
        [HttpPut("edit")]
        public async Task<IActionResult> EditNotification([FromBody] EditNotification editNotification, int id, [FromServices] IUpsertNotificationService<AddNotification> upsertNotificationService)
        {
            if (editNotification == null)
            {
                return BadRequest();

            }

            await upsertNotificationService.Edit(editNotification, id);
            return Ok(new { Message = "Changes saved successfully!" });
        }

        [Authorize(Roles = "1, 2, 3, 4")]
        [HttpGet("getByUserId")]
        public async Task<ActionResult<NotificationResponse>> GetByUserId([FromServices] IGetNotificationService getNotificationService, int userId)
        {
            var userIdClaim = User.FindFirst("id")?.Value;
            var userRole = User.FindFirst(ClaimTypes.Role)?.Value;

            if (int.Parse(userIdClaim!) != userId && int.Parse(userRole!) != (int)RoleType.Admin) return Unauthorized();

            var notifications = await getNotificationService.GetByUserId(userId);

            if (!notifications.Any())
            {
                return NoContent();
            }
            return Ok(notifications);
        }

        [Authorize(Roles = "1, 2, 3, 4")]
        [HttpDelete("delete")]
        public async Task<IActionResult> Delete(int id, int userId, [FromServices] IDeleteNotificationService deleteService)
        {

            var userIdClaim = User.FindFirst("id")?.Value;
            var userRole = User.FindFirst(ClaimTypes.Role)?.Value;

            if (int.Parse(userIdClaim!) != userId && int.Parse(userRole!) != (int)RoleType.Admin) return Unauthorized();


            if (await deleteService.Delete(id))
            {
                return Ok(new { Message = "Notification deleted!" });
            }
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
