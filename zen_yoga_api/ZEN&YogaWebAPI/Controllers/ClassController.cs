using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using ZEN_Yoga.Models.Requests;
using ZEN_Yoga.Models.Responses;
using ZEN_Yoga.Models.SearchObjects;
using ZEN_Yoga.Services.Interfaces.Base;
using ZEN_Yoga.Services.Interfaces.Class;
using ZEN_Yoga.Services.Interfaces.YogaType;
using ZEN_Yoga.Services.Services;
using ZEN_Yoga.Services.Services.Class;

namespace ZEN_YogaWebAPI.Controllers
{
    [Route("api/[controller]")]
    public class ClassController : ControllerBase
    {

        [Authorize(Roles = "1")]
        [HttpGet("getAll")]
        public async Task<ActionResult<List<ClassResponse>>> GetAll([FromServices] IGetClassService getClassService)
        {
            var classes = await getClassService.GetAll();

            if (classes == null)
            {
                return NoContent();
            }
            return Ok(classes);
        }

        [Authorize(Roles = "1, 2, 3, 4")]
        [HttpGet("getById")]
        public async Task<ActionResult<ClassResponse>> GetById([FromServices] IGetClassService getClassService, int id)
        {
            var clasRes = await getClassService.GetById(id);

            if (clasRes == null)
            {
                return NoContent();
            }
            return Ok(clasRes);
        }

        [Authorize(Roles = "1, 2, 3, 4")]
        [HttpGet("getByInstructorId")]
        public async Task<ActionResult<ClassResponse>> GetByInstructorId([FromServices] IGetClassService getClassService, int instructorId, [FromQuery] ClassQuery? classQuery)
        {
            var classes = await getClassService.GetByInstructorId(instructorId, classQuery);

            if (classes == null)
            {
                return NoContent();
            }
            return Ok(classes);
        }

        [Authorize(Roles = "1, 2, 3, 4")]
        [HttpGet("getByStudioId")]
        public async Task<ActionResult<ClassResponse>> GetByStudioId([FromServices] IGetClassService getClassService, int studioId)
        {
            var classes = await getClassService.GetByStudioId(studioId);

            if (classes == null)
            {
                return NoContent();
            }
            return Ok(classes);
        }

        [Authorize(Roles = "1, 3")]
        [HttpPost("add")]
        public async Task<IActionResult> Add([FromServices] IUpsertClassService<AddClass> upsertClassService, 
                                             [FromBody] AddClass addClass, 
                                             int instructorId, 
                                             [FromServices] IYogaTypeValidatorService yogaTypeValidatorService)
        {
            if (addClass == null)
            {
                return BadRequest();
            }


            await upsertClassService.Add(addClass, instructorId, yogaTypeValidatorService);

            return Ok(new { Message = "Class added!" });
        }


        [Authorize(Roles = "1, 3")]
        [HttpPut("edit")]
        public async Task<IActionResult> EditClass([FromServices] IUpsertClassService<AddClass> upsertService, [FromBody] EditClass editClass, int id)
        {
            if (editClass == null)
            {
                return BadRequest();
            }


            await upsertService.Edit(editClass, id);

            return Ok(new { Message = "Changes saved successfully!" });
        }

        [Authorize(Roles = "1, 3")]
        [HttpDelete("delete")]
        public async Task<IActionResult> Delete([FromQuery] int id, [FromServices] IDeleteClassService deleteService)
        {
            if (await deleteService.Delete(id))
            {
                return Ok(new { Message = "Class deleted"! });
            }
            return BadRequest(new { Message = "There is no class with this ID!" });
        }

        [Authorize(Roles = "1, 2, 3, 4")]
        [HttpGet("groupped")]
        public async Task<ActionResult<GrouppedClasses>> GetGroupped([FromServices] IGetClassService getClassService)
        {
            var grouppedClasses = await getClassService.GetGroupped();

            if(grouppedClasses == null)
            {
                return NoContent();
            }
            return Ok(grouppedClasses);
        }

        [Authorize(Roles = "1, 2, 3, 4")]
        [HttpGet("studioGroupped")]
        public async Task<ActionResult<GrouppedClasses>> GetStudioGroupped([FromServices] IGetClassService getClassService, int studioId)
        {
            var grouppedClasses = await getClassService.GetStudioGroupped(studioId);

            if (grouppedClasses == null)
            {
                return NoContent();
            }
            return Ok(grouppedClasses);
        }
    }
}
