using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Stripe;
using ZEN_Yoga.Models;
using ZEN_Yoga.Models.Enums;
using ZEN_Yoga.Models.Requests;
using ZEN_Yoga.Services.Interfaces.Notification;
using ZEN_Yoga.Services.Interfaces.Payment;
using ZEN_Yoga.Services.Interfaces.Studio;
using ZEN_Yoga.Services.Services.Notifications;
using ZEN_Yoga.Services.Services.Studio;
using ZEN_YogaWebAPI.Notifications;

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
        public async Task<IActionResult> AddPayment([FromServices] IPaymentService paymentService, 
                                                    int userId, int studioId, int amount, string paymentIntentId, 
                                                    [FromServices] IGetStudioService getStudioService,
                                                    [FromServices] ISendInAppNotificationService sendInAppNotificationService,
                                                    [FromServices] IUpsertNotificationService<AddNotification> upsertNotificationService)
        {
            if (await paymentService.AddPayment(userId, studioId, amount, paymentIntentId))
            {
                _logger.LogInformation($"Processing payment for (UserID): {userId} to (StudioID): {studioId}");
                return Ok(new { Message = "Payment is in processing! You have joined the studio!" });
            }

            var studio = await getStudioService.GetById(studioId);

            // SLANJE INAPP (SIGNAL R)
            var notification = new AddNotification()
            {
                Title = "Payment failed",
                Content = $"Unable to make payment for {studio.Name}!",
                Type = NotificationType.Error.ToString(),
                UserId = userId,
            };

            _logger.LogDebug($"Sending notification to userId: {userId}");
            await sendInAppNotificationService.SendToUserAsync(userId.ToString(), notification);

            // SPREMI U BAZU
            await upsertNotificationService.Add(notification);

            _logger.LogInformation($"Payment for (UserID): {userId} to (StudioID): {studioId} failed");
            return BadRequest(new {Message = "Unable to make the payment!"});
        }

        [Authorize(Roles = "1, 4")]
        [HttpPost("refund-payment")]
        public async Task<IActionResult> RefundPayment([FromServices] IPaymentService paymentService, 
                                                        int userId, int studioId,
                                                        [FromServices] IGetStudioService getStudioService,
                                                        [FromServices] ISendInAppNotificationService sendInAppNotificationService,
                                                        [FromServices] IUpsertNotificationService<AddNotification> upsertNotificationService)
        {

            var studio = await getStudioService.GetById(studioId);

            if (await paymentService.RefundPayment(userId, studioId))
            {
                _logger.LogInformation($"Processing refund payment for (UserID): {userId} to (StudioID): {studioId}");

                // SLANJE INAPP (SIGNAL R)
                var notification = new AddNotification()
                {
                    Title = "Refund successful",
                    Content = $"Your payment for {studio.Name} is refunded!",
                    Type = NotificationType.Success.ToString(),
                    UserId = userId,
                };

                _logger.LogDebug($"Sending notification to userId: {userId}");
                await sendInAppNotificationService.SendToUserAsync(userId.ToString(), notification);

                // SPREMI U BAZU
                await upsertNotificationService.Add(notification);

                return Ok(new { Message = "Payment is refunded!" });
            }
            _logger.LogInformation($"Payment refund for (UserID): {userId} to (StudioID): {studioId} failed");

            // SLANJE INAPP (SIGNAL R)
            var notificationFailed = new AddNotification()
            {
                Title = "Refund failed",
                Content = $"We are unable to redund your payment for {studio.Name}",
                Type = NotificationType.Error.ToString(),
                UserId = userId,
            };

            _logger.LogDebug($"Sending notification to userId: {userId}");
            await sendInAppNotificationService.SendToUserAsync(userId.ToString(), notificationFailed);

            // SPREMI U BAZU
            await upsertNotificationService.Add(notificationFailed);

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
