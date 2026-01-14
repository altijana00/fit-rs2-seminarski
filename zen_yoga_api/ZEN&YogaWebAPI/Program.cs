using AutoMapper;
using FirebaseAdmin;
using Google.Apis.Auth.OAuth2;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.IdentityModel.Tokens;
using Microsoft.OpenApi.Models;
using System.Text;
using System.Text.Json;
using ZEN_Yoga.Models;
using ZEN_Yoga.Models.Requests;
using ZEN_Yoga.Services.Configurations;
using ZEN_Yoga.Services.Interfaces.Analytics;
using ZEN_Yoga.Services.Interfaces.Base;
using ZEN_Yoga.Services.Interfaces.BlobStorage;
using ZEN_Yoga.Services.Interfaces.City;
using ZEN_Yoga.Services.Interfaces.Class;
using ZEN_Yoga.Services.Interfaces.Instructor;
using ZEN_Yoga.Services.Interfaces.Notification;
using ZEN_Yoga.Services.Interfaces.Payment;
using ZEN_Yoga.Services.Interfaces.Role;
using ZEN_Yoga.Services.Interfaces.Studio;
using ZEN_Yoga.Services.Interfaces.StudioSubscription;
using ZEN_Yoga.Services.Interfaces.SubscriptionType;
using ZEN_Yoga.Services.Interfaces.User;
using ZEN_Yoga.Services.Interfaces.UserClass;
using ZEN_Yoga.Services.Interfaces.UserStudio;
using ZEN_Yoga.Services.Interfaces.YogaType;
using ZEN_Yoga.Services.Services.Analytics;
using ZEN_Yoga.Services.Services.BlobStorage;
using ZEN_Yoga.Services.Services.City;
using ZEN_Yoga.Services.Services.Class;
using ZEN_Yoga.Services.Services.Instructor;
using ZEN_Yoga.Services.Services.Notification;
using ZEN_Yoga.Services.Services.Payment;
using ZEN_Yoga.Services.Services.Role;
using ZEN_Yoga.Services.Services.Studio;
using ZEN_Yoga.Services.Services.StudioSubscription;
using ZEN_Yoga.Services.Services.SubscriptionType;
using ZEN_Yoga.Services.Services.User;
using ZEN_Yoga.Services.Services.UserClass;
using ZEN_Yoga.Services.Services.UserStudio;
using ZEN_Yoga.Services.Services.YogaType;
using ZEN_YogaWebAPI.Mapper;
using ZEN_YogaWebAPI.Middleware;
using static System.Net.WebRequestMethods;

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


builder.Services.AddScoped<IBlobStorageService, BlobStorageService>();


//Base

//User
builder.Services.AddScoped<IGetUserService, GetUserService>();
builder.Services.AddScoped<IUpsertUserService<RegisterUser>, UpsertUserService>();
builder.Services.AddScoped<IDeleteUserService, DeleteUserService>();
builder.Services.AddScoped<IUserValidatorService, UserValidatorService>();

//City
builder.Services.AddScoped<IGetCityService, GetCityService>();
builder.Services.AddScoped<ICityValidatorService, CityValidatorService>();

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

//Studio
builder.Services.AddScoped<IGetStudioService, GetStudioService>();
builder.Services.AddScoped<IUpsertStudioService<AddStudio>, UpsertStudioService>();
builder.Services.AddScoped<IDeleteStudioService, DeleteStudioService>();
builder.Services.AddScoped<IStudioValidatorService, StudioValidatorService>();
builder.Services.AddScoped<IUploadStudioPhotoService, UploadStudioPhotoService>();
builder.Services.AddScoped<IUploadStudioGalleryService, UploadStudioGalleryService>();
builder.Services.AddScoped<IGetStudioGalleryService, GetStudioGalleryService>();
builder.Services.AddScoped<IDeleteStudioGalleryPhotoService, DeleteStudioGalleryPhotoService>();



//StudioSubscription
builder.Services.AddScoped<IGetStudioSubscriptionService, GetStudioSubscriptionService>();
builder.Services.AddScoped<IUpsertStudioSubscriptionService<AddStudioSubscription>, UpsertStudioSubscriptionService>();
builder.Services.AddScoped<IDeleteStudioSubscriptionService, DeleteStudioSubscription>();

//UserClass
builder.Services.AddScoped<IGetUserClassService, GetUserClassService>();
builder.Services.AddScoped<IUpsertUserClassService, UpsertUserClassService>();
builder.Services.AddScoped<IDeleteUserClassService, DeleteUserClassService>();

//SubscriptionType
builder.Services.AddScoped<IGetSubscriptionTypeService, GetSubscriptionTypeService>();
builder.Services.AddScoped<ISubscriptionTypeValidatorService, SubscriptionTypeValidatorService>();

//UserStudio
builder.Services.AddScoped<IUpsertUserStudioService, UpsertUserStudioService>();


//YogaType
builder.Services.AddScoped<IGetYogaTypeService, GetYogaTypeService>();
builder.Services.AddScoped<IYogaTypeValidatorService, YogaTypeValidatorService>();


builder.Services.AddScoped<IAppAnalyticsService, AppAnalyticsService>();
builder.Services.AddScoped<INotificationService, NotificationService>();
builder.Services.AddScoped<IPaymentService, PaymentService>();
builder.Services.AddScoped<IStudioAnalyticsService, StudioAnalyticsService>();





builder.Services.AddAutoMapper(typeof(MapperProfile));

builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
    .AddJwtBearer(options =>
    {
        options.TokenValidationParameters = new TokenValidationParameters
        {
            ValidateIssuer = true,
            ValidateAudience = true,
            ValidateLifetime = true,
            ValidateIssuerSigningKey = true,
            ValidIssuer = "myIssuer",
            ValidAudience = "myAudience",
            IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes("superSecretKey123457890555555gzfizu6"))
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



var app = builder.Build();

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

app.Run();
