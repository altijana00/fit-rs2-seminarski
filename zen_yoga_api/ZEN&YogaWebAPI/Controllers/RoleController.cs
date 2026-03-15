using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using ZEN_Yoga.Models;
using ZEN_Yoga.Models.Requests;
using ZEN_Yoga.Models.Responses;
using ZEN_Yoga.Models.SearchObjects;
using ZEN_Yoga.Services.Interfaces.Role;
using ZEN_Yoga.Services.Interfaces.YogaType;
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

        [Authorize(Roles = "1")]
        [HttpGet("getRolesQuery")]
        public async Task<ActionResult<List<RoleResponse>>> GetRolesQuery([FromServices] IGetRoleService getRoleService, [FromQuery] RoleQuery roleQuery)
        {
            var roles = await getRoleService.GetRolesQuery(roleQuery);

            if (roles == null)
            {
                return NoContent();
            }
            return Ok(roles);
        }


        [Authorize(Roles = "1")]
        [HttpPost("add")]
        public async Task<IActionResult> AddRole([FromBody] AddRole addRole, [FromServices] IUpsertRoleService<AddRole> upsertRoleService)
        {
            if (addRole == null)
            {
                return BadRequest();

            }

            await upsertRoleService.Add(addRole);
            return Ok(new { Message = "Role added successfully!" });
        }

        [Authorize(Roles = "1")]
        [HttpPut("edit")]
        public async Task<IActionResult> EditRole([FromBody] EditRole editRole, int id, [FromServices] IUpsertRoleService<AddRole> upsertRoleService)
        {
            if (editRole == null)
            {
                return BadRequest();

            }

            await upsertRoleService.Edit(editRole, id);
            return Ok(new { Message = "Changes saved successfully!" });
        }

        [Authorize(Roles = "1")]
        [HttpDelete("delete")]
        public async Task<IActionResult> Delete(int id, [FromServices] IDeleteRoleService deleteService)
        {
            if (await deleteService.Delete(id))
            {
                return Ok(new { Message = "Role deleted" });
            }
            return BadRequest(new { Message = "There is no role with this ID or it is currently in use!" });
        }
    }
}
