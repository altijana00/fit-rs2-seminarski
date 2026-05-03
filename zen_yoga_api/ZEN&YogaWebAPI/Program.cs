using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Diagnostics;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Options;
using Microsoft.IdentityModel.Tokens;
using Microsoft.OpenApi.Models;
using System.Security.Claims;
using System.Text;
using System.Text.Json;
using ZEN_Yoga.Models;
using ZEN_Yoga.Models.Helpers;
using ZEN_Yoga.Models.Requests;
using ZEN_Yoga.Services.Configurations;
using ZEN_Yoga.Services.Interfaces.Analytics;
using ZEN_Yoga.Services.Interfaces.BlobStorage;
using ZEN_Yoga.Services.Interfaces.City;
using ZEN_Yoga.Services.Interfaces.Class;
using ZEN_Yoga.Services.Interfaces.Instructor;
using ZEN_Yoga.Services.Interfaces.Notification;
using ZEN_Yoga.Services.Interfaces.Payment;
using ZEN_Yoga.Services.Interfaces.Role;
using ZEN_Yoga.Services.Interfaces.Studio;
using ZEN_Yoga.Services.Interfaces.User;
using ZEN_Yoga.Services.Interfaces.UserClass;
using ZEN_Yoga.Services.Interfaces.YogaType;
using ZEN_Yoga.Services.Services.Analytics;
using ZEN_Yoga.Services.Services.BlobStorage;
using ZEN_Yoga.Services.Services.City;
using ZEN_Yoga.Services.Services.Class;
using ZEN_Yoga.Services.Services.Instructor;
using ZEN_Yoga.Services.Services.Notifications;
using ZEN_Yoga.Services.Services.Payment;
using ZEN_Yoga.Services.Services.Role;
using ZEN_Yoga.Services.Services.Studio;
using ZEN_Yoga.Services.Services.User;
using ZEN_Yoga.Services.Services.UserClass;
using ZEN_Yoga.Services.Services.YogaType;
using ZEN_YogaWebAPI.Mapper;
using ZEN_YogaWebAPI.Middleware;
using ZEN_YogaWebAPI.Notifications;

var myAllowSpecificOrigins = "_myAllowSpecificOrigins";

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();

builder.Services.AddDbContext<ZenYogaDbContext>(options =>
{
    options.UseSqlServer(
        builder.Configuration.GetConnectionString("DefaultConnection"), sqlOptions => sqlOptions.MigrationsAssembly("ZEN&Yoga.WebAPI"));

    

}, ServiceLifetime.Scoped);

builder.Services.AddControllers()
    .AddJsonOptions(options =>
    {
        options.JsonSerializerOptions.PropertyNamingPolicy = JsonNamingPolicy.CamelCase;
    });


builder.Services.Configure<AzureBlobStorageSettings>
    (
        builder.Configuration.GetSection("AzureBlobStorage")
    );

builder.Services.Configure<RabbitMqSettings>
    (
        builder.Configuration.GetSection("RabbitMQ")
    );

builder.Services.Configure<JwtSettings>
    (
        builder.Configuration.GetSection("JwtSettings")
    );

builder.Services.Configure<HashingSettings>
    (
        builder.Configuration.GetSection("HashingSettings")
    );

builder.Services.Configure<StripeSettings>
    (
        builder.Configuration.GetSection("StripeSettings")
    );

builder.Services.AddScoped<IBlobStorageService, BlobStorageService>();


//Base

//User
builder.Services.AddScoped<IGetUserService, GetUserService>();
builder.Services.AddScoped<IUpsertUserService<RegisterUser>, UpsertUserService>();
builder.Services.AddScoped<IDeleteUserService, DeleteUserService>();
builder.Services.AddScoped<IUserValidatorService, UserValidatorService>();
builder.Services.AddScoped<IUploadUserPhotoService, UploadUserPhotoService>();

//City
builder.Services.AddScoped<IGetCityService, GetCityService>();
builder.Services.AddScoped<ICityValidatorService, CityValidatorService>();
builder.Services.AddScoped<IDeleteCityService, DeleteCityService>();
builder.Services.AddScoped<IUpsertCityService<AddCity>, UpsertCityService>();

//Class
builder.Services.AddScoped<IGetClassService, GetClassService>();
builder.Services.AddScoped<IDeleteClassService, DeleteClassService>();
builder.Services.AddScoped<IUpsertClassService<AddClass>, UpsertClassService>();

//Instructor
builder.Services.AddScoped<IGetInstructorService, GetInstructorService>();
builder.Services.AddScoped<IUpsertInstructorService<AddInstructor>, UpsertInstructorService>();
builder.Services.AddScoped<IInstructorValidatorService, InstructorValidatorService>();
builder.Services.AddScoped<IDeleteInstructorService, DeleteInstructorService>();



//Role
builder.Services.AddScoped<IGetRoleService, GetRoleService>();
builder.Services.AddScoped<IRoleValidatorService, RoleValidatorService>();
builder.Services.AddScoped<IDeleteRoleService, DeleteRoleService>();
builder.Services.AddScoped<IUpsertRoleService<AddRole>, UpsertRoleService>();

//Studio
builder.Services.AddScoped<IGetStudioService, GetStudioService>();
builder.Services.AddScoped<IUpsertStudioService<AddStudio>, UpsertStudioService>();
builder.Services.AddScoped<IDeleteStudioService, DeleteStudioService>();
builder.Services.AddScoped<IStudioValidatorService, StudioValidatorService>();
builder.Services.AddScoped<IUploadStudioPhotoService, UploadStudioPhotoService>();
builder.Services.AddScoped<IUploadStudioGalleryService, UploadStudioGalleryService>();
builder.Services.AddScoped<IGetStudioGalleryService, GetStudioGalleryService>();
builder.Services.AddScoped<IDeleteStudioGalleryPhotoService, DeleteStudioGalleryPhotoService>();




//UserClass
builder.Services.AddScoped<IGetUserClassService, GetUserClassService>();
builder.Services.AddScoped<IUpsertUserClassService, UpsertUserClassService>();
builder.Services.AddScoped<IDeleteUserClassService, DeleteUserClassService>();


//YogaType
builder.Services.AddScoped<IGetYogaTypeService, GetYogaTypeService>();
builder.Services.AddScoped<IYogaTypeValidatorService, YogaTypeValidatorService>();
builder.Services.AddScoped<IDeleteYogaTypeService, DeleteYogaTypeService>();
builder.Services.AddScoped<IUpsertYogaTypeService<AddYogaType>, UpsertYogaTypeService>();


builder.Services.AddScoped<IAppAnalyticsService, AppAnalyticsService>();
builder.Services.AddScoped<IPaymentService, PaymentService>();
builder.Services.AddScoped<IStudioAnalyticsService, StudioAnalyticsService>();

builder.Services.AddScoped<IGetNotificationService, GetNotificationService>();
builder.Services.AddScoped<IUpsertNotificationService<AddNotification>, UpsertNotificationService>();
builder.Services.AddScoped<IDeleteNotificationService, DeleteNotificationService>();






builder.Services.AddAutoMapper(typeof(MapperProfile));

builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
    .AddJwtBearer((options) =>
    {
        var jwtSettings = builder.Configuration
            .GetSection("JwtSettings")
            .Get<JwtSettings>();

        options.TokenValidationParameters = new TokenValidationParameters
        {
            ValidateIssuer = true,
            ValidateAudience = true,
            ValidateLifetime = true,
            ValidateIssuerSigningKey = true,

            ValidIssuer = jwtSettings!.Issuer,
            ValidAudience = jwtSettings.Audience,
            IssuerSigningKey = new SymmetricSecurityKey(
                Encoding.UTF8.GetBytes(jwtSettings.SecretKey!))
        };
    });

builder.Services.AddSwaggerGen(c =>
{

    // 🔑 Security scheme za Bearer token
    c.AddSecurityDefinition("Bearer", new OpenApiSecurityScheme
    {
        Name = "Authorization",
        Type = SecuritySchemeType.ApiKey,
        Scheme = "Bearer",
        BearerFormat = "JWT",
        In = ParameterLocation.Header,
        Description = "Unesi JWT token u formatu: Bearer {token}"
    });

    c.AddSecurityRequirement(new OpenApiSecurityRequirement
    {
        {
            new OpenApiSecurityScheme
            {
                Reference = new OpenApiReference
                {
                    Type = ReferenceType.SecurityScheme,
                    Id = "Bearer"
                }
            },
            new string[] {}
        }
    });
});

builder.Services.AddAuthorization();


builder.Services.AddCors(options =>
{
    options.AddPolicy(name: myAllowSpecificOrigins,
        builder =>
        {
            builder.AllowAnyOrigin()
            .AllowAnyMethod()
            .AllowAnyHeader();
        }
    );
});

builder.Services.AddSignalR();
builder.Services.AddScoped<ISendInAppNotificationService, SendInAppNotificationService>();




var app = builder.Build();

var hashingSettings = app.Services
    .GetRequiredService<IOptions<HashingSettings>>()
    .Value;

HashingConfig.Init(hashingSettings);

app.UseMiddleware<ExceptionHandlingMiddleware>();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.UseAuthentication();
app.UseAuthorization();

app.MapControllers();

using (var scope = app.Services.CreateScope())
{
    var db = scope.ServiceProvider.GetRequiredService<ZenYogaDbContext>();

    db.Database.Migrate();
}

app.MapHub<NotificationHub>("/hubs/notifications");

app.UseExceptionHandler(errorApp =>
{
    errorApp.Run(async context =>
    {
        var logger = context.RequestServices.GetRequiredService<ILogger<Program>>();
        var exception = context.Features.Get<IExceptionHandlerFeature>()?.Error;

        logger.LogError(exception,
            "Unhandled exception. Path: {Path}, Method: {Method}",
            context.Request.Path,
            context.Request.Method);

        context.Response.StatusCode = 500;
        await context.Response.WriteAsync("Error ocurred");
    });
});

//app.Use(async (context, next) =>
//{
//    var logger = context.RequestServices.GetRequiredService<ILogger<Program>>();
//    logger.LogInformation("API Request Triggered: Path: {Path}, Method: {Method}",
//            context.Request.Path,
//            context.Request.Method);
//    await next();
//});

app.Use(async (context, next) =>
{
    var logger = context.RequestServices.GetRequiredService<ILogger<Program>>();

    var user = context.User;
    var userId = user?.Identity?.IsAuthenticated == true
        ? user.FindFirst("id")?.Value ?? user.Identity.Name
        : "Anonymous";

    var roles = user?.Claims
        .Where(c => c.Type == ClaimTypes.Role)
        .Select(c => c.Value);

    var endpoint = context.GetEndpoint();
    var authorizeData = endpoint?.Metadata.GetOrderedMetadata<IAuthorizeData>();

    var requiredRoles = authorizeData?
    .Where(a => !string.IsNullOrEmpty(a.Roles))
    .SelectMany(a => a.Roles!.Split(',', StringSplitOptions.RemoveEmptyEntries))
    .Select(r => r.Trim()).FirstOrDefault();

    logger.LogInformation(
        "Request {Method} {Path} by user {UserId}. UserRoles: {UserRoles}. RequiredRoles: {RequiredRoles}",
        context.Request.Method,
        context.Request.Path,
        userId,
        roles,
        requiredRoles
    );

    await next();
});

app.Run();
