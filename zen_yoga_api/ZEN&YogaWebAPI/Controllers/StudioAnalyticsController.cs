using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using ZEN_Yoga.Models;
using ZEN_Yoga.Services.Interfaces.Analytics;

namespace ZEN_YogaWebAPI.Controllers
{
    [Route("api/[controller]")]
    public class StudioAnalyticsController : ControllerBase
    {
        private readonly ILogger<StudioAnalyticsController> _logger;
        
        public StudioAnalyticsController( ILogger<StudioAnalyticsController> logger)
        {
            _logger = logger;
        }

        [Authorize(Roles = "1, 2")]
        [HttpGet("getByStudio")]
        public async Task<IActionResult> GetByStudio([FromServices] IStudioAnalyticsService studioAnalyticsService, int studioId)
        {
            var studioPayments = await studioAnalyticsService.GetByStudio(studioId);

            if (studioPayments != 0)
            {
                _logger.LogInformation($"Retrieved studio payments for studio: {studioId}");
                return Ok(studioPayments);
            }

            _logger.LogInformation($"No studio payments found for studio: {studioId}");
            return NoContent();
        }

        [Authorize(Roles = "1, 2")]
        [HttpGet("getNumberofParticipants")]
        public async Task<IActionResult> GetNumberofParticipants([FromServices] IStudioAnalyticsService studioAnalyticsService, int studioId)
        {
            var participants = await studioAnalyticsService.GetNumberofParticipants(studioId);
            _logger.LogInformation($"Retrieved {participants} participants for studio: {studioId} ");

            return Ok(participants);
            
        }

        [Authorize(Roles = "1")]
        [HttpGet("getMostPopularStudioCities")]
        public async Task<IActionResult> GetMostPopularStudioCities([FromServices] IStudioAnalyticsService studioAnalyticsService)
        {
            var mostPopularCities = await studioAnalyticsService.GetMostPopularStudioCities();

            _logger.LogInformation($"Retrieved {mostPopularCities.Count} popular cities");

            return Ok(mostPopularCities);

        }
    }
}
