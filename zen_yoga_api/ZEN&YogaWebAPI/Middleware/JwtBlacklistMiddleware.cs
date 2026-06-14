namespace ZEN_YogaWebAPI.Middleware
{
    using Microsoft.AspNetCore.Http;
    using System.IdentityModel.Tokens.Jwt;

    public class JwtBlacklistMiddleware
    {
        private readonly RequestDelegate _next;

        public JwtBlacklistMiddleware(RequestDelegate next)
        {
            _next = next;
        }

        public async Task InvokeAsync(HttpContext context)
        {
            var jti = context.User?.FindFirst(JwtRegisteredClaimNames.Jti)?.Value;

            if (jti != null && TokenBlacklist.IsBlacklisted(jti))
            {
                context.Response.StatusCode = 401;
                return;
            }

            await _next(context);
        }
    }
}
