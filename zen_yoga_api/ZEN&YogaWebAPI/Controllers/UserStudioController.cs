using Microsoft.AspNetCore.Mvc;
using ZEN_Yoga.Services.Interfaces.UserClass;
using ZEN_Yoga.Services.Interfaces.UserStudio;

namespace ZEN_YogaWebAPI.Controllers
{
    [Route("api/[controller]")]
    public class UserStudioController : ControllerBase
    {
        [HttpPost("add")]
        public async Task<IActionResult> Add(int userId, int studioId, int subscriptionTypeId, [FromServices] IUpsertUserStudioService upsertUserStudioService)
        {


            if (await upsertUserStudioService.Add(userId, studioId, subscriptionTypeId))
            {
                return Ok(new { Message = "Joined studio successfully!" });
            }
            return BadRequest(new { Message = "Member already exists!" });


        }
    }
}
