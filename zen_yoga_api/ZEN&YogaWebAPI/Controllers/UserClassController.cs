using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using ZEN_Yoga.Models.Responses;
using ZEN_Yoga.Services.Interfaces.Base;
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

        [Authorize(Roles = "1")]
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

        [Authorize(Roles = "1, 2, 3, 4")]
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

        [Authorize(Roles = "1, 2, 3, 4")]
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


        [Authorize(Roles = "1, 4")]
        [HttpPost("join")]
        public async Task<IActionResult> Join(int classId, int userId, [FromServices] IUpsertUserClassService upsertUserClassService )
        {


            if(await upsertUserClassService.Join(classId, userId))
            {
                _logger.LogInformation($"User {userId} joined class {classId}");

                return Ok(new { Message = "Joined class successfully" });
            }

            _logger.LogInformation($"User {userId} attempted to join already joined class {classId}");
            return BadRequest(new { Message = "Class already exists!" });
        }


        [Authorize(Roles = "1, 4")]
        [HttpDelete("delete")]
        public async Task<IActionResult> Delete(int id, [FromServices] IDeleteService deleteService)
        {
            if (await deleteService.Delete(id))
            {
                _logger.LogInformation($"User class deleted: {id}");

                return Ok(new { Message = "Class deleted!" });
            }

            _logger.LogInformation($"User Class {id} not found");
            return BadRequest();
        }

        [Authorize(Roles = "1, 2, 3, 4")]
        [HttpDelete("deleteUserClass")]
        public async Task<IActionResult> DeleteUserClass(int classId, int userId, [FromServices] IDeleteUserClassService deleteService)
        {
            if (await deleteService.DeleteUserClass(classId, userId))
            {
                _logger.LogInformation($"User class deleted: {classId} for user{userId}");

                return Ok(new { Message = "Class deleted!" });
            }
            _logger.LogInformation($"No User class deleted: {classId} for user{userId}");
            return BadRequest();

        }

        [Authorize(Roles = "1, 2, 3, 4")]
        [HttpGet("getUserRecommendedStudios")]
        [AllowAnonymous]
        public async Task<IActionResult> GetUserRecommendedStudios(int id, [FromServices] IGetUserClassService getUserClassService, [FromServices] IGetStudioService getStudioService)
        {
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
