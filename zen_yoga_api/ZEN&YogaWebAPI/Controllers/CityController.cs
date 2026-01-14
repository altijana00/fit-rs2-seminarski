using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using ZEN_Yoga.Models;
using ZEN_Yoga.Models.Responses;
using ZEN_Yoga.Services.Interfaces.City;
using ZEN_Yoga.Services.Services;

namespace ZEN_YogaWebAPI.Controllers
{
    [Route("api/[controller]")]
    public class CityController : ControllerBase
    {
      

        [HttpGet("getAll")]
        public async Task<ActionResult<List<CityResponse>>> GetAll([FromServices] IGetCityService getCityService)
        {
            var cities = await getCityService.GetAll();

            if (cities == null)
            {
                return NoContent();
            }
            return Ok(cities);
        }

        [Authorize(Roles = "1")]
        [HttpGet("getById")]
        public async Task<ActionResult<CityResponse>> GetById([FromServices] IGetCityService getCityService, int id)
        {
            var city = await getCityService.GetById(id);

            if (city == null)
            {
                return NoContent();
            }
            return Ok(city);
        }
    }
}
