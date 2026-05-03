using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using ZEN_Yoga.Models.Enums;
using ZEN_Yoga.Models.Requests;
using ZEN_Yoga.Models.Responses;
using ZEN_Yoga.Models.SearchObjects;
using ZEN_Yoga.Services.Interfaces.Class;
using ZEN_Yoga.Services.Interfaces.Notification;
using ZEN_Yoga.Services.Interfaces.YogaType;

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

        [Authorize(Roles = "1")]
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

        [Authorize(Roles = "1, 2, 3, 4")]
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

        [Authorize(Roles = "1, 2, 3, 4")]
        [HttpGet("getJoinedParticipantsByClassId")]
        public async Task<ActionResult<int>> GetJoinedParticipantsByClassId([FromServices] IGetClassService getClassService, int id)
        {
            return await getClassService.GetJoinedParticipantsByClassId(id);
        }

        [Authorize(Roles = "1, 2")]
        [HttpGet("getInstructorGrouppedByStudioId")]
        public async Task<ActionResult<List<InstructorClasses>>> GetInstructorGrouppedByStudioId([FromServices] IGetClassService getClassService, int id)
        {
            return await getClassService.GetInstructorGrouppedByStudioId(id);


        }

        [Authorize(Roles = "1, 2, 3, 4")]
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

        [Authorize(Roles = "1, 2, 3, 4")]
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

        [Authorize(Roles = "1, 3")]
        [HttpPost("add")]
        public async Task<IActionResult> Add([FromServices] IUpsertClassService<AddClass> upsertClassService, 
                                             [FromBody] AddClass addClass, 
                                             int instructorId, 
                                             [FromServices] IYogaTypeValidatorService yogaTypeValidatorService,
                                             [FromServices] ISendInAppNotificationService sendInAppNotificationService,
                                             [FromServices] IUpsertNotificationService<AddNotification> upsertNotificationService
            )
        {
            if (addClass == null)
            {
                _logger.LogDebug($"Attempt to add the class with invalid data for instructorId: {instructorId}");
                return BadRequest();
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

            // SLANJE INAPP (SIGNAL R)
            var notification = new AddNotification()
            {
                Title = "You have added a class",
                Content = "You have added a class",
                Type = NotificationType.Success.ToString(),
                UserId = instructorId
            };

            _logger.LogDebug($"Sending notification to instructorId: {instructorId}");
            await sendInAppNotificationService.SendToUserAsync(instructorId.ToString(), notification);

            // SPREMI U BAZU
            await upsertNotificationService.Add(notification);


            _logger.LogInformation("Success: class added");
            return Ok(new { Message = "Class added!" });
        }


        [Authorize(Roles = "1, 3")]
        [HttpPut("edit")]
        public async Task<IActionResult> EditClass([FromServices] IUpsertClassService<AddClass> upsertService, [FromBody] EditClass editClass, int id)
        {
            if (editClass == null)
            {
                _logger.LogDebug($"Attempt to edit class with invalid data for classID: {id}");
                return BadRequest();
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

        [Authorize(Roles = "1, 3")]
        [HttpDelete("delete")]
        public async Task<IActionResult> Delete([FromQuery] int id, [FromServices] IDeleteClassService deleteService)
        {
            if (await deleteService.Delete(id))
            {
                _logger.LogInformation($"Class {id} deleted");
                return Ok(new { Message = "Class deleted" });
            }
            _logger.LogInformation($"Attempt to delete class {id} when there is no class with this ID");
            return BadRequest(new { Message = "There is no class with this ID!" });
        }

        [Authorize(Roles = "1, 2, 3, 4")]
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

        [Authorize(Roles = "1, 2, 3, 4")]
        [HttpGet("studioGroupped")]
        public async Task<ActionResult<GrouppedClasses>> GetStudioGroupped([FromServices] IGetClassService getClassService, int studioId)
        {
            var grouppedClasses = await getClassService.GetStudioGroupped(studioId);

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
