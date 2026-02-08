using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Options;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using ZEN_Yoga.Models.Requests;
using ZEN_Yoga.Services.Configurations;
using ZEN_Yoga.Services.Interfaces.User;

namespace ZEN_YogaWebAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AuthController : ControllerBase
    {
        private readonly JwtSettings _jwtSettings;

        public AuthController(IOptions<JwtSettings> options)
        {
            _jwtSettings = options.Value;
        }

        [HttpPost("login")]
        public async Task<ActionResult> Login([FromBody] LoginUser loginUser, [FromServices] IGetUserService getUserService)
        {


            var user = await getUserService.GetByEmailandPassword(loginUser.Email, loginUser.Password);

            if (user == null) return Unauthorized("Invalid credentials");

      

            var claims = new List<Claim>
            {
                new Claim("id", user.Id.ToString()),
                new Claim(ClaimTypes.Email, user.Email),
                new Claim(ClaimTypes.Role, user.RoleId.ToString()),
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

            return Ok(new
            {
                token = new JwtSecurityTokenHandler().WriteToken(token)
            });
        }
    }

   
}

