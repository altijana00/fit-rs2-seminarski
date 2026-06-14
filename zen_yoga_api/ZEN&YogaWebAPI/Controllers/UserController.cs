using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;
using System.Net;
using System.Security.Claims;
using ZEN_Yoga.Models.Enums;
using ZEN_Yoga.Models.Exceptions;
using ZEN_Yoga.Models.Helpers;
using ZEN_Yoga.Models.Requests;
using ZEN_Yoga.Models.Responses;
using ZEN_Yoga.Models.SearchObjects;
using ZEN_Yoga.Services.Interfaces.City;
using ZEN_Yoga.Services.Interfaces.Notification;
using ZEN_Yoga.Services.Interfaces.Role;
using ZEN_Yoga.Services.Interfaces.Studio;
using ZEN_Yoga.Services.Interfaces.User;

namespace ZEN_YogaWebAPI.Controllers
{
    [Route("api/[controller]")]
    public class UserController : ControllerBase
    {
        private readonly ILogger<UserController> _logger;
        public UserController(ILogger<UserController> logger)
        {
            _logger = logger;
        }

        [Authorize(Roles = AuthRoles.AdminOrOwnerOrInstructor)]
        [HttpGet("getAll")]        
        public async Task<ActionResult<List<UserResponse>>> GetAll([FromServices] IGetUserService getUserService)
        {
            var users = await getUserService.GetAll();

            if (users == null)
            {
                _logger.LogInformation("No users found");
                return NoContent();
            }

            _logger.LogInformation($"{users.Count} users found");
            return Ok(users);
        }

        [Authorize(Roles = AuthRoles.AdminOrOwnerOrInstructor)]
        [HttpGet("getUsersQuery")]
        public async Task<ActionResult<List<UserResponse>>> GetUsersQuery([FromServices] IGetUserService getUserService, [FromQuery] UserQuery userQuery)
        {
            var users = await getUserService.GetUsersQuery(userQuery);

            if (users == null)
            {
                _logger.LogInformation($"No users found with query: {userQuery.Search} ");

                return NoContent();
            }

            _logger.LogInformation($"{users.Count} users found with query: {userQuery.Search} ");
            return Ok(users);
        }

        [Authorize(Roles = AuthRoles.Admin)]
        [HttpGet("getAdminUsers")]
        public async Task<ActionResult<List<UserResponse>>> GetAdminUsers([FromServices] IGetUserService getUserService)
        {
            var users = await getUserService.GetAdminUsers(int.Parse(AuthRoles.Admin));

            if (users == null)
            {
                _logger.LogInformation($"No admins found with.");

                return NoContent();
            }

            _logger.LogInformation($"{users.Count} admins found.");
            return Ok(users);
        }


        [Authorize(Roles = AuthRoles.AllRoles)]
        [HttpGet("getById")]
        public async Task<ActionResult<List<UserResponse>>> GetById([FromServices] IGetUserService getUserService, int id)
        {
            var user = await getUserService.GetById(id);

            if (user == null) 
            {
                _logger.LogInformation($"No user found with ID: {id} ");
                return NoContent();
            }
            _logger.LogInformation($"{user.LastName} {user.LastName} found with ID: {id} ");
            return Ok(user);
        }

        [Authorize(Roles = AuthRoles.AllRoles)]
        [HttpGet("getByEmail")]
        public async Task<ActionResult<List<UserResponse>>> GetByEmail([FromServices] IGetUserService getUserService, string email)
        {
            var user = await getUserService.GetByEmail(email);

            if (user == null)
            {
                _logger.LogInformation($"No user found with email: {email} ");
                return NoContent();
            }
            _logger.LogInformation($"{user.LastName} {user.LastName} found with email: {email} ");

            return Ok(user);
        }

        [Authorize(Roles = AuthRoles.AllRoles)]
        [HttpPost("add")]
        public async Task<IActionResult> Add([FromBody] RegisterUser registerUser, 
                                            [FromServices] IUpsertUserService<RegisterUser> upsertUserService,
                                            [FromServices] IUserValidatorService userValidatorService,
                                            [FromServices] IRoleValidatorService roleValidatorService,
                                            [FromServices] ICityValidatorService cityValidatorService,
                                            [FromServices] IGetUserService getUserService,
                                            [FromServices] ISendInAppNotificationService sendInAppNotificationService,
                                            [FromServices] IUpsertNotificationService<AddNotification> upsertNotificationService)
        {
            if (registerUser == null) {
                _logger.LogInformation("User data was null");

                return BadRequest();
            }
            
            if (!ModelState.IsValid)
            {
                var errors = ModelState.Values
                                       .SelectMany(v => v.Errors)
                                       .Select(e => e.ErrorMessage)
                                       .ToList();

                _logger.LogInformation("User data was invalid: {Errors}", string.Join(", ", errors));
                return BadRequest(new { Message = errors });
            }

            await upsertUserService.Add(userValidatorService, roleValidatorService, cityValidatorService, registerUser);
            _logger.LogInformation($"User registered: {registerUser.Email}");

            var user = await getUserService.GetByEmail(registerUser.Email);
            var admins = await getUserService.GetAdminUsers(int.Parse(AuthRoles.Admin));

            var notification = new AddNotification()
            {
                Title = "Welcome",
                Content = $"Hello {user.FirstName}, welcome to Zen&Yoga!",
                Type = NotificationType.Info.ToString(),
                UserId = user.Id,
            };

            _logger.LogDebug($"Sending notification to userId: {user.Id}");
            await sendInAppNotificationService.SendToUserAsync(user.Id.ToString(), notification);

            await upsertNotificationService.Add(notification);

            foreach(var a in admins)
            {
                var adminNotification = new AddNotification()
                {
                    Title = "New user",
                    Content = $"New user has joined the app!",
                    Type = NotificationType.Info.ToString(),
                    UserId = a.Id,
                };

                _logger.LogDebug($"Sending notification to userId: {a.Id}");
                await sendInAppNotificationService.SendToUserAsync(a.Id.ToString(), adminNotification);
                await upsertNotificationService.Add(adminNotification);
            }
            


            return Ok(new { Message = "User registered!" });
        }

        [Authorize(Roles = AuthRoles.AllRoles)]
        [HttpPut("edit")]
        public async Task<IActionResult> Edit([FromBody] EditUser editUser, int id, 
                                              [FromServices] IUpsertUserService<RegisterUser> upsertUserService, 
                                              [FromServices] IUserValidatorService userValidatorService,
                                              [FromServices] ISendInAppNotificationService sendInAppNotificationService,
                                              [FromServices] IUpsertNotificationService<AddNotification> upsertNotificationService)
        {
            if (editUser == null)
            {
                _logger.LogInformation("User data was null");
                return BadRequest();
            }

            if (!ModelState.IsValid)
            {
                var errors = ModelState.Values
                                       .SelectMany(v => v.Errors)
                                       .Select(e => e.ErrorMessage)
                                       .ToList();

                _logger.LogInformation("User data was invalid: {Errors}", string.Join(", ", errors));
                return BadRequest(new { Message = errors });
            }

            await userValidatorService.ValidateUserId(id);
            await upsertUserService.Edit(editUser, id);

            var notification = new AddNotification()
            {
                Title = "Profile edited",
                Content = "Your profile was successfully edited.",
                Type = NotificationType.Success.ToString(),
                UserId = id,
            };

            _logger.LogDebug($"Sending notification to userId: {id}");
            await sendInAppNotificationService.SendToUserAsync(id.ToString(), notification);
            await upsertNotificationService.Add(notification);

            return Ok(new { Message = "Changes saved successfully!" });
        }

        [Authorize(Roles = AuthRoles.AllRoles)]
        [HttpPost("uploadUserPhoto")]
        [Consumes("multipart/form-data")]
        public async Task<IActionResult> UploadUserPhoto([FromServices] IUploadUserPhotoService uploadUserPhotoService, IFormFile file)
        {
            if (file == null || file.Length == 0)
                return BadRequest("No file uploaded!");

            var photoUrl = await uploadUserPhotoService.UploadUserPhoto(file);


            return Ok(photoUrl);

        }

        [Authorize(Roles = AuthRoles.AllRoles)]
        [HttpPatch("editUserPhoto")]

        public async Task<IActionResult> EditUserPhoto([FromServices] IUploadUserPhotoService uploadUserPhotoService, 
                                                        string photoUrl, int userId,
                                                        [FromServices] ISendInAppNotificationService sendInAppNotificationService,
                                                        [FromServices] IUpsertNotificationService<AddNotification> upsertNotificationService)
        {
            if (photoUrl.IsNullOrEmpty())
            {
                _logger.LogInformation($"No photo updated for userId: {userId}");
                return BadRequest("No file uploaded!");
            }

            await uploadUserPhotoService.EditUserPhoto(photoUrl, userId);
            _logger.LogInformation($"Success: Photo updated for userId: {userId}");

            var notification = new AddNotification()
            {
                Title = "Photo edited",
                Content = "Your profile photo was successfully edited.",
                Type = NotificationType.Success.ToString(),
                UserId = userId,
            };

            _logger.LogDebug($"Sending notification to userId: {userId}");
            await sendInAppNotificationService.SendToUserAsync(userId.ToString(), notification);
            await upsertNotificationService.Add(notification);

            return Ok();
        }


        [Authorize(Roles = AuthRoles.Admin)]
        [HttpDelete("delete")]
        public async Task<IActionResult> Delete([FromQuery]int id, 
                                                [FromServices] IDeleteUserService deleteService,
                                                [FromServices] IGetUserService getUserService,
                                                [FromServices] ISendInAppNotificationService sendInAppNotificationService,
                                                [FromServices] IUpsertNotificationService<AddNotification> upsertNotificationService)
        {

            var user = await getUserService.GetById(id);
            var admins = await getUserService.GetAdminUsers(int.Parse(AuthRoles.Admin));

            if (await deleteService.Delete(id))
            {
                _logger.LogInformation($"User: {id} deleted");

                foreach (var a in admins)
                {
                    var notification = new AddNotification()
                    {
                        Title = "User deleted",
                        Content = $"User {user.FirstName} {user.LastName} has been deleted from the app.",
                        Type = NotificationType.Info.ToString(),
                        UserId = a.Id,
                    };

                    _logger.LogDebug($"Sending notification to userId: {a.Id}");
                    await sendInAppNotificationService.SendToUserAsync(a.Id.ToString(), notification);
                    await upsertNotificationService.Add(notification);

                }

                return Ok(new { Message = "User deleted" });
            }

            _logger.LogInformation($"User: {id} no found for deletion");

            foreach (var a in admins) 
            {
                var notificationError = new AddNotification()
                {
                    Title = "User delete failed",
                    Content = $"Failed to delete user {user.FirstName} {user.LastName}.",
                    Type = NotificationType.Error.ToString(),
                    UserId = a.Id,
                };

                _logger.LogDebug($"Sending notification to userId: {a.Id}");
                await sendInAppNotificationService.SendToUserAsync(a.Id.ToString(), notificationError);
                await upsertNotificationService.Add(notificationError);
            }
            
            return BadRequest(new { Message = "There is no user with this ID!" });
        }

        [Authorize(Roles = AuthRoles.AllRoles)]
        [HttpPatch("updateUserPassword")]
        public async Task<IActionResult> UpdateUserPassword(UpdateUserPassword updateUserPassword, 
                                                            [FromServices] IUpsertUserService<RegisterUser> upsertUserService,
                                                            [FromServices] ISendInAppNotificationService sendInAppNotificationService,
                                                            [FromServices] IUpsertNotificationService<AddNotification> upsertNotificationService)
        {
            var userRole = User.FindFirst(ClaimTypes.Role)?.Value;

            var result = await upsertUserService.UpdateUserPassword(updateUserPassword, userRole);

            if (result == "Ok")
            {
                _logger.LogInformation($"Password updated for user: {updateUserPassword.UserId}");

                var notification = new AddNotification()
                {
                    Title = "Password updated",
                    Content = "Your password has been updated successfully.",
                    Type = NotificationType.Success.ToString(),
                    UserId = updateUserPassword.UserId,
                };

                _logger.LogDebug($"Sending notification to userId: {updateUserPassword.UserId}");
                await sendInAppNotificationService.SendToUserAsync(updateUserPassword.UserId.ToString(), notification);
                await upsertNotificationService.Add(notification);
                return Ok(new { Message = "Password updated"! });
            }

            _logger.LogInformation($"Update user password error");
            if (result == "Error") return StatusCode((int)HttpStatusCode.InternalServerError, "An unexpected error occurred.");

            return BadRequest(new { Message = result });
        }
    }
}
