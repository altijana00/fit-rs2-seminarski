using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using ZEN_Yoga.Models;
using ZEN_Yoga.Models.Responses;
using ZEN_Yoga.Services.Interfaces.Role;
using ZEN_Yoga.Services.Services;

namespace ZEN_YogaWebAPI.Controllers
{
    [Route("api/[controller]")]
    public class RoleController : ControllerBase
    {

        
        [HttpGet("getAll")]
        public async Task<ActionResult<List<RoleResponse>>> GetAll([FromServices] IGetRoleService getRoleService)
        {
            var roles = await getRoleService.GetAll();

            if (roles == null)
            {
                return NoContent();
            }
            return Ok(roles);
        }

        [Authorize(Roles = "1")]
        [HttpGet("getById")]
        public async Task<ActionResult<RoleResponse>> GetById([FromServices] IGetRoleService getRoleService, int id)
        {
            var role = await getRoleService.GetById(id);

            if (role == null)
            {
                return NoContent();
            }
            return Ok(role);
        }
    }
}
