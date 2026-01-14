using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using ZEN_Yoga.Models;
using ZEN_Yoga.Models.Responses;
using ZEN_Yoga.Services.Interfaces.YogaType;
using ZEN_Yoga.Services.Services;

namespace ZEN_YogaWebAPI.Controllers
{
    [Route("api/[controller]")]
    public class YogaTypeController : ControllerBase
    {

        [HttpGet("getAll")]
        public async Task<ActionResult<List<YogaTypeResponse>>> GetAll([FromServices] IGetYogaTypeService getYogaTypeService)
        {
            var yogaTypes = await getYogaTypeService.GetAll();

            if (yogaTypes == null)
            {
                return NoContent();
            }
            return Ok(yogaTypes);
        }

        [Authorize(Roles = "1")]
        [HttpGet("getById")]
        public async Task<ActionResult<YogaTypeResponse>> GetById(int id, [FromServices] IGetYogaTypeService getYogaTypeService)
        {
            var yogaType = await getYogaTypeService.GetById(id);

            if (yogaType == null)
            {
                return NoContent();
            }
            return Ok(yogaType);
        }
    }
}
