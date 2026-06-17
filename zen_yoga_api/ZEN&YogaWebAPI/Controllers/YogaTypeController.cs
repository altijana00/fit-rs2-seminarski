using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using ZEN_Yoga.Models.Enums;
using ZEN_Yoga.Models.Helpers;
using ZEN_Yoga.Models.Requests;
using ZEN_Yoga.Models.Responses;
using ZEN_Yoga.Models.SearchObjects;
using ZEN_Yoga.Services.Interfaces.Notification;
using ZEN_Yoga.Services.Interfaces.User;
using ZEN_Yoga.Services.Interfaces.YogaType;

namespace ZEN_YogaWebAPI.Controllers
{
    [Route("api/[controller]")]
    public class YogaTypeController : ControllerBase
    {
        private readonly ILogger<YogaTypeController> _logger;
        public YogaTypeController(ILogger<YogaTypeController> logger)
        {
            _logger = logger;
        }

        [Authorize(Roles = AuthRoles.AllRoles)]
        [HttpGet("getAll")]
        public async Task<ActionResult<List<YogaTypeResponse>>> GetAll([FromServices] IGetYogaTypeService getYogaTypeService)
        {
            var yogaTypes = await getYogaTypeService.GetAll();

            if (yogaTypes == null)
            {
                _logger.LogInformation("No yoga types found");
                return NoContent();
            }
            _logger.LogInformation($"{yogaTypes.Count} yoga types found");
            return Ok(yogaTypes);
        }


        [Authorize(Roles = AuthRoles.AllRoles)]
        [HttpGet("getById")]
        public async Task<ActionResult<YogaTypeResponse>> GetById(int id, [FromServices] IGetYogaTypeService getYogaTypeService)
        {
            var yogaType = await getYogaTypeService.GetById(id);

            if (yogaType == null)
            {
                _logger.LogInformation($"No yoga types found for id: {id}");
                return NoContent();
            }

            _logger.LogInformation($"{yogaType.Name} yoga type found for id: {id}");
            return Ok(yogaType);
        }

        [Authorize(Roles = AuthRoles.Admin)]
        [HttpGet("getYogaTypesQuery")]
        public async Task<ActionResult<List<YogaTypeResponse>>> GetYogaTypesQuery([FromServices] IGetYogaTypeService getYogaTypeService, [FromQuery] YogaTypeQuery yogaTypeQuery)
        {
            var yogaTypes = await getYogaTypeService.GetYogaTypesQuery(yogaTypeQuery);

            if (yogaTypes == null)
            {
                _logger.LogInformation($"No yogaTypes found with query: {yogaTypeQuery.Search} ");
                return NoContent();
            }
            _logger.LogInformation($"Successfully retrieved yogaTypes with query: {yogaTypeQuery.Search} ");
            return Ok(yogaTypes);
        }

        [Authorize(Roles = AuthRoles.Admin)]
        [HttpPost("add")]
        public async Task<IActionResult> AddYogaType([FromBody] AddYogaType addYogaType, 
                                                     [FromServices] IUpsertYogaTypeService<AddYogaType> upsertYogaTypeService,
                                                     [FromServices] IGetUserService getUserService,
                                                     [FromServices] ISendInAppNotificationService sendInAppNotificationService,
                                                     [FromServices] IUpsertNotificationService<AddNotification> upsertNotificationService
            )
        {
            if (addYogaType == null)
            {
                _logger.LogInformation("Adding yoga type data was null");
                return BadRequest(new { Message = "Invalid yoga type data" });

            }

            if (!ModelState.IsValid)
            {
                var errors = ModelState.Values
                                       .SelectMany(v => v.Errors)
                                       .Select(e => e.ErrorMessage)
                                       .ToList();

                _logger.LogInformation("Yoga data was invalid: {Errors}", string.Join(", ", errors));
                return BadRequest(new { Message = errors });
            }

            await upsertYogaTypeService.Add(addYogaType);
            _logger.LogInformation("Yoga type added successfully!");

            var admins = await getUserService.GetAdminUsers(int.Parse(AuthRoles.Admin));

            foreach(var a  in admins)
            {
                var adminNotification = new AddNotification()
                {
                    Title = "New yoga type",
                    Content = $"New yoga type - {addYogaType.Name}, was added to the app.",
                    Type = NotificationType.Info.ToString(),
                    UserId = a.Id,
                };

                _logger.LogDebug($"Sending notification to userId: {a.Id}");
                await sendInAppNotificationService.SendToUserAsync(a.Id.ToString(), adminNotification);
                await upsertNotificationService.Add(adminNotification);
            }

            

            return Ok(new { Message = "Yoga type added successfully!" });
        }

        [Authorize(Roles = AuthRoles.Admin)]
        [HttpPut("edit")]
        public async Task<IActionResult> EditYogaType([FromBody] EditYogaType editYogaType, 
                                                      int id, 
                                                      [FromServices] IUpsertYogaTypeService<AddYogaType> upsertYogaTypeService,
                                                      [FromServices] IGetUserService getUserService,
                                                      [FromServices] ISendInAppNotificationService sendInAppNotificationService,
                                                      [FromServices] IUpsertNotificationService<AddNotification> upsertNotificationService)
        {
            if (editYogaType == null)
            {
                _logger.LogInformation("Editing yoga type data was null");
                return BadRequest(new { Message = "Invalid yoga type data" });

            }

            if (!ModelState.IsValid)
            {
                var errors = ModelState.Values
                                       .SelectMany(v => v.Errors)
                                       .Select(e => e.ErrorMessage)
                                       .ToList();

                _logger.LogInformation("Yoga type  data was invalid: {Errors}", string.Join(", ", errors));
                return BadRequest(new { Message = errors });
            }

            await upsertYogaTypeService.Edit(editYogaType, id);
            _logger.LogInformation("Yoga type edited successfully!");

            var admins = await getUserService.GetAdminUsers(int.Parse(AuthRoles.Admin));

            foreach (var a in admins)
            {
                var adminNotification = new AddNotification()
                {
                    Title = "Yoga type edited",
                    Content = $"Yoga type - {editYogaType.Name} was edited.",
                    Type = NotificationType.Info.ToString(),
                    UserId = a.Id,
                };

                _logger.LogDebug($"Sending notification to userId: {a.Id}");
                await sendInAppNotificationService.SendToUserAsync(a.Id.ToString(), adminNotification);
                await upsertNotificationService.Add(adminNotification);
            }

            return Ok(new { Message = "Changes saved successfully!" });
        }

        [Authorize(Roles = AuthRoles.Admin)]
        [HttpDelete("delete")]
        public async Task<IActionResult> Delete(int id, [FromServices] IDeleteYogaTypeService deleteService)
        {
            if (await deleteService.Delete(id))
            {
                _logger.LogInformation($"Yoga type with id {id} deleted");
                return Ok(new { Message = "Yoga type deleted" });
            }

            _logger.LogInformation($"No Yoga type with id {id} found for deleteion");
            return BadRequest(new { Message = "There is no yoga type with this ID or it is currently in use!" });
        }
    }
}
