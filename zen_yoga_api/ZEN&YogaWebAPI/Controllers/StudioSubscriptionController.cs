using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using ZEN_Yoga.Models;
using ZEN_Yoga.Models.Requests;
using ZEN_Yoga.Models.Responses;
using ZEN_Yoga.Services.Interfaces.Base;
using ZEN_Yoga.Services.Interfaces.StudioSubscription;
using ZEN_Yoga.Services.Services;

namespace ZEN_YogaWebAPI.Controllers
{
    [Route("api/[controller]")]
    public class StudioSubscriptionController : ControllerBase
    {
        

        [HttpPost("add")]
        public async Task<IActionResult> AddSubscription(int studioId, 
                                                         int subscriptionTypeId, 
                                                         [FromBody] AddStudioSubscription addStudioSubscription, 
                                                         [FromServices] IUpsertStudioSubscriptionService<AddStudioSubscription> upsertStudioSubscriptionService)
        {


            if (await upsertStudioSubscriptionService.Add(studioId, subscriptionTypeId, addStudioSubscription))
            {
                return Ok(new { Message = "Subscription added successfully" });
            }
            return BadRequest(new { Message = "Subscription already exists!" });


        }

        [Authorize(Roles = "1")]
        [HttpGet("get")]
        public async Task<ActionResult<List<StudioSubscriptionResponse>>> GetAll([FromServices] IGetStudioSubscriptionService getStudioSubscriptionService)
        {
            var subscriptions = await getStudioSubscriptionService.GetAll();

            if (subscriptions != null)
            {
                return Ok(subscriptions);
            }
            return NoContent();


        }


        [HttpGet("getById")]
        public async Task<ActionResult<StudioSubscriptionResponse>> GetById(int id, [FromServices] IGetStudioSubscriptionService getStudioSubscriptionService)
        {
            var subscription = await getStudioSubscriptionService.GetById(id);

            if (subscription == null)
            {
                return NoContent();
            }
            return Ok(subscription);
        }

        [Authorize(Roles = "1, 4")]
        [HttpPut("edit")]
        public async Task<IActionResult> EditSubscription([FromBody] EditSubscription editSubscription, 
                                                          int id, 
                                                          [FromServices] IUpsertStudioSubscriptionService<EditSubscription> upsertStudioSubscriptionService)
        {

            if(editSubscription == null)
            {
                return BadRequest();
            }

           await upsertStudioSubscriptionService.Edit(editSubscription, id);

            return Ok(new { Message = "Changes saved successfully!" });

        }

        [Authorize(Roles = "1, 4")]
        [HttpDelete("delete")]
        public async Task<IActionResult> Delete(int id, [FromServices] IDeleteService deleteService)
        {


            if (await deleteService.Delete(id)) 
            {
                return Ok(new { Message = "Subscription deleted successfully" });
            }
            return BadRequest(new { Message = "Unable to delete subscription!" });


        }
    }
}
