using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;
using System.Net;
using System.Security.Claims;
using ZEN_Yoga.Models;
using ZEN_Yoga.Models.Enums;
using ZEN_Yoga.Models.Requests;
using ZEN_Yoga.Models.Responses;
using ZEN_Yoga.Models.SearchObjects;
using ZEN_Yoga.Services.Interfaces.City;
using ZEN_Yoga.Services.Interfaces.Notification;
using ZEN_Yoga.Services.Interfaces.Role;
using ZEN_Yoga.Services.Interfaces.Studio;
using ZEN_Yoga.Services.Interfaces.User;
using ZEN_Yoga.Services.Services.Notifications;
using ZEN_YogaWebAPI.Notifications;

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

        [Authorize(Roles = "1, 2, 3")]
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

        [Authorize(Roles = "1, 2, 3")]
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


        [Authorize(Roles = "1, 2, 3, 4")]
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

        [Authorize(Roles = "1, 2, 3, 4")]
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

        [Authorize(Roles = "1, 2, 3, 4")]
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

            // SLANJE INAPP (SIGNAL R)
            var notification = new AddNotification()
            {
                Title = "Welcome",
                Content = $"Hello {user.FirstName}, welcome to Zen&Yoga!",
                Type = NotificationType.Info.ToString(),
                UserId = user.Id,
            };

            _logger.LogDebug($"Sending notification to userId: {user.Id}");
            await sendInAppNotificationService.SendToUserAsync(user.Id.ToString(), notification);

            // SPREMI U BAZU
            await upsertNotificationService.Add(notification);

            return Ok(new { Message = "User registered!" });
        }

        [Authorize(Roles = "1, 2, 3, 4")]
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

            // SLANJE INAPP (SIGNAL R)
            var notification = new AddNotification()
            {
                Title = "Profile edited",
                Content = "Your profile was successfully edited.",
                Type = NotificationType.Success.ToString(),
                UserId = id,
            };

            _logger.LogDebug($"Sending notification to userId: {id}");
            await sendInAppNotificationService.SendToUserAsync(id.ToString(), notification);

            // SPREMI U BAZU
            await upsertNotificationService.Add(notification);

            return Ok(new { Message = "Changes saved successfully!" });
        }

        [Authorize(Roles = "1, 2, 3, 4")]
        [HttpPost("uploadUserPhoto")]
        [Consumes("multipart/form-data")]
        public async Task<IActionResult> UploadUserPhoto([FromServices] IUploadUserPhotoService uploadUserPhotoService, IFormFile file)
        {
            if (file == null || file.Length == 0)
                return BadRequest("No file uploaded!");

            var photoUrl = await uploadUserPhotoService.UploadUserPhoto(file);


            return Ok(photoUrl);

        }

        [Authorize(Roles = "1, 2, 3, 4")]
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

            // SLANJE INAPP (SIGNAL R)
            var notification = new AddNotification()
            {
                Title = "Photo edited",
                Content = "Your profile photo was successfully edited.",
                Type = NotificationType.Success.ToString(),
                UserId = userId,
            };

            _logger.LogDebug($"Sending notification to userId: {userId}");
            await sendInAppNotificationService.SendToUserAsync(userId.ToString(), notification);

            // SPREMI U BAZU
            await upsertNotificationService.Add(notification);

            return Ok();
        }


        [Authorize(Roles = "1")]
        [HttpDelete("delete")]
        public async Task<IActionResult> Delete([FromQuery]int id, [FromServices] IDeleteUserService deleteService)
        {
            if (await deleteService.Delete(id))
            {
                _logger.LogInformation($"User: {id} deleted");
                return Ok(new { Message = "User deleted" });
            }

            _logger.LogInformation($"User: {id} no found for deletion");
            return BadRequest(new { Message = "There is no user with this ID!" });
        }

        [Authorize(Roles = "1,2,3,4")]
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

                // SLANJE INAPP (SIGNAL R)
                var notification = new AddNotification()
                {
                    Title = "Password updated",
                    Content = "Your password has been updated successfully.",
                    Type = NotificationType.Success.ToString(),
                    UserId = updateUserPassword.UserId,
                };

                _logger.LogDebug($"Sending notification to userId: {updateUserPassword.UserId}");
                await sendInAppNotificationService.SendToUserAsync(updateUserPassword.UserId.ToString(), notification);

                // SPREMI U BAZU
                await upsertNotificationService.Add(notification);
                return Ok(new { Message = "Password updated"! });
            }

            _logger.LogInformation($"Update user password error");
            if (result == "Error") return StatusCode((int)HttpStatusCode.InternalServerError, "An unexpected error occurred.");

            return BadRequest(new { Message = result });
        }
    }
}
