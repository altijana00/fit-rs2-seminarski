using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using ZEN_Yoga.Models;
using ZEN_Yoga.Models.Requests;
using ZEN_Yoga.Models.Responses;
using ZEN_Yoga.Models.SearchObjects;
using ZEN_Yoga.Services.Interfaces.City;
using ZEN_Yoga.Services.Interfaces.Role;
using ZEN_Yoga.Services.Interfaces.User;
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

        [Authorize(Roles = "1")]
        [HttpGet("getCitiesQuery")]
        public async Task<ActionResult<List<CityResponse>>> GetCitiesQuery([FromServices] IGetCityService getCityService, [FromQuery] CityQuery cityQuery)
        {
            var cities = await getCityService.GetCitiesQuery(cityQuery);

            if (cities == null)
            {
                return NoContent();
            }
            return Ok(cities);
        }

        [Authorize(Roles = "1")]
        [HttpPost("add")]
        public async Task<IActionResult> AddCity([FromBody] AddCity addCity, [FromServices] IUpsertCityService<AddCity> upsertCityService)
        {
            if (addCity == null)
            {
                return BadRequest();

            }

            await upsertCityService.Add(addCity);
            return Ok(new { Message = "City added successfully!" });
        }

        [Authorize(Roles = "1")]
        [HttpPut("edit")]
        public async Task<IActionResult> EditCity([FromBody] EditCity editCity, int id, [FromServices] IUpsertCityService<AddCity> upsertCityService)
        {
            if (editCity == null)
            {
                return BadRequest();

            }

            await upsertCityService.Edit(editCity, id);
            return Ok(new { Message = "Changes saved successfully!" });
        }

        [Authorize(Roles = "1")]
        [HttpDelete("delete")]
        public async Task<IActionResult> Delete(int id, [FromServices] IDeleteCityService deleteService)
        {
            if (await deleteService.Delete(id))
            {
                return Ok(new { Message = "City deleted"! });
            }
            return BadRequest(new { Message = "There is no city with this ID!" });
        }
    }
}
