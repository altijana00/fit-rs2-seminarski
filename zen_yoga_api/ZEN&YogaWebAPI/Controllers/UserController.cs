using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;
using System.Net;
using ZEN_Yoga.Models;
using ZEN_Yoga.Models.Requests;
using ZEN_Yoga.Models.Responses;
using ZEN_Yoga.Models.SearchObjects;
using ZEN_Yoga.Services.Interfaces.Base;
using ZEN_Yoga.Services.Interfaces.City;
using ZEN_Yoga.Services.Interfaces.Role;
using ZEN_Yoga.Services.Interfaces.Studio;
using ZEN_Yoga.Services.Interfaces.User;
using ZEN_Yoga.Services.Services;

namespace ZEN_YogaWebAPI.Controllers
{
    [Route("api/[controller]")]
    public class UserController : ControllerBase
    {

        [Authorize(Roles = "1, 2, 3")]
        [HttpGet("getAll")]        
        public async Task<ActionResult<List<UserResponse>>> GetAll([FromServices] IGetUserService getUserService)
        {
            var users = await getUserService.GetAll();

            if (users == null)
            {
                return NoContent();
            }
            return Ok(users);
        }

        [Authorize(Roles = "1, 2, 3")]
        [HttpGet("getUsersQuery")]
        public async Task<ActionResult<List<UserResponse>>> GetUsersQuery([FromServices] IGetUserService getUserService, [FromQuery] UserQuery userQuery)
        {
            var users = await getUserService.GetUsersQuery(userQuery);

            if (users == null)
            {
                return NoContent();
            }
            return Ok(users);
        }


        [Authorize(Roles = "1, 2, 3, 4")]
        [HttpGet("getById")]
        public async Task<ActionResult<List<UserResponse>>> GetById([FromServices] IGetUserService getUserService, int id)
        {
            var user = await getUserService.GetById(id);

            if (user == null) 
            {
                return NoContent();
            }

            return Ok(user);
        }

        [Authorize(Roles = "1, 2, 3, 4")]
        [HttpGet("getByEmail")]
        public async Task<ActionResult<List<UserResponse>>> GetByEmail([FromServices] IGetUserService getUserService, string email)
        {
            var user = await getUserService.GetByEmail(email);

            if (user == null)
            {
                return NoContent();
            }
            return Ok(user);
        }

        [Authorize(Roles = "1, 2, 3, 4")]
        [HttpPost("add")]
        public async Task<IActionResult> Add([FromBody] RegisterUser registerUser, 
                                            [FromServices] IUpsertUserService<RegisterUser> upsertUserService,
                                            [FromServices] IUserValidatorService userValidatorService,
                                            [FromServices] IRoleValidatorService roleValidatorService,
                                            [FromServices] ICityValidatorService cityValidatorService)
        {
            if (registerUser == null) {
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

            await upsertUserService.Add(userValidatorService, roleValidatorService, cityValidatorService, registerUser);

            return Ok(new { Message = "User registered!" });
        }

        [Authorize(Roles = "1, 2, 3, 4")]
        [HttpPut("edit")]
        public async Task<IActionResult> Edit([FromBody] EditUser editUser, int id, [FromServices] IUpsertUserService<RegisterUser> upsertUserService, [FromServices] IUserValidatorService userValidatorService)
        {
            if (editUser == null)
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

            await userValidatorService.ValidateUserId(id);

            await upsertUserService.Edit(editUser, id);

            return Ok(new { Message = "Changes saved successfully!" });
        }

        [Authorize(Roles = "1, 2, 3, 4")]
        [HttpPost("uploadUserPhoto")]
        [Consumes("multipart/form-data")]
        public async Task<IActionResult> UploadUserPhoto([FromServices] IUploadUserPhotoService uploadUserPhotoService, IFormFile file)
        {
            if (file == null || file.Length == 0)
                return BadRequest("No file uploaded!");

            var photoUrl = await uploadUserPhotoService.UploadUserPhoto(file);
            return Ok(photoUrl);

        }

        [Authorize(Roles = "1, 2, 3, 4")]
        [HttpPatch("editUserPhoto")]

        public async Task<IActionResult> EditUserPhoto([FromServices] IUploadUserPhotoService uploadUserPhotoService, string photoUrl, int userId)
        {
            if (photoUrl.IsNullOrEmpty())
            {
                return BadRequest("No file uploaded!");
            }

            await uploadUserPhotoService.EditUserPhoto(photoUrl, userId);
            return Ok();

        }


        [Authorize(Roles = "1")]
        [HttpDelete("delete")]
        public async Task<IActionResult> Delete([FromQuery]int id, [FromServices] IDeleteUserService deleteService)
        {
            if (await deleteService.Delete(id))
            {
                return Ok(new { Message = "User deleted"! });
            }
            return BadRequest(new { Message = "There is no user with this ID!" });
        }

        [Authorize(Roles = "1,2,3,4")]
        [HttpPatch("updateUserPassword")]
        public async Task<IActionResult> UpdateUserPassword(UpdateUserPassword updateUserPassword, [FromServices] IUpsertUserService<RegisterUser> upsertUserService, string token)
        {
            var result = await upsertUserService.UpdateUserPassword(updateUserPassword, token);

            if (result == "Ok") return Ok(new { Message = "Password updated"! });
            if (result == "Error") return StatusCode((int)HttpStatusCode.InternalServerError, "An unexpected error occurred.");

            return BadRequest(new { Message = result });
        }
    }
}
