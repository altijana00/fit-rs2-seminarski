using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Stripe;
using ZEN_Yoga.Models.Requests;
using ZEN_Yoga.Services.Interfaces.Payment;

namespace ZEN_YogaWebAPI.Controllers
{
    [Route("api/[controller]")]
    public class PaymentController : ControllerBase
    {
        private readonly ILogger<PaymentController> _logger;
        public PaymentController(ILogger<PaymentController> logger)
        {
            _logger = logger;
        }
      

        [Authorize(Roles = "1, 4")]
        [HttpPost ("add")]
        public async Task<IActionResult> AddPayment([FromServices] IPaymentService paymentService, int userId, int studioId, int amount, string paymentIntentId)
        {
            if (await paymentService.AddPayment(userId, studioId, amount, paymentIntentId))
            {
                _logger.LogInformation($"Processing payment for (UserID): {userId} to (StudioID): {studioId}");
                return Ok(new { Message = "Payment is in processing! You have joined the studio!" });
            }
            _logger.LogInformation($"Payment for (UserID): {userId} to (StudioID): {studioId} failed");
            return BadRequest(new {Message = "Unable to make the payment!"});
        }

        [Authorize(Roles = "1, 4")]
        [HttpPost("refund-payment")]
        public async Task<IActionResult> RefundPayment([FromServices] IPaymentService paymentService, int userId, int studioId)
        {
            if (await paymentService.RefundPayment(userId, studioId))
            {
                _logger.LogInformation($"Processing refund payment for (UserID): {userId} to (StudioID): {studioId}");
                return Ok(new { Message = "Payment is refunded!" });
            }
            _logger.LogInformation($"Payment refund for (UserID): {userId} to (StudioID): {studioId} failed");
            return BadRequest(new { Message = "Unable to refund the payment!" });
        }


        [Authorize(Roles = "1, 4")]
        [HttpGet("isUserPaidMember")]
        public async Task<IActionResult> IsUserPaidMember([FromServices] IPaymentService paymentService, int userId, int studioId)
        {
            if (await paymentService.IsUserPaidMember(userId, studioId))
            {
                _logger.LogInformation($"UserID: {userId} is already member in (StudioID): {studioId}");
                return Ok();
            }

            _logger.LogInformation($"UserID: {userId} is not member in (StudioID): {studioId}");
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
