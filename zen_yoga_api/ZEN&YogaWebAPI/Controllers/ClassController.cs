using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;
using ZEN_Yoga.Models.Enums;
using ZEN_Yoga.Models.Helpers;
using ZEN_Yoga.Models.Requests;
using ZEN_Yoga.Models.Responses;
using ZEN_Yoga.Models.SearchObjects;
using ZEN_Yoga.Services.Interfaces.Class;
using ZEN_Yoga.Services.Interfaces.Notification;
using ZEN_Yoga.Services.Interfaces.YogaType;
using ZEN_Yoga.Services.Services.Class;

namespace ZEN_YogaWebAPI.Controllers
{
    [Route("api/[controller]")]
    public class ClassController : ControllerBase
    {

        private readonly ILogger<ClassController> _logger;
        public ClassController(ILogger<ClassController> logger)
        {
            _logger = logger;
        }

        [Authorize(Roles = AuthRoles.Admin)]
        [HttpGet("getAll")]
        public async Task<ActionResult<List<ClassResponse>>> GetAll([FromServices] IGetClassService getClassService)
        {
            var classes = await getClassService.GetAll();

            if (classes == null)
            {
                _logger.LogInformation("No classes retrieved");
                return NoContent();
            }
            _logger.LogInformation($"Success: classes retrieved: {classes.Count}");
            return Ok(classes);
        }

        [Authorize(Roles = AuthRoles.AllRoles)]
        [HttpGet("getById")]
        public async Task<ActionResult<ClassResponse>> GetById([FromServices] IGetClassService getClassService, int id)
        {
            var clasRes = await getClassService.GetById(id);

            if (clasRes == null)
            {
                _logger.LogInformation("No class retrieved");
                return NoContent();
            }

            _logger.LogInformation("Success: class retrieved");
            return Ok(clasRes);
        }

        [Authorize(Roles = AuthRoles.AllRoles)]
        [HttpGet("getJoinedParticipantsByClassId")]
        public async Task<ActionResult<int>> GetJoinedParticipantsByClassId([FromServices] IGetClassService getClassService, int id)
        {
            return await getClassService.GetJoinedParticipantsByClassId(id);
        }

        [Authorize(Roles = AuthRoles.AdminOrOwner)]
        [HttpGet("getInstructorGrouppedByStudioId")]
        public async Task<ActionResult<List<InstructorClasses>>> GetInstructorGrouppedByStudioId([FromServices] IGetClassService getClassService, int id)
        {
            return await getClassService.GetInstructorGrouppedByStudioId(id);
        }

        [Authorize(Roles = AuthRoles.AllRoles)]
        [HttpGet("getByInstructorId")]
        public async Task<ActionResult<ClassResponse>> GetByInstructorId([FromServices] IGetClassService getClassService, int instructorId, [FromQuery] ClassQuery? classQuery)
        {
            var classes = await getClassService.GetByInstructorId(instructorId, classQuery);

            if (classes == null)
            {
                _logger.LogDebug($"No class retrieved for instructor: {instructorId}");
                return NoContent();
            }
            _logger.LogInformation("Success: class retrieved");
            return Ok(classes);
        }

        [Authorize(Roles = AuthRoles.AllRoles)]
        [HttpGet("getByStudioId")]
        public async Task<ActionResult<ClassResponse>> GetByStudioId([FromServices] IGetClassService getClassService, int studioId)
        {
            var classes = await getClassService.GetByStudioId(studioId);

            if (classes == null)
            {
                _logger.LogDebug($"No class retrieved for studio: {studioId}");
                return NoContent();
            }
            _logger.LogInformation("Success: class retrieved");
            return Ok(classes);
        }

        [Authorize(Roles = AuthRoles.AdminOrInstructor)]
        [HttpPost("add")]
        public async Task<IActionResult> Add([FromServices] IUpsertClassService<AddClass> upsertClassService, 
                                             [FromBody] AddClass addClass, 
                                             int instructorId, 
                                             [FromServices] IYogaTypeValidatorService yogaTypeValidatorService,
                                             [FromServices] ISendInAppNotificationService sendInAppNotificationService,
                                             [FromServices] IUpsertNotificationService<AddNotification> upsertNotificationService)
        {

            if (!AuthorizationHelper.CanAccessUserResource(User, instructorId))
            {
                _logger.LogWarning($"Unauthorized attempt to add class by user: {User.FindFirst("id")?.Value}");
                return Unauthorized();
            }

            if (addClass == null)
            {
                _logger.LogDebug($"Attempt to add the class with invalid data for instructorId: {instructorId}");
                return BadRequest(new { Message = "Invalid class data" });
            }

            if (!ModelState.IsValid)
            {
                var errors = ModelState.Values
                                       .SelectMany(v => v.Errors)
                                       .Select(e => e.ErrorMessage)
                                       .ToList();

                _logger.LogInformation("Class data was invalid: {Errors}", string.Join(", ", errors));
                return BadRequest(new { Message = errors });
            }


            await upsertClassService.Add(addClass, instructorId, yogaTypeValidatorService);

            var notification = new AddNotification()
            {
                Title = "Class added",
                Content = $"You have added a class {addClass.Name}",
                Type = NotificationType.Success.ToString(),
                UserId = instructorId
            };

            _logger.LogDebug($"Sending notification to instructorId: {instructorId}");
            await sendInAppNotificationService.SendToUserAsync(instructorId.ToString(), notification);
            await upsertNotificationService.Add(notification);

            _logger.LogInformation("Success: class added");
            return Ok(new { Message = "Class added!" });
        }


        [Authorize(Roles = AuthRoles.AdminOrInstructor)]
        [HttpPut("edit")]
        public async Task<IActionResult> EditClass([FromServices] IUpsertClassService<AddClass> upsertService, 
                                                   [FromBody] EditClass editClass,
                                                   [FromServices] IGetClassService getClassService,
                                                   int id)

        {

            var classToEdit = await getClassService.GetById(id);

            if (!AuthorizationHelper.CanAccessUserResource(User, classToEdit.InstructorId))
            {
                _logger.LogWarning($"Unauthorized attempt to edit class by user: {User.FindFirst("id")?.Value}");
                return Unauthorized();
            }

            if (editClass == null)
            {
                _logger.LogDebug($"Attempt to edit class with invalid data for classID: {id}");
                return BadRequest(new { Message = "Invalid class data" });
            }


            if (!ModelState.IsValid)
            {
                var errors = ModelState.Values
                                       .SelectMany(v => v.Errors)
                                       .Select(e => e.ErrorMessage)
                                       .ToList();

                _logger.LogInformation("Class data was invalid: {Errors}", string.Join(", ", errors));
                return BadRequest(new { Message = errors });
            }


            await upsertService.Edit(editClass, id);
            _logger.LogInformation("Success: class edited");
            return Ok(new { Message = "Changes saved successfully!" });
        }

        [Authorize(Roles = AuthRoles.AdminOrInstructor)]
        [HttpDelete("delete")]
        public async Task<IActionResult> Delete([FromQuery] int id, [FromServices] IDeleteClassService deleteService, [FromServices] IGetClassService getClassService)
        {
            var classToDelete = await getClassService.GetById(id);

            if (!AuthorizationHelper.CanAccessUserResource(User, classToDelete.InstructorId))
            {
                _logger.LogWarning($"Unauthorized attempt to delete class by user: {User.FindFirst("id")?.Value}");
                return Unauthorized();
            }

            if (await deleteService.Delete(id))
            {
                _logger.LogInformation($"Class {id} deleted");
                return Ok(new { Message = "Class deleted" });
            }
            _logger.LogInformation($"Attempt to delete class {id} when there is no class with this ID");
            return BadRequest(new { Message = "There is no class with this ID!" });
        }

        [Authorize(Roles = AuthRoles.AllRoles)]
        [HttpGet("groupped")]
        public async Task<ActionResult<GrouppedClasses>> GetGroupped([FromServices] IGetClassService getClassService)
        {
            var grouppedClasses = await getClassService.GetGroupped();

            if(grouppedClasses == null)
            {
                _logger.LogInformation($"No groupped classes");
                return NoContent();
            }

            _logger.LogInformation($"Sucess: Groupped classes retrived");
            return Ok(grouppedClasses);
        }

        [Authorize(Roles = AuthRoles.AllRoles)]
        [HttpGet("studioGroupped")]
        public async Task<ActionResult<GrouppedClasses>> GetStudioGroupped([FromServices] IGetClassService getClassService, int studioId)
        {
            var userIdClaim = User.FindFirst("id")?.Value;
            var userRole = User.FindFirst(ClaimTypes.Role)?.Value;

            var grouppedClasses = await getClassService.GetStudioGroupped(studioId, int.Parse(userIdClaim!), int.Parse(userRole!));

            if (grouppedClasses == null)
            {
                _logger.LogDebug($"No groupped classes for studio {studioId}");

                return NoContent();
            }

            _logger.LogDebug($"Success: Retreived classes for studio {studioId}");

            return Ok(grouppedClasses);
        }
    }
}
