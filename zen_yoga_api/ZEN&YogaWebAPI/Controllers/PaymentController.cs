using Microsoft.AspNetCore.Mvc;
using ZEN_Yoga.Services.Interfaces.Payment;
using ZEN_Yoga.Services.Interfaces.UserStudio;

namespace ZEN_YogaWebAPI.Controllers
{
    [Route("api/[controller]")]
    public class PaymentController : ControllerBase
    {
        private readonly IPaymentService _paymentService;
        private readonly IUpsertUserStudioService _userStudioService;

        public PaymentController(IPaymentService paymentService, IUpsertUserStudioService userStudioService)
        {
            _paymentService = paymentService;
            _userStudioService = userStudioService;
        }

        [HttpPost ("add")]
        public async Task<IActionResult> AddPayment(int userId, int studioId)
        {
            if (await _paymentService.AddPayment(userId, studioId))
            {
                return Ok(new { Message = "Payment successfull! You have joined the studio!" });
            }
            return BadRequest(new {Message = "Unable to make the payment!"});
        }

        [HttpGet("isUserPaidMember")]
        public async Task<IActionResult> IsUserPaidMember(int userId, int studioId)
        {
            if (await _paymentService.IsUserPaidMember(userId, studioId))
            {
                return Ok();
            }
            return NoContent();
        }
    }
}
