using Microsoft.AspNetCore.Mvc;
using ZEN_Yoga.Services.Interfaces.Analytics;

namespace ZEN_YogaWebAPI.Controllers
{
    [Route("api/[controller]")]
    public class StudioAnalyticsController : ControllerBase
    {
        private readonly IStudioAnalyticsService _studioAnalyticsService;

        public StudioAnalyticsController(IStudioAnalyticsService studioAnalyticsService)
        {
            _studioAnalyticsService = studioAnalyticsService;
        }
    }
}
