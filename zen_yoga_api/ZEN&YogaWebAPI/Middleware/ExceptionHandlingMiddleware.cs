using ZEN_Yoga.Models.Exceptions;

namespace ZEN_YogaWebAPI.Middleware
{
    public class ExceptionHandlingMiddleware
    {
        private readonly RequestDelegate _next;
        private readonly ILogger<ExceptionHandlingMiddleware> _logger;

        public ExceptionHandlingMiddleware(RequestDelegate next, ILogger<ExceptionHandlingMiddleware> logger)
        {
            _next = next;
            _logger = logger;
        }

        public async Task InvokeAsync(HttpContext context)
        {
            try
            {
                await _next(context);
            }
            catch (Exception ex)
            {

                _logger.LogError(ex,
                   "Exception. Path: {Path}, Method: {Method}",
                   context.Request.Path,
                   context.Request.Method);

                context.Response.ContentType = "application/json";
                context.Response.StatusCode = ex switch
                {
                    
                    StudioAlreadyExistsException or
                    MaxParticipantsReachedException or
                    ClassTimeAndLocationTakenException or
                    UserAlreadyExistsException => StatusCodes.Status400BadRequest,
                    ClassNotFoundException or              
                    YogaTypeNotFoundException or
                    RoleNotFoundException or
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
