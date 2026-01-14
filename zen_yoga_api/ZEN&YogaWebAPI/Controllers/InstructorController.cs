using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using ZEN_Yoga.Models.Requests;
using ZEN_Yoga.Models.Responses;
using ZEN_Yoga.Services.Interfaces.Base;
using ZEN_Yoga.Services.Interfaces.Instructor;
using ZEN_Yoga.Services.Interfaces.User;
using ZEN_Yoga.Services.Services;

namespace ZEN_YogaWebAPI.Controllers
{
    [Route("api/[controller]")]
    public class InstructorController : ControllerBase
    {


        [Authorize(Roles = "1, 2, 3, 4")]
        [HttpGet("getAll")]
        public async Task<ActionResult<InstructorResponse>> GetAll([FromServices] IGetInstructorService getInstructorService)
        {
            var instructors = await getInstructorService.GetAll();

            if (!instructors.Any())
            {
                return NoContent();
            }
            return Ok(instructors);
        }

        [Authorize(Roles = "1, 2, 3, 4")]
        [HttpGet("getById")]
        public async Task<ActionResult<InstructorResponse>> GetById([FromServices] IGetInstructorService getInstructorService, int id)
        {
            var instructor = await getInstructorService.GetById(id);

            if (instructor == null)
            {
                return NoContent();
            }
            return Ok(instructor);
        }

        [Authorize(Roles = "1, 2, 3, 4")]
        [HttpGet("getByEmail")]
        public async Task<ActionResult<InstructorResponse>> GetByEmail([FromServices] IGetInstructorService getInstructorService, string email)
        {
            var instructor = await getInstructorService.GetByEmail(email);

            if (instructor == null)
            {
                return NoContent();
            }
            return Ok(instructor);
        }

        [Authorize(Roles = "1, 2, 3, 4")]
        [HttpGet("getByStudioId")]
        public async Task<ActionResult<InstructorResponse>> GetByStudioId([FromServices] IGetInstructorService getInstructorService, int studioId)
        {
            var instructors = await getInstructorService.GetByStudioId(studioId);

            if (!instructors.Any())
            {
                return NoContent();
            }
            return Ok(instructors);
        }

        [Authorize(Roles = "1, 2, 3")]
        [HttpPost("add")]
        public async Task<ActionResult> Add([FromServices] IUpsertInstructorService<AddInstructor> upsertInstructorService,
                                            [FromServices] IGetUserService getUserService, 
                                            [FromServices] IInstructorValidatorService instructorValidatorService,
                                            [FromBody] AddInstructor addInstructor, 
                                            string email, 
                                            int studioId)
        {
            if (addInstructor == null)
            {
                return BadRequest(new { Message = "Failed to add. Instructor property is empty!" });
            }

            if (!ModelState.IsValid)
            {
                var errors = ModelState.Values
                                       .SelectMany(v => v.Errors)
                                       .Select(e => e.ErrorMessage)
                                       .ToList();

                return BadRequest(new { Message = errors });
            }

            await upsertInstructorService.Add(getUserService,instructorValidatorService, addInstructor, email, studioId);
            
            return Ok(new { Message = "Instructor added!" });
            
            

        }

        [Authorize(Roles = "1, 3")]
        [HttpPut("edit")]
        public async Task<IActionResult> Edit([FromBody] EditInstructor editInstructor, int id, [FromServices] IUpsertInstructorService<AddInstructor> upsertInstructorService, [FromServices] IInstructorValidatorService instructorValidatorService)
        {
            if (editInstructor == null)
            {
                return BadRequest();
            }

            if (!ModelState.IsValid)
            {
                var errors = ModelState.Values
                                       .SelectMany(v => v.Errors)
                                       .Select(e => e.ErrorMessage)
                                       .ToList();

                return BadRequest(new { Message = errors });
            }

            await instructorValidatorService.ValidateInstructorId(id);

            await upsertInstructorService.Edit(editInstructor, id);

            return Ok(new { Message = "Changes saved successfully!" });
        }

        [Authorize(Roles = "1, 2")]
        [HttpDelete("delete")]
        public async Task<IActionResult> Delete([FromQuery] int id, [FromServices] IDeleteInstructorService deleteInstructorService)
        {
             
            if (await deleteInstructorService.Delete(id))
            {
                return Ok(new { Message = "Instructor and associated classes deleted"! });
            }
            return BadRequest(new { Message = "There is no instructor with this ID!" });
        }
    }
}
