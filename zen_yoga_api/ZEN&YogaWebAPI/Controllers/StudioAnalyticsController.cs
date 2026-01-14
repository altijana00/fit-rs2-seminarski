using Microsoft.AspNetCore.Authorization;
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

        [Authorize(Roles = "1, 2")]
        [HttpGet("getByStudio")]
        public async Task<IActionResult> GetByStudio(int studioId)
        {
            var studioPayments = await _studioAnalyticsService.GetByStudio(studioId);

            if (studioPayments != null)
            {
                return Ok(studioPayments);
            }
            return NoContent();
        }

        [Authorize(Roles = "1, 2")]
        [HttpGet("getNumberofParticipants")]
        public async Task<IActionResult> GetNumberofParticipants(int studioId)
        {
            var participants = await _studioAnalyticsService.GetNumberofParticipants(studioId);

            return Ok(participants);
            
        }
    }
}
