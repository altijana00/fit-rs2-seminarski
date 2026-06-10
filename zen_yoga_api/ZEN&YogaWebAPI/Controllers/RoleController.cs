using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using ZEN_Yoga.Models;
using ZEN_Yoga.Models.Enums;
using ZEN_Yoga.Models.Requests;
using ZEN_Yoga.Models.Responses;
using ZEN_Yoga.Models.SearchObjects;
using ZEN_Yoga.Services.Interfaces.Notification;
using ZEN_Yoga.Services.Interfaces.Role;
using ZEN_Yoga.Services.Interfaces.Studio;
using ZEN_Yoga.Services.Interfaces.User;
using ZEN_Yoga.Services.Services.Notifications;
using ZEN_Yoga.Services.Services.User;
using ZEN_YogaWebAPI.Notifications;

namespace ZEN_YogaWebAPI.Controllers
{
    [Route("api/[controller]")]
    public class RoleController : ControllerBase
    {
        private readonly ILogger<RoleController> _logger;
        public RoleController(ILogger<RoleController> logger)
        {
            _logger = logger;
        }

        [HttpGet("getAll")]
        public async Task<ActionResult<List<RoleResponse>>> GetAll([FromServices] IGetRoleService getRoleService)
        {
            var roles = await getRoleService.GetAll();

            if (roles == null)
            {
                _logger.LogInformation("No roles retrieved");
                return NoContent();
            }

            _logger.LogInformation($"Retrieved roles: {roles.Count}");
            return Ok(roles);
        }

        [HttpGet("getById")]
        public async Task<ActionResult<RoleResponse>> GetById([FromServices] IGetRoleService getRoleService, int id)
        {
            var role = await getRoleService.GetById(id);

            if (role == null)
            {
                _logger.LogInformation("No role retrieved");
                return NoContent();
            }

            _logger.LogInformation($"Role retrieved: {id}");
            return Ok(role);
        }

        [Authorize(Roles = "1")]
        [HttpGet("getRolesQuery")]
        public async Task<ActionResult<List<RoleResponse>>> GetRolesQuery([FromServices] IGetRoleService getRoleService, [FromQuery] RoleQuery roleQuery)
        {
            var roles = await getRoleService.GetRolesQuery(roleQuery);

            if (roles == null)
            {
                _logger.LogInformation($"No roles retrieved for query: {roleQuery.Search}");
                return NoContent();
            }

            _logger.LogInformation($"Successfully retrieved role with query: {roleQuery.Search} ");

            return Ok(roles);
        }


        [Authorize(Roles = "1")]
        [HttpPost("add")]
        public async Task<IActionResult> AddRole([FromBody] AddRole addRole, 
                                                 [FromServices] IUpsertRoleService<AddRole> upsertRoleService,
                                                 [FromServices] IGetUserService getUserService,
                                                 [FromServices] ISendInAppNotificationService sendInAppNotificationService,
                                                 [FromServices] IUpsertNotificationService<AddNotification> upsertNotificationService)
        {
            if (addRole == null)
            {
                _logger.LogInformation($"Attempt to add role with invalid data");
                return BadRequest();

            }

            if (!ModelState.IsValid)
            {
                var errors = ModelState.Values
                                       .SelectMany(v => v.Errors)
                                       .Select(e => e.ErrorMessage)
                                       .ToList();

                _logger.LogInformation("Role data was invalid: {Errors}", string.Join(", ", errors));
                return BadRequest(new { Message = errors });
            }

            await upsertRoleService.Add(addRole);
            _logger.LogInformation($"Role added successfully!");

            var admins = await getUserService.GetAdminUsers((int)RoleType.Admin);

            foreach (var a in admins) 
            {
                // SLANJE INAPP (SIGNAL R)
                var notification = new AddNotification()
                {
                    Title = "New role",
                    Content = $"New role - {addRole.Name}, was added to your app.",
                    Type = NotificationType.Success.ToString(),
                    UserId = a.Id,
                };

                _logger.LogDebug($"Sending notification to userId: {a.Id}");
                await sendInAppNotificationService.SendToUserAsync(a.Id.ToString(), notification);

                // SPREMI U BAZU
                await upsertNotificationService.Add(notification);
            }

            

            return Ok(new { Message = "Role added successfully!" });
        }

        [Authorize(Roles = "1")]
        [HttpPut("edit")]
        public async Task<IActionResult> EditRole([FromBody] EditRole editRole, int id, 
                                                  [FromServices] IUpsertRoleService<AddRole> upsertRoleService,
                                                  [FromServices] IGetUserService getUserService,
                                                  [FromServices] ISendInAppNotificationService sendInAppNotificationService,
                                                  [FromServices] IUpsertNotificationService<AddNotification> upsertNotificationService)

        {
            if (editRole == null)
            {
                _logger.LogInformation($"Attempt to edit role with invalid data");
                return BadRequest();

            }

            await upsertRoleService.Edit(editRole, id);
            _logger.LogInformation($"Role edited successfully!");

            var admins = await getUserService.GetAdminUsers((int)RoleType.Admin);

            foreach (var a in admins)
            {
                // SLANJE INAPP (SIGNAL R)
                var notification = new AddNotification()
                {
                    Title = "Role edited",
                    Content = $"Role - {editRole.Name}, was edited successfully.",
                    Type = NotificationType.Success.ToString(),
                    UserId = a.Id,
                };

                _logger.LogDebug($"Sending notification to userId: {a.Id}");
                await sendInAppNotificationService.SendToUserAsync(a.Id.ToString(), notification);

                // SPREMI U BAZU
                await upsertNotificationService.Add(notification);
            }

            return Ok(new { Message = "Changes saved successfully!" });
        }

        [Authorize(Roles = "1")]
        [HttpDelete("delete")]
        public async Task<IActionResult> Delete(int id, [FromServices] IDeleteRoleService deleteService,
                                                [FromServices] IGetUserService getUserService,
                                                [FromServices] IGetRoleService getRoleService,
                                                [FromServices] ISendInAppNotificationService sendInAppNotificationService,
                                                [FromServices] IUpsertNotificationService<AddNotification> upsertNotificationService)
        {
            if (await deleteService.Delete(id))
            {
                _logger.LogInformation($"Role {id} deleted successfully!");

                var admins = await getUserService.GetAdminUsers((int)RoleType.Admin);
                var role = await getRoleService.GetById(id);

                foreach (var a in admins)
                {
                    // SLANJE INAPP (SIGNAL R)
                    var notification = new AddNotification()
                    {
                        Title = "Role",
                        Content = $"Role - {role.Name}, was deleted from your app.",
                        Type = NotificationType.Success.ToString(),
                        UserId = a.Id,
                    };

                    _logger.LogDebug($"Sending notification to userId: {a.Id}");
                    await sendInAppNotificationService.SendToUserAsync(a.Id.ToString(), notification);

                    // SPREMI U BAZU
                    await upsertNotificationService.Add(notification);
                }

                return Ok(new { Message = "Role deleted" });
            }
            _logger.LogInformation($"There is no role to delete");
            return BadRequest(new { Message = "There is no role with this ID or it is currently in use!" });
        }
    }
}
