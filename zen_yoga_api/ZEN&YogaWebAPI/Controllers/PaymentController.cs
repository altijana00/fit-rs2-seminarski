using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Stripe;
using ZEN_Yoga.Models;
using ZEN_Yoga.Models.Requests;
using ZEN_Yoga.Services.Interfaces.Payment;

namespace ZEN_YogaWebAPI.Controllers
{
    [Route("api/[controller]")]
    public class PaymentController : ControllerBase
    {
        private readonly IPaymentService _paymentService;

        public PaymentController(IPaymentService paymentService)
        {
            _paymentService = paymentService;
        }

        [Authorize(Roles = "1, 4")]
        [HttpPost ("add")]
        public async Task<IActionResult> AddPayment(int userId, int studioId, int amount, string paymentIntentId)
        {
            if (await _paymentService.AddPayment(userId, studioId, amount, paymentIntentId))
            {
                return Ok(new { Message = "Payment is in processing! You have joined the studio!" });
            }
            return BadRequest(new {Message = "Unable to make the payment!"});
        }


        [Authorize(Roles = "1, 4")]
        [HttpGet("isUserPaidMember")]
        public async Task<IActionResult> IsUserPaidMember(int userId, int studioId)
        {
            if (await _paymentService.IsUserPaidMember(userId, studioId))
            {
                return Ok();
            }
            return NoContent();
        }

        [Authorize(Roles = "1, 4")]
        [HttpPost("create-intent")]
        public async Task<IActionResult> CreateIntent([FromBody] CreateIntentRequest request, [FromServices] IPaymentService paymentService)
        {
            try
            {
                var result = await paymentService.CreatePaymentIntentAsync(
                    request.Amount.ToString(),
                    request.Currency
                );
                return Ok(result);
            }
            catch (StripeException ex)
            {
                return BadRequest(new { error = ex.StripeError.Message });
            }
        }

    }

    
}
