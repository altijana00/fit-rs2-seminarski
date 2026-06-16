using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;
using ZEN_Yoga.Models.Enums;
using ZEN_Yoga.Models.Helpers;
using ZEN_Yoga.Models.Requests;
using ZEN_Yoga.Models.Responses;
using ZEN_Yoga.Models.SearchObjects;
using ZEN_Yoga.Services.Interfaces.Notification;
using ZEN_Yoga.Services.Interfaces.Studio;
using ZEN_Yoga.Services.Services.Studio;

namespace ZEN_YogaWebAPI.Controllers
{
    [Route("api/[controller]")]
    public class StudioController : ControllerBase
    {

        private readonly ILogger<StudioController> _logger;
        public StudioController(ILogger<StudioController> logger)
        {
            _logger = logger;
        }

        [Authorize(Roles = AuthRoles.AdminOrOwnerOrInstructor)]
        [HttpGet("getAll")]
        public async Task<ActionResult<List<StudioResponse>>> GetAll([FromServices] IGetStudioService getStudioService)
        {
            var studios = await getStudioService.GetAll();

            if (studios == null)
            {
                _logger.LogInformation($"No studios found");

                return NoContent();
            }
            _logger.LogInformation($"Retrieved studios: {studios.Count}");

            return Ok(studios);
        }

        [Authorize(Roles = AuthRoles.AllRoles)]
        [HttpGet("getStudiosQuery")]
        public async Task<ActionResult<List<StudioResponse>>> GetStudiosQuery([FromServices] IGetStudioService getStudioService, [FromQuery] StudioQuery studioQuery)
        {
            var studios = await getStudioService.GetStudiosQuery(studioQuery);

            if (studios == null)
            {
                _logger.LogInformation($"No studios found for query: {studioQuery.Search}");
                return NoContent();
            }

            _logger.LogInformation($" {studios.Count} studios found for query: {studioQuery.Search}");
            return Ok(studios);
        }

        [Authorize(Roles = AuthRoles.AdminOrOwner)]
        [HttpGet("getByOwner")]
        public async Task<ActionResult<List<StudioResponse>>> GetByOwner([FromServices] IGetStudioService getStudioService, int ownerId)
        {
            if (!AuthorizationHelper.CanAccessUserResource(User, ownerId))
            {
                _logger.LogWarning($"Unauthorized attempt to get studio by owner id by : {User.FindFirst("id")?.Value}");

                return Unauthorized();
            }

            var studios = await getStudioService.GetByOwner(ownerId);

            if (studios == null)
            {
                _logger.LogInformation($"No studios found for owner (ID): {ownerId}");
                return NoContent();
            }
            _logger.LogInformation($"{studios.Count} studios found for owner (ID): {ownerId}");
            return Ok(studios);
        }

        [Authorize(Roles = AuthRoles.AdminOrOwner)]
        [HttpGet("getByOwnerAndStudioName")]
        public async Task<ActionResult<StudioResponse>> GetByOwnerAndStudioName([FromServices] IGetStudioService getStudioService, int ownerId, string name)
        {
            if (!AuthorizationHelper.CanAccessUserResource(User, ownerId))
            {
                _logger.LogWarning($"Unauthorized attempt to get studio by owner id and name by : {User.FindFirst("id")?.Value}");

                return Unauthorized();
            }

            var studio = await getStudioService.GetByOwnerAndStudioName(ownerId, name);

            if (studio == null)
            {
                _logger.LogInformation($"No studios found for owner (ID): {ownerId} and name {name}");

                return NoContent();
            }
            _logger.LogInformation($"{studio.Name} found for owner (ID): {ownerId} and name {name}");
            return Ok(studio);
        }

        [Authorize(Roles = AuthRoles.AdminOrOwner)]
        [HttpGet("getById")]
        public async Task<ActionResult<StudioResponse>> GetById([FromServices] IGetStudioService getStudioService, int id)
        {
            var studio = await getStudioService.GetById(id);

            if (!AuthorizationHelper.CanAccessUserResource(User, studio.OwnerId))
            {
                _logger.LogWarning($"Unauthorized attempt to get studio by owner id by : {User.FindFirst("id")?.Value}");

                return Unauthorized();
            }

            if (studio == null)
            {
                _logger.LogInformation($"No studios found by (ID): {id}");
                return NoContent();
            }

            _logger.LogInformation($"{studio.Name} found by (ID): {id}");
            return Ok(studio);
        }

        [Authorize(Roles = AuthRoles.Owner)]
        [HttpPost("add")]
        public async Task<IActionResult> AddStudio([FromBody] AddStudio addStudio, 
                                                   [FromServices] IUpsertStudioService<AddStudio> upsertStudioService, 
                                                   [FromServices] IStudioValidatorService studioValidatorService,
                                                   [FromServices] ISendInAppNotificationService sendInAppNotificationService,
                                                   [FromServices] IUpsertNotificationService<AddNotification> upsertNotificationService)
        {
            if (addStudio == null) 
            {
                _logger.LogInformation($"Attempted to add studio with bad data (model was null)");
                return BadRequest();
            
            }

            if (!ModelState.IsValid)
            {
                var errors = ModelState.Values
                                       .SelectMany(v => v.Errors)
                                       .Select(e => e.ErrorMessage)
                                       .ToList();


                _logger.LogInformation("Studio data was invalid: {Errors}", string.Join(", ", errors));
                return BadRequest(new { Message = errors });
            }

            await studioValidatorService.ValidateName(addStudio.Name);
            await upsertStudioService.Add(addStudio);
            var notification = new AddNotification()
            {
                Title = "Studio added",
                Content = $"{addStudio.Name} was successfully added!",
                Type = NotificationType.Success.ToString(),
                UserId = addStudio.OwnerId,
            };

            _logger.LogDebug($"Sending notification to userId: {addStudio.OwnerId}");
            await sendInAppNotificationService.SendToUserAsync(addStudio.OwnerId.ToString(), notification);
            await upsertNotificationService.Add(notification);

            _logger.LogInformation($"Studio added successfully!");
            return Ok(new {Message = "Studio added successfully!"});
        }

        [Authorize(Roles = AuthRoles.AdminOrOwner)]
        [HttpPut("edit")]
        public async Task<IActionResult> EditStudio([FromBody] EditStudio editStudio, 
                                                    int id, [FromServices] IUpsertStudioService<AddStudio> upsertStudioService, 
                                                    [FromServices] IStudioValidatorService studioValidatorService,
                                                    [FromServices] IGetStudioService getStudioService,
                                                    [FromServices] ISendInAppNotificationService sendInAppNotificationService,
                                                    [FromServices] IUpsertNotificationService<AddNotification> upsertNotificationService)
        {
            var studio = await getStudioService.GetById(id);

            if (!AuthorizationHelper.CanAccessUserResource(User, studio.OwnerId))
            {
                _logger.LogWarning($"Unauthorized attempt to get studio by owner id by : {User.FindFirst("id")?.Value}");

                return Unauthorized();
            }

            if (editStudio == null)
            {
                _logger.LogInformation($"Attempted to edit studio with bad data (model was null)");
                return BadRequest();

            }

            if (!ModelState.IsValid)
            {
                var errors = ModelState.Values
                                       .SelectMany(v => v.Errors)
                                       .Select(e => e.ErrorMessage)
                                       .ToList();

                _logger.LogInformation("Studio data was invalid: {Errors}", string.Join(", ", errors));
                return BadRequest(new { Message = errors });
            }

            await studioValidatorService.ValidateStudio(id);

            await upsertStudioService.Edit(editStudio, id);
            _logger.LogInformation($"Studio edited successfully!");

            var notification = new AddNotification()
            {
                Title = "Studio edited",
                Content = $"Your studio - {studio.Name}, has been edited successfully!",
                Type = NotificationType.Success.ToString(),
                UserId = studio.OwnerId,
            };

            _logger.LogDebug($"Sending notification to userId: {studio.OwnerId}");
            await sendInAppNotificationService.SendToUserAsync(studio.OwnerId.ToString(), notification);
            await upsertNotificationService.Add(notification);

            return Ok(new { Message = "Changes saved successfully!" });
        }

        [Authorize(Roles = AuthRoles.AdminOrOwner)]
        [HttpDelete("delete")]
        public async Task<IActionResult> Delete(int id, 
                                                [FromServices] IDeleteStudioService deleteService,
                                                [FromServices] IGetStudioService getStudioService,
                                                [FromServices] ISendInAppNotificationService sendInAppNotificationService,
                                                [FromServices] IUpsertNotificationService<AddNotification> upsertNotificationService)
        {
            var studio = await getStudioService.GetById(id);

            if (!AuthorizationHelper.CanAccessUserResource(User, studio.OwnerId))
            {
                _logger.LogWarning($"Unauthorized attempt to delete other studio by : {User.FindFirst("id")?.Value}");

                return Unauthorized();
            }

            if (await deleteService.Delete(id))
            {
                var notification = new AddNotification()
                {
                    Title = "Studio deleted",
                    Content = $"Your studio - {studio.Name}, has been deleted.",
                    Type = NotificationType.Success.ToString(),
                    UserId = studio.OwnerId,
                };

                _logger.LogDebug($"Sending notification to userId: {studio.OwnerId}");
                await sendInAppNotificationService.SendToUserAsync(studio.OwnerId.ToString(), notification);
                await upsertNotificationService.Add(notification);

                _logger.LogInformation($"Studio deleted: {id}");
                return Ok(new { Message = "Studio deleted" });
            }

            _logger.LogInformation($"There is no studio with this ID!");
            return BadRequest(new { Message = "There is no studio with this ID!" });
        }

        [Authorize(Roles = AuthRoles.AdminOrOwner)]
        [HttpPost("uploadStudioPhoto")]
        [Consumes("multipart/form-data")]
        public async Task<IActionResult> UploadStudioPhoto([FromServices] IUploadStudioPhotoService uploadStudioPhotoService, IFormFile file)
        {
            if (file == null || file.Length == 0)
                return BadRequest("No file uploaded!");

            if (!FileValidationHelper.IsValidImage(file))
                return BadRequest("Invalid file type.");

            var photoUrl = await uploadStudioPhotoService.UploadStudioPhoto(file);
            return Ok(photoUrl);

        }

        [Authorize(Roles = AuthRoles.AdminOrOwner)]
        [HttpPost("uploadStudioGalleryPhoto")]
        [Consumes("multipart/form-data")]
        public async Task<IActionResult> UploadStudioGalleryPhoto([FromServices] IUploadStudioGalleryService uploadStudioGalleryService, [FromServices] IGetStudioService getStudioService, int studioId, IFormFile file)
        {

            var studio = await getStudioService.GetById(studioId);

            if (!AuthorizationHelper.CanAccessUserResource(User, studio.OwnerId))
            {
                _logger.LogWarning($"Unauthorized attempt to upload studio gallery photo for other studio by : {User.FindFirst("id")?.Value}");

                return Unauthorized();
            }

            if (file == null || file.Length == 0)
                return BadRequest("No file uploaded!");

            if (!FileValidationHelper.IsValidImage(file))
                return BadRequest("Invalid file type.");

            await uploadStudioGalleryService.UploadStudioGalleryPhoto(studioId, file);
            return Ok();

        }

        [ProducesResponseType(200)]
        [ProducesResponseType(204)]
        [Authorize(Roles = AuthRoles.AdminOrOwnerOrParticipant)]
        [HttpGet("getStudioGalleryPhotos")]
        public async Task<ActionResult<string>> GetStudioGalleryPhotos([FromServices] IGetStudioGalleryService getStudioGalleryService, int studioId)
        {
            var galleryUrls = await getStudioGalleryService.GetStudioGalleryPhotos(studioId);

            if (galleryUrls != null)
            {
                _logger.LogInformation($"Found {galleryUrls.Count} gallery urls found for studio: {studioId}");
                return Ok(galleryUrls);
            }
            _logger.LogInformation($"No gallery urls found for studio: {studioId}");
            return NoContent();
        }

        [Authorize(Roles = AuthRoles.AdminOrOwner)]
        [HttpPatch("editStudioPhoto")]
   
        public async Task<IActionResult> EditStudioPhoto([FromServices] IUploadStudioPhotoService uploadStudioPhotoService, [FromServices] IGetStudioService getStudioService,string photoUrl, int studioId)
        {
            var studio = await getStudioService.GetById(studioId);

            if (!AuthorizationHelper.CanAccessUserResource(User, studio.OwnerId))
            {
                _logger.LogWarning($"Unauthorized attempt to edit studio photo for other studio by : {User.FindFirst("id")?.Value}");

                return Unauthorized();
            }

            if (photoUrl.IsNullOrEmpty())
            {
                return BadRequest("No file uploaded!");
            }

            _logger.LogInformation($"Edited studio photo for studio: {studioId}");

            await uploadStudioPhotoService.EditStudioPhoto(photoUrl, studioId);
            return Ok();

        }

        [Authorize(Roles = AuthRoles.AdminOrOwner)]
        [HttpDelete("deleteStudioGalleryPhoto")]
        public async Task<IActionResult> DeleteStudioGalleryPhoto(string photoURL, int studioId, [FromServices] IDeleteStudioGalleryPhotoService deleteStudioGalleryPhotoService, [FromServices] IGetStudioService getStudioService)
        {
            var studio = await getStudioService.GetById(studioId);

            if (!AuthorizationHelper.CanAccessUserResource(User, studio.OwnerId))
            {
                _logger.LogWarning($"Unauthorized attempt to delete studio photo for other studio by : {User.FindFirst("id")?.Value}");

                return Unauthorized();
            }
            if (await deleteStudioGalleryPhotoService.DeleteStudioGalleryPhoto(photoURL, studioId))
            {
                _logger.LogInformation($"Studio gallery photo deleted for studio: {studioId}");

                return Ok(new { Message = "Gallery photo deleted"! });
            }

            _logger.LogInformation($"No gallery photo found (URL): {photoURL} for studio: {studioId}");
            return BadRequest(new { Message = "There is no photo with this ID!" });
        }

    }
}
