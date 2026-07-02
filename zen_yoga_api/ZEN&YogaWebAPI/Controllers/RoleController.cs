using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using ZEN_Yoga.Models.Enums;
using ZEN_Yoga.Models.Helpers;
using ZEN_Yoga.Models.Requests;
using ZEN_Yoga.Models.Responses;
using ZEN_Yoga.Models.SearchObjects;
using ZEN_Yoga.Services.Interfaces.Notification;
using ZEN_Yoga.Services.Interfaces.Role;
using ZEN_Yoga.Services.Interfaces.User;

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
        public async Task<ActionResult<PagedResponse<RoleResponse>>> GetAll([FromServices] IGetRoleService getRoleService, [FromQuery] PagedRequest request)
        {
            var roles = await getRoleService.GetAll(request);

            if (roles == null)
            {
                _logger.LogInformation("No roles retrieved");
                return NoContent();
            }

            _logger.LogInformation($"Retrieved roles: {roles.Items.Count}");
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

        [Authorize(Roles = AuthRoles.Admin)]
        [HttpGet("getRolesQuery")]
        public async Task<ActionResult<PagedResponse<RoleResponse>>> GetRolesQuery([FromServices] IGetRoleService getRoleService, [FromQuery] RoleQuery roleQuery, [FromQuery] PagedRequest request)
        {
            var roles = await getRoleService.GetRolesQuery(roleQuery, request);

            if (roles == null)
            {
                _logger.LogInformation($"No roles retrieved for query: {roleQuery.Search}");
                return NoContent();
            }

            _logger.LogInformation($"Successfully retrieved role with query: {roleQuery.Search} ");

            return Ok(roles);
        }


        [Authorize(Roles = AuthRoles.Admin)]
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
                return BadRequest(new { Message = "Invalid role data" });

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

            var admins = await getUserService.GetAdminUsers(int.Parse(AuthRoles.Admin));

            foreach (var a in admins) 
            {
                var notification = new AddNotification()
                {
                    Title = "New role",
                    Content = $"New role - {addRole.Name}, was added to your app.",
                    Type = NotificationType.Success.ToString(),
                    UserId = a.Id,
                };

                _logger.LogDebug($"Sending notification to userId: {a.Id}");
                await sendInAppNotificationService.SendToUserAsync(a.Id.ToString(), notification);
                await upsertNotificationService.Add(notification);
            }

            

            return Ok(new { Message = "Role added successfully!" });
        }

        [Authorize(Roles = AuthRoles.Admin)]
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
                return BadRequest(new { Message = "Invalid role data" });

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

            await upsertRoleService.Edit(editRole, id);
            _logger.LogInformation($"Role edited successfully!");

            var admins = await getUserService.GetAdminUsers(int.Parse(AuthRoles.Admin));

            foreach (var a in admins)
            {
                var notification = new AddNotification()
                {
                    Title = "Role edited",
                    Content = $"Role - {editRole.Name}, was edited successfully.",
                    Type = NotificationType.Success.ToString(),
                    UserId = a.Id,
                };

                _logger.LogDebug($"Sending notification to userId: {a.Id}");
                await sendInAppNotificationService.SendToUserAsync(a.Id.ToString(), notification);
                await upsertNotificationService.Add(notification);
            }

            return Ok(new { Message = "Changes saved successfully!" });
        }

        [Authorize(Roles = AuthRoles.Admin)]
        [HttpDelete("delete")]
        public async Task<IActionResult> Delete(int id, [FromServices] IDeleteRoleService deleteService,
                                                [FromServices] IGetUserService getUserService,
                                                [FromServices] IGetRoleService getRoleService,
                                                [FromServices] ISendInAppNotificationService sendInAppNotificationService,
                                                [FromServices] IUpsertNotificationService<AddNotification> upsertNotificationService)
        {

            var role = await getRoleService.GetById(id);

            if (await deleteService.Delete(id))
            {
                _logger.LogInformation($"Role {id} deleted successfully!");

                var admins = await getUserService.GetAdminUsers(int.Parse(AuthRoles.Admin));
                

                foreach (var a in admins)
                {
                    var notification = new AddNotification()
                    {
                        Title = "Role",
                        Content = $"Role - {role.Name}, was deleted from your app.",
                        Type = NotificationType.Success.ToString(),
                        UserId = a.Id,
                    };

                    _logger.LogDebug($"Sending notification to userId: {a.Id}");
                    await sendInAppNotificationService.SendToUserAsync(a.Id.ToString(), notification);

                    await upsertNotificationService.Add(notification);
                }

                return Ok(new { Message = "Role deleted" });
            }
            _logger.LogInformation($"There is no role to delete");
            return BadRequest(new { Message = "There is no role with this ID or it is currently in use!" });
        }
    }
}
