using ZEN_Yoga.Models.Exceptions;
using ZEN_Yoga.Services.Services.Role;

namespace ZEN_YogaWebAPI.Middleware
{
    public class ExceptionHandlingMiddleware
    {
        private readonly RequestDelegate _next;
        

        public ExceptionHandlingMiddleware(RequestDelegate next)
        {
            _next = next;
            
        }

        public async Task InvokeAsync(HttpContext context)
        {
            try
            {
                await _next(context);
            }
            catch (Exception ex)
            {
              

                context.Response.ContentType = "application/json";
                context.Response.StatusCode = ex switch
                {
                    SubscriptionTypeNotFoundException or
                    YogaTypeNotFoundException or
                    CityNotFoundException or 
                    RoleNotFoundException or
                    StudioAlreadyExistsException or
                    UserAlreadyExistsException => StatusCodes.Status400BadRequest,

                    StudioNotFoundException or
                    UserNotFoundException => StatusCodes.Status404NotFound,


                    _ => StatusCodes.Status500InternalServerError
                };

                var result = new
                {
                    error = ex.Message,
                    status = context.Response.StatusCode
                };

                await context.Response.WriteAsJsonAsync(result);
            }
        }
    }
}
