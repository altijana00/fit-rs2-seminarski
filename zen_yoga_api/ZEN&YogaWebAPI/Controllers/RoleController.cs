using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using ZEN_Yoga.Models.Requests;
using ZEN_Yoga.Models.Responses;
using ZEN_Yoga.Models.SearchObjects;
using ZEN_Yoga.Services.Interfaces.Role;

namespace ZEN_YogaWebAPI.Controllers
{
    [Route("api/[controller]")]
    public class RoleController : ControllerBase
    {
        private readonly ILogger<RoleController> _logger;
        public RoleController(ILogger<RoleController> logger)
        {
            _logger = logger;
        }

        [HttpGet("getAll")]
        public async Task<ActionResult<List<RoleResponse>>> GetAll([FromServices] IGetRoleService getRoleService)
        {
            var roles = await getRoleService.GetAll();

            if (roles == null)
            {
                _logger.LogInformation("No roles retrieved");
                return NoContent();
            }

            _logger.LogInformation($"Retrieved roles: {roles.Count}");
            return Ok(roles);
        }

        [HttpGet("getById")]
        public async Task<ActionResult<RoleResponse>> GetById([FromServices] IGetRoleService getRoleService, int id)
        {
            var role = await getRoleService.GetById(id);

            if (role == null)
            {
                _logger.LogInformation("No role retrieved");
                return NoContent();
            }

            _logger.LogInformation($"Role retrieved: {id}");
            return Ok(role);
        }

        [Authorize(Roles = "1")]
        [HttpGet("getRolesQuery")]
        public async Task<ActionResult<List<RoleResponse>>> GetRolesQuery([FromServices] IGetRoleService getRoleService, [FromQuery] RoleQuery roleQuery)
        {
            var roles = await getRoleService.GetRolesQuery(roleQuery);

            if (roles == null)
            {
                _logger.LogInformation($"No roles retrieved for query: {roleQuery.Search}");
                return NoContent();
            }

            _logger.LogInformation($"Successfully retrieved role with query: {roleQuery.Search} ");

            return Ok(roles);
        }


        [Authorize(Roles = "1")]
        [HttpPost("add")]
        public async Task<IActionResult> AddRole([FromBody] AddRole addRole, [FromServices] IUpsertRoleService<AddRole> upsertRoleService)
        {
            if (addRole == null)
            {
                _logger.LogInformation($"Attempt to add role with invalid data");
                return BadRequest();

            }

            await upsertRoleService.Add(addRole);
            _logger.LogInformation($"Role added successfully!");
            return Ok(new { Message = "Role added successfully!" });
        }

        [Authorize(Roles = "1")]
        [HttpPut("edit")]
        public async Task<IActionResult> EditRole([FromBody] EditRole editRole, int id, [FromServices] IUpsertRoleService<AddRole> upsertRoleService)
        {
            if (editRole == null)
            {
                _logger.LogInformation($"Attempt to edit role with invalid data");
                return BadRequest();

            }

            await upsertRoleService.Edit(editRole, id);
            _logger.LogInformation($"Role edited successfully!");
            return Ok(new { Message = "Changes saved successfully!" });
        }

        [Authorize(Roles = "1")]
        [HttpDelete("delete")]
        public async Task<IActionResult> Delete(int id, [FromServices] IDeleteRoleService deleteService)
        {
            if (await deleteService.Delete(id))
            {
                _logger.LogInformation($"Role {id} deleted successfully!");
                return Ok(new { Message = "Role deleted" });
            }
            _logger.LogInformation($"There is no role to delete");
            return BadRequest(new { Message = "There is no role with this ID or it is currently in use!" });
        }
    }
}
