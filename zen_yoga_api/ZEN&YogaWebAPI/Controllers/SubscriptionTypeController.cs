using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using ZEN_Yoga.Models;
using ZEN_Yoga.Models.Responses;
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
    }
}
