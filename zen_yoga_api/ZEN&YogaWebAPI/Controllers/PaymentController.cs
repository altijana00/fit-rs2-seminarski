using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Stripe;
using ZEN_Yoga.Models.Enums;
using ZEN_Yoga.Models.Helpers;
using ZEN_Yoga.Models.Requests;
using ZEN_Yoga.Models.Responses;
using ZEN_Yoga.Models.SearchObjects;
using ZEN_Yoga.Services.Interfaces.Notification;
using ZEN_Yoga.Services.Interfaces.Payment;
using ZEN_Yoga.Services.Interfaces.Studio;
using ZEN_Yoga.Services.Interfaces.User;

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


        [Authorize(Roles = AuthRoles.AdminOrParticipant)]
        [HttpPost("add")]
        public async Task<IActionResult> AddPayment([FromServices] IUpsertPaymentService paymentService,
                                                    int userId, int studioId, int amount, string paymentIntentId,
                                                    [FromServices] IGetStudioService getStudioService,
                                                    [FromServices] IGetUserService getUserService,
                                                    [FromServices] ISendInAppNotificationService sendInAppNotificationService,
                                                    [FromServices] IUpsertNotificationService<AddNotification> upsertNotificationService)
        {
            var studio = await getStudioService.GetById(studioId);
            var user = await getUserService.GetById(userId);
            var admins = await getUserService.GetAdminUsers((int.Parse(AuthRoles.Admin)));

            if (await paymentService.AddPayment(userId, studioId, amount, paymentIntentId))
            {


                _logger.LogInformation($"Processing payment for (UserID): {userId} to (StudioID): {studioId}");

                var notification = new AddNotification()
                {
                    Title = "Payment success",
                    Content = $"Welcome to {studio.Name}, your payment has been successful!",
                    Type = NotificationType.Success.ToString(),
                    UserId = userId,
                };

                _logger.LogDebug($"Sending notification to userId: {userId}");
                await sendInAppNotificationService.SendToUserAsync(userId.ToString(), notification);

                await upsertNotificationService.Add(notification);

                foreach (var a in admins)
                {
                    var adminNotification = new AddNotification()
                    {
                        Title = "Payment success",
                        Content = $"Payment for studio {studio.Name} from user {user.FirstName} has ben successful.",
                        Type = NotificationType.Success.ToString(),
                        UserId = a.Id,
                    };

                    _logger.LogDebug($"Sending notification to userId: {a.Id}");
                    await sendInAppNotificationService.SendToUserAsync(a.Id.ToString(), adminNotification);
                    await upsertNotificationService.Add(adminNotification);

                    return Ok(new { Message = "Payment is in processing! You have joined the studio!" });
                }
       
            }

            var notificationError = new AddNotification()
            {
                Title = "Payment failed",
                Content = $"Unable to make payment for {studio.Name}!",
                Type = NotificationType.Error.ToString(),
                UserId = userId,
            };

            _logger.LogDebug($"Sending notification to userId: {userId}");
            await sendInAppNotificationService.SendToUserAsync(userId.ToString(), notificationError);

            await upsertNotificationService.Add(notificationError);

            foreach (var a in admins)
            {
                var adminNotificationError = new AddNotification()
                {
                    Title = "Payment failed",
                    Content = $"Payment for studio {studio.Name} from user {user.FirstName} has failed.",
                    Type = NotificationType.Error.ToString(),
                    UserId = a.Id,
                };

                _logger.LogDebug($"Sending notification to userId: {a.Id}");
                await sendInAppNotificationService.SendToUserAsync(a.Id.ToString(), adminNotificationError);
                await upsertNotificationService.Add(adminNotificationError);
            }

            _logger.LogInformation($"Payment for (UserID): {userId} to (StudioID): {studioId} failed");
            return BadRequest(new { Message = "Unable to make the payment!" });
        }

        [Authorize(Roles = AuthRoles.AdminOrParticipant)]
        [HttpPost("refund-payment")]
        public async Task<IActionResult> RefundPayment([FromServices] IUpsertPaymentService paymentService, 
                                                        int userId, int studioId,
                                                        [FromServices] IGetStudioService getStudioService,
                                                        [FromServices] ISendInAppNotificationService sendInAppNotificationService,
                                                        [FromServices] IUpsertNotificationService<AddNotification> upsertNotificationService)
        {

            var studio = await getStudioService.GetById(studioId);

            if (await paymentService.RefundPayment(userId, studioId))
            {
                _logger.LogInformation($"Processing refund payment for (UserID): {userId} to (StudioID): {studioId}");

                var notification = new AddNotification()
                {
                    Title = "Refund successful",
                    Content = $"Your payment for {studio.Name} is refunded!",
                    Type = NotificationType.Success.ToString(),
                    UserId = userId,
                };

                _logger.LogDebug($"Sending notification to userId: {userId}");
                await sendInAppNotificationService.SendToUserAsync(userId.ToString(), notification);

                await upsertNotificationService.Add(notification);

                return Ok(new { Message = "Payment is refunded!" });
            }
            _logger.LogInformation($"Payment refund for (UserID): {userId} to (StudioID): {studioId} failed");

            var notificationFailed = new AddNotification()
            {
                Title = "Refund failed",
                Content = $"We are unable to redund your payment for {studio.Name}",
                Type = NotificationType.Error.ToString(),
                UserId = userId,
            };

            _logger.LogDebug($"Sending notification to userId: {userId}");
            await sendInAppNotificationService.SendToUserAsync(userId.ToString(), notificationFailed);
            await upsertNotificationService.Add(notificationFailed);

            return BadRequest(new { Message = "Unable to refund the payment!" });
        }


        [Authorize(Roles = AuthRoles.AdminOrParticipant)]
        [HttpGet("isUserPaidMember")]
        public async Task<IActionResult> IsUserPaidMember([FromServices] IUpsertPaymentService paymentService, int userId, int studioId)
        {
            if (await paymentService.IsUserPaidMember(userId, studioId))
            {
                _logger.LogInformation($"UserID: {userId} is already member in (StudioID): {studioId}");
                return Ok();
            }

            _logger.LogInformation($"UserID: {userId} is not member in (StudioID): {studioId}");
            return NoContent();
        }

        [Authorize(Roles = AuthRoles.AdminOrParticipant)]
        [HttpPost("create-intent")]
        public async Task<IActionResult> CreateIntent([FromBody] CreateIntentRequest request, [FromServices] IUpsertPaymentService paymentService)
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

        [Authorize(Roles = AuthRoles.Admin)]
        [HttpGet("getAll")]
        public async Task<ActionResult<List<PaymentResponse>>> GetAll([FromServices] IGetPaymentService getPaymentService)
        {
            var payments = await getPaymentService.GetAll();

            if (payments == null)
            {
                _logger.LogInformation("No payments found");
                return NoContent();
            }
            _logger.LogInformation($"{payments.Count} payments found");
            return Ok(payments);
        }

        [Authorize(Roles = AuthRoles.Admin)]
        [HttpGet("getPaymentsTotal")]
        public async Task<ActionResult<List<PaymentResponse>>> GetPaymentsTotal([FromServices] IGetPaymentService getPaymentService)
        {
            var paymentsTotal = await getPaymentService.GetPaymentsTotal();

            _logger.LogInformation($"{paymentsTotal} payments total");
            return Ok(paymentsTotal);
        }

        [Authorize(Roles = AuthRoles.Admin)]
        [HttpGet("getPaymentsQuery")]
        public async Task<ActionResult<List<PaymentResponse>>> GetPaymentsQuery([FromServices] IGetPaymentService getPaymentService, [FromQuery] PaymentQuery paymentQuery)
        {
            var cities = await getPaymentService.GetPaymentsQuery(paymentQuery);

            if (cities == null)
            {
                _logger.LogInformation("No payments found");
                return NoContent();
            }
            _logger.LogInformation($"Successfully retrieved payments with query: {paymentQuery.Search} ");
            return Ok(cities);
        }

        [Authorize(Roles = AuthRoles.AdminOrParticipant)]
        [HttpGet("getUserPayment")]
        public async Task<ActionResult<List<PaymentResponse>>> GetUserPayments([FromServices] IGetPaymentService getPaymentService, int userId)
        {
            var payments = await getPaymentService.GetUserPayments(userId);

            if (payments == null)
            {
                _logger.LogInformation("No payments found");
                return NoContent();
            }
            _logger.LogInformation($"{payments.Count} payments found");
            return Ok(payments);
        }

        [Authorize(Roles = AuthRoles.AdminOrOwner)]
        [HttpGet("getStudioPayments")]
        public async Task<ActionResult<List<PaymentResponse>>> GetStudioPayments([FromServices] IGetPaymentService getPaymentService, int studioId)
        {
            var payments = await getPaymentService.GetStudioPayments(studioId);

            if (payments == null)
            {
                _logger.LogInformation("No payments found");
                return NoContent();
            }
            _logger.LogInformation($"{payments.Count} payments found");
            return Ok(payments);
        }

    }

    
}
