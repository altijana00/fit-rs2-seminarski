using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using ZEN_Yoga.Models;
using ZEN_Yoga.Models.Requests;
using ZEN_Yoga.Models.Responses;
using ZEN_Yoga.Models.SearchObjects;
using ZEN_Yoga.Services.Interfaces.City;

namespace ZEN_YogaWebAPI.Controllers
{
    [Route("api/[controller]")]
    public class CityController : ControllerBase
    {
        private readonly ILogger<CityController> _logger;
        public CityController(ILogger<CityController> logger)
        {
            _logger = logger;
        }

        [HttpGet("getAll")]
        public async Task<ActionResult<List<CityResponse>>> GetAll([FromServices] IGetCityService getCityService)
        {
            var cities = await getCityService.GetAll();

            if (cities == null)
            {
                _logger.LogInformation("No cities found");
                return NoContent();
            }
            _logger.LogInformation($"Successfully retrieved cities: {cities.Count}");
            return Ok(cities);
        }

        
        [HttpGet("getById")]
        public async Task<ActionResult<CityResponse>> GetById([FromServices] IGetCityService getCityService, int id)
        {
            var city = await getCityService.GetById(id);

            if (city == null)
            {
                _logger.LogInformation("No city found");
                return NoContent();
            }
            _logger.LogInformation("Successfully retrieved city");
            return Ok(city);
        }

        [Authorize(Roles = "1")]
        [HttpGet("getCitiesQuery")]
        public async Task<ActionResult<List<CityResponse>>> GetCitiesQuery([FromServices] IGetCityService getCityService, [FromQuery] CityQuery cityQuery)
        {
            var cities = await getCityService.GetCitiesQuery(cityQuery);

            if (cities == null)
            {
                _logger.LogInformation("No cites found");
                return NoContent();
            }
            _logger.LogInformation($"Successfully retrieved city with query: {cityQuery.Search} ");
            return Ok(cities);
        }

        [Authorize(Roles = "1")]
        [HttpPost("add")]
        public async Task<IActionResult> AddCity([FromBody] AddCity addCity, [FromServices] IUpsertCityService<AddCity> upsertCityService)
        {
            if (addCity == null)
            {
                _logger.LogInformation("City data was null");
                _logger.LogInformation("City data: {@addCity}", addCity);
                return BadRequest();

            }

            if (!ModelState.IsValid)
            {
                var errors = ModelState.Values
                                       .SelectMany(v => v.Errors)
                                       .Select(e => e.ErrorMessage)
                                       .ToList();

                _logger.LogInformation("City data was invalid: {Errors}", string.Join(", ", errors));
                return BadRequest(new { Message = errors });
            }

            await upsertCityService.Add(addCity);
            _logger.LogInformation($"City added successfully: {addCity.Name}");
            return Ok(new { Message = "City added successfully!" });
        }

        [Authorize(Roles = "1")]
        [HttpPut("edit")]
        public async Task<IActionResult> EditCity([FromBody] EditCity editCity, int id, [FromServices] IUpsertCityService<AddCity> upsertCityService)
        {
            if (editCity == null)
            {
                _logger.LogInformation("City was null");
                return BadRequest();

            }

            if (!ModelState.IsValid)
            {
                var errors = ModelState.Values
                                       .SelectMany(v => v.Errors)
                                       .Select(e => e.ErrorMessage)
                                       .ToList();

                _logger.LogInformation("City data was invalid: {Errors}", string.Join(", ", errors));
                return BadRequest(new { Message = errors });
            }

            await upsertCityService.Edit(editCity, id);
            _logger.LogInformation($"City edited successfully: {editCity.Name}");
            return Ok(new { Message = "Changes saved successfully!" });
        }

        [Authorize(Roles = "1")]
        [HttpDelete("delete")]
        public async Task<IActionResult> Delete(int id, [FromServices] IDeleteCityService deleteService)
        {
            if (await deleteService.Delete(id))
            {
                _logger.LogInformation("City is deleted");
                return Ok(new { Message = "City deleted!" });
            }
            _logger.LogInformation("Attemp to delete a city with non-existing ID or that is currently in use!");
            return BadRequest(new { Message = "There is no city with this ID or it is currently in use!" });
        }
    }
}
