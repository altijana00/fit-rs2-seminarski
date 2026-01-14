using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using ZEN_Yoga.Models;
using ZEN_Yoga.Models.Responses;
using ZEN_Yoga.Services.Interfaces.Analytics;
using ZEN_Yoga.Services.Interfaces.Studio;

namespace ZEN_YogaWebAPI.Controllers
{
    [Route("api/[controller]")]
    public class AppAnalyticsController : ControllerBase
    {

        [Authorize(Roles = "1")]
        [HttpGet("getAppAnalytics")]
        public async Task<ActionResult<AppAnalytics>> GetAppAnalytics([FromServices] IAppAnalyticsService appAnalyticsService)
        {
            var appAnalytics = await appAnalyticsService.GetAppAnalytics();

            if (appAnalytics == null)
            {
                return NoContent();
            }
            return Ok(appAnalytics);
        }

    }
}
