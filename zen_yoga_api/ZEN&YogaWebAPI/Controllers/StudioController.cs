using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;
using ZEN_Yoga.Models;
using ZEN_Yoga.Models.Requests;
using ZEN_Yoga.Models.Responses;
using ZEN_Yoga.Models.SearchObjects;
using ZEN_Yoga.Services.Interfaces.Studio;

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

        [Authorize(Roles = "1, 2, 3")]
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

        [Authorize(Roles = "1, 2, 3, 4")]
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

        [Authorize(Roles = "1, 2")]
        [HttpGet("getByOwner")]
        public async Task<ActionResult<List<StudioResponse>>> GetByOwner([FromServices] IGetStudioService getStudioService, int ownerId)
        {
            var studios = await getStudioService.GetByOwner(ownerId);

            if (studios == null)
            {
                _logger.LogInformation($"No studios found for owner (ID): {ownerId}");
                return NoContent();
            }
            _logger.LogInformation($"{studios.Count} studios found for owner (ID): {ownerId}");
            return Ok(studios);
        }

        [Authorize(Roles = "1, 2")]
        [HttpGet("getByOwnerAndStudioName")]
        public async Task<ActionResult<StudioResponse>> GetByOwnerAndStudioName([FromServices] IGetStudioService getStudioService, int ownerId, string name)
        {
            var studio = await getStudioService.GetByOwnerAndStudioName(ownerId, name);

            if (studio == null)
            {
                _logger.LogInformation($"No studios found for owner (ID): {ownerId} and name {name}");

                return NoContent();
            }
            _logger.LogInformation($"{studio.Name} found for owner (ID): {ownerId} and name {name}");
            return Ok(studio);
        }

        [Authorize(Roles = "1, 2")]
        [HttpGet("getById")]
        public async Task<ActionResult<StudioResponse>> GetById([FromServices] IGetStudioService getStudioService, int id)
        {
            var studio = await getStudioService.GetById(id);

            if (studio == null)
            {
                _logger.LogInformation($"No studios found by (ID): {id}");
                return NoContent();
            }

            _logger.LogInformation($"{studio.Name} found by (ID): {id}");
            return Ok(studio);
        }

        [Authorize(Roles = "1, 2")]
        [HttpPost("add")]
        public async Task<IActionResult> AddStudio([FromBody] AddStudio addStudio, [FromServices] IUpsertStudioService<AddStudio> upsertStudioService, [FromServices] IStudioValidatorService studioValidatorService)
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

            _logger.LogInformation($"Studio added successfully!");
            return Ok(new {Message = "Studio added successfully!"});
        }

        [Authorize(Roles = "1, 2")]
        [HttpPut("edit")]
        public async Task<IActionResult> EditStudio([FromBody] EditStudio editStudio, int id, [FromServices] IUpsertStudioService<AddStudio> upsertStudioService, [FromServices] IStudioValidatorService studioValidatorService )
        {
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
            return Ok(new { Message = "Changes saved successfully!" });
        }

        [Authorize(Roles = "1, 2")]
        [HttpDelete("delete")]
        public async Task<IActionResult> Delete(int id, [FromServices] IDeleteStudioService deleteService)
        {
            if (await deleteService.Delete(id))
            {
                _logger.LogInformation($"Studio deleted: {id}");
                return Ok(new { Message = "Studio deleted" });
            }

            _logger.LogInformation($"There is no studio with this ID!");
            return BadRequest(new { Message = "There is no studio with this ID!" });
        }

        [Authorize(Roles = "1, 2")]
        [HttpPost("uploadStudioPhoto")]
        [Consumes("multipart/form-data")]
        public async Task<IActionResult> UploadStudioPhoto([FromServices] IUploadStudioPhotoService uploadStudioPhotoService, IFormFile file)
        {
            if (file == null || file.Length == 0)
                return BadRequest("No file uploaded!");

            var photoUrl = await uploadStudioPhotoService.UploadStudioPhoto(file);
            return Ok(photoUrl);

        }

        [Authorize(Roles = "1, 2")]
        [HttpPost("uploadStudioGalleryPhoto")]
        [Consumes("multipart/form-data")]
        public async Task<IActionResult> UploadStudioGalleryPhoto([FromServices] IUploadStudioGalleryService uploadStudioGalleryService, int studioId, IFormFile file)
        {
            if (file == null || file.Length == 0)
                return BadRequest("No file uploaded!");

            await uploadStudioGalleryService.UploadStudioGalleryPhoto(studioId, file);
            return Ok();

        }

        [ProducesResponseType(200)]
        [ProducesResponseType(204)]
        [Authorize(Roles = "1, 2, 4")]
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

        [Authorize(Roles = "1, 2")]
        [HttpPatch("editStudioPhoto")]
   
        public async Task<IActionResult> EditStudioPhoto([FromServices] IUploadStudioPhotoService uploadStudioPhotoService, string photoUrl, int studioId)
        {
            if (photoUrl.IsNullOrEmpty())
            {
                return BadRequest("No file uploaded!");
            }

            _logger.LogInformation($"Edited studio photo for studio: {studioId}");

            await uploadStudioPhotoService.EditStudioPhoto(photoUrl, studioId);
            return Ok();

        }

        [Authorize(Roles = "1, 2")]
        [HttpDelete("deleteStudioGalleryPhoto")]
        public async Task<IActionResult> DeleteStudioGalleryPhoto(string photoURL, int studioId, [FromServices] IDeleteStudioGalleryPhotoService deleteStudioGalleryPhotoService)
        {
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
