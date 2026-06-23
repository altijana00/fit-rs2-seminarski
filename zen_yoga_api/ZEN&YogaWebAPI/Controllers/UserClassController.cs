using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using ZEN_Yoga.Models.Enums;
using ZEN_Yoga.Models.Helpers;
using ZEN_Yoga.Models.Requests;
using ZEN_Yoga.Models.Responses;
using ZEN_Yoga.Services.Interfaces.Base;
using ZEN_Yoga.Services.Interfaces.Class;
using ZEN_Yoga.Services.Interfaces.Notification;
using ZEN_Yoga.Services.Interfaces.Payment;
using ZEN_Yoga.Services.Interfaces.Studio;
using ZEN_Yoga.Services.Interfaces.UserClass;

namespace ZEN_YogaWebAPI.Controllers
{
    [Route("api/[controller]")]
    public class UserClassController : ControllerBase
    {
        private readonly ILogger<UserClassController> _logger;
        public UserClassController(ILogger<UserClassController> logger)
        {
            _logger = logger;
        }

        [Authorize(Roles = AuthRoles.Admin)]
        [HttpGet("getAll")]
        public async Task<ActionResult<List<UserClassesResponse>>> GetAll([FromServices] IGetUserClassService getUserClassService)
        {
            var classes = await getUserClassService.GetAll();

            if (classes == null)
            {
                _logger.LogInformation("No user classes found");
                return NoContent();
            }

            _logger.LogInformation($"User classes found: {classes.Count}");
            return Ok(classes);
        }

        [Authorize(Roles = AuthRoles.AllRoles)]
        [HttpGet("getById")]
        public async Task<ActionResult<List<UserClassesResponse>>> GetById([FromServices] IGetUserClassService getUserClassService, int id)
        {
            var userClasses = await getUserClassService.GetById(id);

            if (userClasses == null)
            {
                _logger.LogInformation("No user classes found");
                return NoContent();
            }
            _logger.LogInformation($"User classe found: {userClasses.Name}");
            return Ok(userClasses);
        }

        [Authorize(Roles = AuthRoles.AllRoles)]
        [HttpGet("getByUserId")]
        public async Task<ActionResult<List<ClassResponse>>> GetByUserId([FromServices] IGetUserClassService getUserClassService, int userId)
        {
            var userClasses = await getUserClassService.GetByUserId(userId);

            if (userClasses == null)
            {
                _logger.LogInformation("No user classes found");

                return NoContent();
            }
            _logger.LogInformation($"User classe found: {userClasses.Count}");
            return Ok(userClasses);
        }


        [Authorize(Roles = AuthRoles.AdminOrParticipant)]
        [HttpPost("join")]
        public async Task<IActionResult> Join(int classId, int userId, 
                                                [FromServices] IUpsertUserClassService upsertUserClassService, 
                                                [FromServices] IGetClassService getClassService,
                                                [FromServices] ISendInAppNotificationService sendInAppNotificationService,
                                                [FromServices] IUpsertNotificationService<AddNotification> upsertNotificationService,
                                                [FromServices] IUpsertPaymentService upsertPaymentService
                                                ) 

        {
            if (!AuthorizationHelper.CanAccessUserResource(User, userId))
            {
                _logger.LogWarning($"Unauthorized attempt to join a class for different user by: {userId}");
                return Unauthorized();
            }

            var classRes = await getClassService.GetById(classId);

            if (!await upsertPaymentService.IsUserPaidMember(userId, classRes.StudioId))
            {
                return BadRequest(new { Message = "You have to pay membership for this studio!" });
            }

            if (await upsertUserClassService.Join(classId, userId))
            {
                _logger.LogInformation($"User {userId} joined class {classId}");

                


                var notification = new AddNotification()
                {
                    Title = "Class joined",
                    Content = $"You have joined a class: {classRes.Name}",
                    Type = NotificationType.Success.ToString(),
                    UserId = userId
                };

                _logger.LogDebug($"Sending notification to userId: {userId}");
                await sendInAppNotificationService.SendToUserAsync(userId.ToString(), notification);
                await upsertNotificationService.Add(notification);


                var notificationInstructor = new AddNotification()
                {
                    Title = "New participant joined",
                    Content = $"New participant has joined your class: {classRes.Name}",
                    Type = NotificationType.Info.ToString(),
                    UserId = classRes.InstructorId
                };

                _logger.LogDebug($"Sending notification to userId: {classRes.InstructorId}");
                await sendInAppNotificationService.SendToUserAsync(classRes.InstructorId.ToString(), notificationInstructor);
                await upsertNotificationService.Add(notificationInstructor);


                _logger.LogInformation("Success: class joined");

                return Ok(new { Message = "Joined class successfully" });
            }

            _logger.LogInformation($"User {userId} attempted to join already joined class {classId}");
            return BadRequest(new { Message = "Class already exists!" });
        }

       
        [Authorize(Roles = AuthRoles.AdminOrParticipant)]
        [HttpDelete("deleteUserClass")]
        public async Task<IActionResult> DeleteUserClass(int classId, int userId,
                                                            [FromServices] IDeleteUserClassService deleteService,
                                                            [FromServices] IGetUserClassService getUserClassService,
                                                            [FromServices] ISendInAppNotificationService sendInAppNotificationService,
                                                            [FromServices] IUpsertNotificationService<AddNotification> upsertNotificationService)
        {
            if (await deleteService.DeleteUserClass(classId, userId))
            {
                _logger.LogInformation($"User class deleted: {classId} for user{userId}");


                var notification = new AddNotification()
                {
                    Title = "Class removed",
                    Content = $"You removed  from your classes",
                    Type = NotificationType.Info.ToString(),
                    UserId = userId
                };

                _logger.LogDebug($"Sending notification to userId: {userId}");
                await sendInAppNotificationService.SendToUserAsync(userId.ToString(), notification);

                await upsertNotificationService.Add(notification);


                return Ok(new { Message = "Class deleted!" });
            }
            _logger.LogInformation($"No User class deleted: {classId} for user{userId}");
            return BadRequest();

        }


        [Authorize(Roles = AuthRoles.AdminOrParticipant)]
        [HttpDelete("delete")]
        public async Task<IActionResult> Delete(int id, 
                                                [FromServices] IDeleteService deleteService,
                                                [FromServices] IGetUserClassService getUserClassService,
                                                [FromServices] ISendInAppNotificationService sendInAppNotificationService,
                                                [FromServices] IUpsertNotificationService<AddNotification> upsertNotificationService)
        {
            if (await deleteService.Delete(id))
            {
                _logger.LogInformation($"User class deleted: {id}");

                var userClass = await getUserClassService.GetById(id);

                var notification = new AddNotification()
                {
                    Title = "Class removed",
                    Content = $"You removed {userClass.Name} from your classes",
                    Type = NotificationType.Info.ToString(),
                    UserId = userClass.UserId
                };

                _logger.LogDebug($"Sending notification to userId: {userClass.UserId}");
                await sendInAppNotificationService.SendToUserAsync(userClass.UserId.ToString(), notification);
                await upsertNotificationService.Add(notification);


                var notificationInstructor = new AddNotification()
                {
                    Title = "Class dropped",
                    Content = $"A participant dropped your class: {userClass.Name}",
                    Type = NotificationType.Info.ToString(),
                    UserId = userClass.InstructorId
                };

                _logger.LogDebug($"Sending notification to userId: {userClass.InstructorId}");
                await sendInAppNotificationService.SendToUserAsync(userClass.InstructorId.ToString(), notificationInstructor);
                await upsertNotificationService.Add(notificationInstructor);


                return Ok(new { Message = "Class deleted!" });
            }

            _logger.LogInformation($"User Class {id} not found");
            return BadRequest(new { Message = "Cannot delete class property" });
        }


        [Authorize(Roles = AuthRoles.AllRoles)]
        [HttpGet("getUserRecommendedStudios")]
        [AllowAnonymous]
        public async Task<IActionResult> GetUserRecommendedStudios(int id, [FromServices] IGetUserClassService getUserClassService, [FromServices] IGetStudioService getStudioService)
        {
            if (!AuthorizationHelper.CanAccessUserResource(User, id))
            {
                _logger.LogWarning($"Unauthorized attempt to get recommended studios for another user by: {User.FindFirst("id")?.Value}");
                return Unauthorized();
            }
            var studios = await getUserClassService.GetUserRecommendedStudios(id, getStudioService);

            if (studios.Any())
            {
                _logger.LogInformation($"Found {studios.Count} recommended for userId: {id} ");
                return Ok(studios);
            }
            _logger.LogInformation($"No recommended studios found for userId: {id} ");

            return NoContent();

        }
    }
}
