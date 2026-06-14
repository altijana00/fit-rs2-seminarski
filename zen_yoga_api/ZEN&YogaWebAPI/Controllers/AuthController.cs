using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Options;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using ZEN_Yoga.Models.Helpers;
using ZEN_Yoga.Models.Requests;
using ZEN_Yoga.Services.Configurations;
using ZEN_Yoga.Services.Interfaces.Notification;
using ZEN_Yoga.Services.Interfaces.User;

namespace ZEN_YogaWebAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AuthController : ControllerBase
    {
        private readonly JwtSettings _jwtSettings;
        private readonly ILogger<AuthController> _logger;

       
        public AuthController(IOptions<JwtSettings> options, ILogger<AuthController> logger)
        {
            _jwtSettings = options.Value;
            _logger = logger;
        }

        [HttpPost("login")]
        public async Task<ActionResult> Login([FromServices] IUpsertNotificationService<AddNotification> notificationService, [FromBody] LoginUser loginUser, [FromServices] IGetUserService getUserService)
        {
            var user = await getUserService.GetByEmailandPassword(loginUser.Email, loginUser.Password);

            if (user == null)
            {
                _logger.LogWarning($"Unauthorized login attempt from {loginUser.Email}");
                return Unauthorized("Invalid credentials");
            }

            var claims = new List<Claim>
            {
                new Claim("id", user.Id.ToString()),
                new Claim(ClaimTypes.Email, user.Email),
                new Claim(ClaimTypes.Role, user.RoleId.ToString()),
                new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString()),
            };

            var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_jwtSettings.SecretKey!));
            var creds = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);

            var token = new JwtSecurityToken(
                issuer: _jwtSettings.Issuer,
                audience: _jwtSettings.Audience,
                claims: claims,
                expires: DateTime.UtcNow.AddHours(12),
                signingCredentials: creds
            );

            _logger.LogInformation($"Successfull login from {loginUser.Email}");

            return Ok(new
            {
                token = new JwtSecurityTokenHandler().WriteToken(token)
            });
        }


        [Authorize(Roles = AuthRoles.AllRoles)]
        [HttpPost("logout")]
        public IActionResult Logout()
        {
            var jti = User.FindFirst(JwtRegisteredClaimNames.Jti)?.Value;

            if (string.IsNullOrEmpty(jti))
            {
                return BadRequest(new
                {
                    message = "Token does not contain valid data"
                });
            }

            TokenBlacklist.Add(jti);

            return Ok(new
            {
                message = "Logged out successfully"
            });
        }
    }

   
}

