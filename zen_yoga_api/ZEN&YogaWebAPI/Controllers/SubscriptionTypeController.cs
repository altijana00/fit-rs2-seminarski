using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using ZEN_Yoga.Models;
using ZEN_Yoga.Models.Requests;
using ZEN_Yoga.Models.Responses;
using ZEN_Yoga.Services.Interfaces.Studio;
using ZEN_Yoga.Services.Interfaces.SubscriptionType;
using ZEN_Yoga.Services.Services;

namespace ZEN_YogaWebAPI.Controllers
{
    [Route("api/[controller]")]
    public class SubscriptionTypeController : ControllerBase
    {

        [HttpGet("getAll")]
        public async Task<ActionResult<List<SubscriptionTypeResponse>>> GetAll([FromServices] IGetSubscriptionTypeService getSubscriptionTypeService)
        {
            var subscriptions = await getSubscriptionTypeService.GetAll();

            if (subscriptions == null)
            {
                return NoContent();
            }
            return Ok(subscriptions);
        }

        [Authorize(Roles = "1")]
        [HttpGet("getById")]
        public async Task<ActionResult<List<SubscriptionTypeResponse>>> GetById(int id, [FromServices] IGetSubscriptionTypeService getSubscriptionTypeService)
        {
            var subscriptionType = await getSubscriptionTypeService.GetById(id);

            if (subscriptionType == null)
            {
                return NoContent();
            }
            return Ok(subscriptionType);
        }

        [Authorize(Roles = "1")]
        [HttpPost("add")]
        public async Task<IActionResult> AddSubscriptionType([FromBody] AddSubscriptionType addSubscriptionType, [FromServices] IUpsertSubscriptionTypeService<AddSubscriptionType> upsertSubscriptionTypeService)
        {
            if (addSubscriptionType == null)
            {
                return BadRequest();

            }

            await upsertSubscriptionTypeService.Add(addSubscriptionType);
            return Ok(new { Message = "Subscription type added successfully!" });
        }

        [Authorize(Roles = "1")]
        [HttpPut("edit")]
        public async Task<IActionResult> EditSubscriptionType([FromBody] EditSubscriptionType editSubscriptionType, int id, [FromServices] IUpsertSubscriptionTypeService<AddSubscriptionType> upsertSubscriptionTypeService)
        {
            if (editSubscriptionType == null)
            {
                return BadRequest();

            }

            await upsertSubscriptionTypeService.Edit(editSubscriptionType, id);
            return Ok(new { Message = "Changes saved successfully!" });
        }

        [Authorize(Roles = "1")]
        [HttpDelete("delete")]
        public async Task<IActionResult> Delete(int id, [FromServices] IDeleteSubscriptionTypeService deleteService)
        {
            if (await deleteService.Delete(id))
            {
                return Ok(new { Message = "Subscription type deleted" });
            }
            return BadRequest(new { Message = "There is no subscription type with this ID or it is currently in use!" });
        }
    }
}
