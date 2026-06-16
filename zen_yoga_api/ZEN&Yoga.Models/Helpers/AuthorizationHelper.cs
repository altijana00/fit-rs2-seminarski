using System.Security.Claims;

namespace ZEN_Yoga.Models.Helpers
{
    public static class AuthorizationHelper
    {
        public static bool CanAccessUserResource(ClaimsPrincipal loggedUser, int targetUserId)
        {
            var userIdClaim = loggedUser.FindFirst("id")?.Value;
            var userRole = loggedUser.FindFirst(ClaimTypes.Role)?.Value;

            return int.Parse(userIdClaim!) == targetUserId || userRole == AuthRoles.Admin;
        }
    }
       
}