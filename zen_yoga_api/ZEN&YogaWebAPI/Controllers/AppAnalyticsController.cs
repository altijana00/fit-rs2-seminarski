using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using ZEN_Yoga.Models;
using ZEN_Yoga.Services.Interfaces.Analytics;

namespace ZEN_YogaWebAPI.Controllers
{
    [Route("api/[controller]")]
    public class AppAnalyticsController : ControllerBase
    {
        private readonly ILogger<AppAnalyticsController> _logger;

        public AppAnalyticsController(ILogger<AppAnalyticsController> logger)
        {
            _logger = logger;
        }

        [Authorize(Roles = "1")]
        [HttpGet("getAppAnalytics")]
        public async Task<ActionResult<AppAnalytics>> GetAppAnalytics([FromServices] IAppAnalyticsService appAnalyticsService)
        {
            var appAnalytics = await appAnalyticsService.GetAppAnalytics();

            if (appAnalytics == null)
            {
                
                _logger.LogInformation("No app analytics found");
                return NoContent();
            }
            _logger.LogInformation("Successfully retrieved app analytics");
            return Ok(appAnalytics);
        }

    }
}
