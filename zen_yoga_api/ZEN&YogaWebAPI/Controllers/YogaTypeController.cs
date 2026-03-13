using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using ZEN_Yoga.Models;
using ZEN_Yoga.Models.Requests;
using ZEN_Yoga.Models.Responses;
using ZEN_Yoga.Models.SearchObjects;
using ZEN_Yoga.Services.Interfaces.SubscriptionType;
using ZEN_Yoga.Services.Interfaces.User;
using ZEN_Yoga.Services.Interfaces.YogaType;
using ZEN_Yoga.Services.Services;

namespace ZEN_YogaWebAPI.Controllers
{
    [Route("api/[controller]")]
    public class YogaTypeController : ControllerBase
    {
        [Authorize(Roles = "1, 2, 3, 4")]
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


        [Authorize(Roles = "1, 2, 3, 4")]
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

        [Authorize(Roles = "1")]
        [HttpGet("getYogaTypesQuery")]
        public async Task<ActionResult<List<YogaTypeResponse>>> GetYogaTypesQuery([FromServices] IGetYogaTypeService getYogaTypeService, [FromQuery] YogaTypeQuery yogaTypeQuery)
        {
            var yogaTypes = await getYogaTypeService.GetYogaTypesQuery(yogaTypeQuery);

            if (yogaTypes == null)
            {
                return NoContent();
            }
            return Ok(yogaTypes);
        }

        [Authorize(Roles = "1")]
        [HttpPost("add")]
        public async Task<IActionResult> AddYogaType([FromBody] AddYogaType addYogaType, [FromServices] IUpsertYogaTypeService<AddYogaType> upsertYogaTypeService)
        {
            if (addYogaType == null)
            {
                return BadRequest();

            }

            await upsertYogaTypeService.Add(addYogaType);
            return Ok(new { Message = "Yoga type added successfully!" });
        }

        [Authorize(Roles = "1")]
        [HttpPut("edit")]
        public async Task<IActionResult> EditYogaType([FromBody] EditYogaType editYogaType, int id, [FromServices] IUpsertYogaTypeService<AddYogaType> upsertYogaTypeService)
        {
            if (editYogaType == null)
            {
                return BadRequest();

            }

            await upsertYogaTypeService.Edit(editYogaType, id);
            return Ok(new { Message = "Changes saved successfully!" });
        }

        [Authorize(Roles = "1")]
        [HttpDelete("delete")]
        public async Task<IActionResult> Delete(int id, [FromServices] IDeleteYogaTypeService deleteService)
        {
            if (await deleteService.Delete(id))
            {
                return Ok(new { Message = "Yoga type deleted"! });
            }
            return BadRequest(new { Message = "There is no yoga type with this ID!" });
        }
    }
}
