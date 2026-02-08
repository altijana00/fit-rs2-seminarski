using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace ZEN_YogaWebAPI.Migrations
{
    /// <inheritdoc />
    public partial class DataSeed : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "AppAnalytics",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: true),
                    TotalUsers = table.Column<int>(type: "int", nullable: true),
                    TotalStudios = table.Column<int>(type: "int", nullable: true),
                    MostPopularCity = table.Column<string>(type: "nvarchar(max)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AppAnalytics", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "Cities",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Name = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Cities", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "Notifications",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Title = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Content = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Type = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    IsRead = table.Column<bool>(type: "bit", nullable: false),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Notifications", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "Roles",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Name = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Description = table.Column<string>(type: "nvarchar(max)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Roles", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "SubscriptionTypes",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Name = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Description = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    DurationInDays = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_SubscriptionTypes", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "YogaTypes",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Name = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Description = table.Column<string>(type: "nvarchar(max)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_YogaTypes", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "Users",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    FirstName = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    LastName = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Gender = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    DateOfBirth = table.Column<DateTime>(type: "datetime2", nullable: true),
                    Email = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    PasswordHash = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    PasswordSalt = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    ProfileImageUrl = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    RoleId = table.Column<int>(type: "int", nullable: false),
                    CityId = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Users", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Users_Cities_CityId",
                        column: x => x.CityId,
                        principalTable: "Cities",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_Users_Roles_RoleId",
                        column: x => x.RoleId,
                        principalTable: "Roles",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "Studios",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    OwnerId = table.Column<int>(type: "int", nullable: false),
                    Name = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Description = table.Column<string>(type: "nvarchar(300)", maxLength: 300, nullable: true),
                    CityId = table.Column<int>(type: "int", nullable: false),
                    Address = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    ContactEmail = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    ContactPhone = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    ProfileImageUrl = table.Column<string>(type: "nvarchar(max)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Studios", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Studios_Cities_CityId",
                        column: x => x.CityId,
                        principalTable: "Cities",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_Studios_Users_OwnerId",
                        column: x => x.OwnerId,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "Instructors",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false),
                    Biography = table.Column<string>(type: "nvarchar(200)", maxLength: 200, nullable: true),
                    Diplomas = table.Column<string>(type: "nvarchar(200)", maxLength: 200, nullable: true),
                    Certificates = table.Column<string>(type: "nvarchar(200)", maxLength: 200, nullable: true),
                    StudioId = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Instructors", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Instructors_Studios_StudioId",
                        column: x => x.StudioId,
                        principalTable: "Studios",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_Instructors_Users_Id",
                        column: x => x.Id,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Paymments",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    UserId = table.Column<int>(type: "int", nullable: false),
                    StudioId = table.Column<int>(type: "int", nullable: false),
                    SubscriptionTypeId = table.Column<int>(type: "int", nullable: false),
                    PaymentDate = table.Column<DateTime>(type: "datetime2", nullable: false),
                    Amount = table.Column<decimal>(type: "decimal(18,2)", precision: 18, scale: 2, nullable: false),
                    Status = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Paymments", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Paymments_Studios_StudioId",
                        column: x => x.StudioId,
                        principalTable: "Studios",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_Paymments_SubscriptionTypes_SubscriptionTypeId",
                        column: x => x.SubscriptionTypeId,
                        principalTable: "SubscriptionTypes",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_Paymments_Users_UserId",
                        column: x => x.UserId,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "StudioAnalytics",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    StudioId = table.Column<int>(type: "int", nullable: false),
                    Month = table.Column<int>(type: "int", nullable: false),
                    Year = table.Column<int>(type: "int", nullable: false),
                    TotalRevenue = table.Column<decimal>(type: "decimal(18,2)", precision: 18, scale: 2, nullable: false),
                    TotalParticipants = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_StudioAnalytics", x => x.Id);
                    table.ForeignKey(
                        name: "FK_StudioAnalytics_Studios_StudioId",
                        column: x => x.StudioId,
                        principalTable: "Studios",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "StudioGalleries",
                columns: table => new
                {
                    GalleryId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    StudioId = table.Column<int>(type: "int", nullable: false),
                    PhotoUrl = table.Column<string>(type: "nvarchar(max)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_StudioGalleries", x => x.GalleryId);
                    table.ForeignKey(
                        name: "FK_StudioGalleries_Studios_StudioId",
                        column: x => x.StudioId,
                        principalTable: "Studios",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "UserStudio",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    UserId = table.Column<int>(type: "int", nullable: false),
                    StudioId = table.Column<int>(type: "int", nullable: false),
                    JoinedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                    SubscriptionStart = table.Column<DateTime>(type: "datetime2", nullable: false),
                    SubscriptionEnd = table.Column<DateTime>(type: "datetime2", nullable: false),
                    isActive = table.Column<bool>(type: "bit", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_UserStudio", x => x.Id);
                    table.ForeignKey(
                        name: "FK_UserStudio_Studios_StudioId",
                        column: x => x.StudioId,
                        principalTable: "Studios",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_UserStudio_Users_UserId",
                        column: x => x.UserId,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Classes",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    StudioId = table.Column<int>(type: "int", nullable: false),
                    InstructorId = table.Column<int>(type: "int", nullable: false),
                    YogaTypeId = table.Column<int>(type: "int", nullable: false),
                    Name = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    Description = table.Column<string>(type: "nvarchar(150)", maxLength: 150, nullable: true),
                    Location = table.Column<string>(type: "nvarchar(20)", maxLength: 20, nullable: true),
                    StartDate = table.Column<DateTime>(type: "datetime2", nullable: false),
                    EndDate = table.Column<DateTime>(type: "datetime2", nullable: false),
                    MaxParticipants = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Classes", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Classes_Instructors_InstructorId",
                        column: x => x.InstructorId,
                        principalTable: "Instructors",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_Classes_Studios_StudioId",
                        column: x => x.StudioId,
                        principalTable: "Studios",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_Classes_YogaTypes_YogaTypeId",
                        column: x => x.YogaTypeId,
                        principalTable: "YogaTypes",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "UserClasses",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    UserId = table.Column<int>(type: "int", nullable: false),
                    ClassId = table.Column<int>(type: "int", nullable: false),
                    JoinedAt = table.Column<DateTime>(type: "datetime2", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_UserClasses", x => x.Id);
                    table.ForeignKey(
                        name: "FK_UserClasses_Classes_ClassId",
                        column: x => x.ClassId,
                        principalTable: "Classes",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_UserClasses_Users_UserId",
                        column: x => x.UserId,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.InsertData(
                table: "Cities",
                columns: new[] { "Id", "Name" },
                values: new object[,]
                {
                    { 1, "Sarajevo" },
                    { 2, "Banja Luka" },
                    { 3, "Tuzla" },
                    { 4, "Zenica" },
                    { 5, "Mostar" },
                    { 6, "Bihać" },
                    { 7, "Brčko" },
                    { 8, "Prijedor" },
                    { 9, "Bijeljina" },
                    { 10, "Doboj" },
                    { 11, "Trebinje" },
                    { 12, "Goražde" },
                    { 13, "Travnik" },
                    { 14, "Gradačac" },
                    { 15, "Cazin" },
                    { 16, "Visoko" },
                    { 17, "Zvornik" },
                    { 18, "Bugojno" },
                    { 19, "Kakanj" },
                    { 20, "Konjic" },
                    { 21, "Sanski Most" },
                    { 22, "Lukavac" },
                    { 23, "Velika Kladuša" },
                    { 24, "Živinice" },
                    { 25, "Gradiška" },
                    { 26, "Široki Brijeg" },
                    { 27, "Čapljina" },
                    { 28, "Foča" },
                    { 29, "Modriča" },
                    { 30, "Neum" }
                });

            migrationBuilder.InsertData(
                table: "Roles",
                columns: new[] { "Id", "Description", "Name" },
                values: new object[,]
                {
                    { 1, "Administrator for the system", "Admin" },
                    { 2, "Owner of the yoga studio", "Owner" },
                    { 3, "Yoga instructor teaching the classes", "Instructor" },
                    { 4, "Studio members and class participants", "Participant" }
                });

            migrationBuilder.InsertData(
                table: "SubscriptionTypes",
                columns: new[] { "Id", "Description", "DurationInDays", "Name" },
                values: new object[,]
                {
                    { 1, "Access for 30 days.", 30, "1 Month" },
                    { 2, "Access for 90 days.", 90, "3 Months" },
                    { 3, "Access for 180 days.", 180, "6 Months" },
                    { 4, "Access for 365 days.", 365, "1 Year" }
                });

            migrationBuilder.InsertData(
                table: "YogaTypes",
                columns: new[] { "Id", "Description", "Name" },
                values: new object[,]
                {
                    { 1, "A gentle and slow-paced yoga practice focused on basic postures and breathing techniques, ideal for beginners.", "Hatha Yoga" },
                    { 2, "A dynamic and flowing style of yoga that synchronizes breath with movement, improving flexibility and strength.", "Vinyasa Yoga" },
                    { 3, "A meditative practice that targets deep connective tissues through long-held poses, promoting relaxation and flexibility.", "Yin Yoga" }
                });

            migrationBuilder.InsertData(
                table: "Users",
                columns: new[] { "Id", "CityId", "DateOfBirth", "Email", "FirstName", "Gender", "LastName", "PasswordHash", "PasswordSalt", "ProfileImageUrl", "RoleId" },
                values: new object[,]
                {
                    { 1, 1, new DateTime(1998, 6, 13, 0, 0, 0, 0, DateTimeKind.Unspecified), "owner@edu.fit.ba", "Aiden", "M", "Morris", "27uiVncQHDx6OR9bs51dPeF2+oxdqjhwTfcnWWVzBpU=", "cnMycnMyMTIz", "https://zenyoga.blob.core.windows.net/user-photos/AidenMorris.jpg", 2 },
                    { 2, 2, new DateTime(1995, 6, 3, 0, 0, 0, 0, DateTimeKind.Unspecified), "admin@edu.fit.ba", "Mia", "F", "Lopez", "27uiVncQHDx6OR9bs51dPeF2+oxdqjhwTfcnWWVzBpU=", "cnMycnMyMTIz", "https://zenyoga.blob.core.windows.net/user-photos/MiaLopez.jpg", 1 },
                    { 3, 3, new DateTime(1987, 4, 12, 0, 0, 0, 0, DateTimeKind.Unspecified), "liam.smith@email.com", "Liam", "M", "Smith", "dCFn8YloRhUe3E091YulKFTu1u5AyijVpbXoG0/AfiM=", "cnMycnMyMTIz", "https://zenyoga.blob.core.windows.net/user-photos/LiamSmith.jpg", 2 },
                    { 4, 4, new DateTime(1989, 9, 25, 0, 0, 0, 0, DateTimeKind.Unspecified), "lejla.kovacevic@email.com", "Lejla", "F", "Kovačević", "dCFn8YloRhUe3E091YulKFTu1u5AyijVpbXoG0/AfiM=", "cnMycnMyMTIz", "", 2 },
                    { 5, 5, new DateTime(1985, 1, 8, 0, 0, 0, 0, DateTimeKind.Unspecified), "noah.brown@email.com", "Noah", "M", "Brown", "dCFn8YloRhUe3E091YulKFTu1u5AyijVpbXoG0/AfiM=", "cnMycnMyMTIz", "https://zenyoga.blob.core.windows.net/user-photos/NoahBrown.jpg", 2 },
                    { 6, 6, new DateTime(1992, 3, 14, 0, 0, 0, 0, DateTimeKind.Unspecified), "instructor@edu.fit.ba", "Sophia", "F", "Davis", "27uiVncQHDx6OR9bs51dPeF2+oxdqjhwTfcnWWVzBpU=", "cnMycnMyMTIz", "https://zenyoga.blob.core.windows.net/user-photos/SophiaDavis.jpg", 3 },
                    { 7, 7, new DateTime(1990, 7, 19, 0, 0, 0, 0, DateTimeKind.Unspecified), "jackson.miller@email.com", "Jackson", "M", "Miller", "IZeDbcY+ysVlHxdE5EGsW0cNHJwxOM/6Wko92B90NNQ=", "cnMycnMyMTIz", "https://zenyoga.blob.core.windows.net/user-photos/JacksonMiller.jpg", 3 },
                    { 8, 8, new DateTime(1991, 11, 2, 0, 0, 0, 0, DateTimeKind.Unspecified), "amelia.garcia@email.com", "Amelia", "F", "Garcia", "IZeDbcY+ysVlHxdE5EGsW0cNHJwxOM/6Wko92B90NNQ=", "cnMycnMyMTIz", "https://zenyoga.blob.core.windows.net/user-photos/AmeliaGarcia.jpg", 3 },
                    { 9, 9, new DateTime(1998, 5, 5, 0, 0, 0, 0, DateTimeKind.Unspecified), "participant@edu.fit.ba", "James", "M", "Martinez", "27uiVncQHDx6OR9bs51dPeF2+oxdqjhwTfcnWWVzBpU=", "cnMycnMyMTIz", "https://zenyoga.blob.core.windows.net/user-photos/JamesMartinez.jpg", 4 },
                    { 10, 10, new DateTime(1997, 10, 17, 0, 0, 0, 0, DateTimeKind.Unspecified), "isabella.scott@email.com", "Isabella", "F", "Scott", "YnyxSFNb8Nq7/9u5Now3QZKMz6dPFPQb8jALPTubGXE=", "cnMycnMyMTIz", "https://zenyoga.blob.core.windows.net/user-photos/IsabellaScott.jpg", 4 },
                    { 11, 11, new DateTime(1996, 2, 28, 0, 0, 0, 0, DateTimeKind.Unspecified), "mason.walker@email.com", "Mason", "M", "Walker", "YnyxSFNb8Nq7/9u5Now3QZKMz6dPFPQb8jALPTubGXE=", "cnMycnMyMTIz", "https://zenyoga.blob.core.windows.net/user-photos/MasonWalker.jpg", 4 }
                });

            migrationBuilder.InsertData(
                table: "Studios",
                columns: new[] { "Id", "Address", "CityId", "ContactEmail", "ContactPhone", "Description", "Name", "OwnerId", "ProfileImageUrl" },
                values: new object[,]
                {
                    { 1, "123 Main St", 3, "contact@zenyoga.com", "1234567890", "Serene Flow Yoga is a tranquil oasis designed for relaxation, self-discovery, and holistic well-being.", "Serene Flow Yoga", 1, "https://zenyoga.blob.core.windows.net/studio-photos/Studio1ProfilePhoto.jpg" },
                    { 2, "456 Oak St", 3, "contact@lotusstudio.com", "2345678901", "Tranquil Lotus Yoga is a sanctuary for those seeking balance, flexibility, and inner harmony.", "Tranquil Lotus Yoga", 1, "https://zenyoga.blob.core.windows.net/studio-photos/Studio2ProfilePhoto.jpg" },
                    { 3, "789 Pine St", 9, "contact@harmonyyoga.com", "3456789012", "Harmony Yoga offers a variety of classes, from gentle restorative yoga to power flows, catering to busy city dwellers seeking balance.", "Harmony Yoga", 3, "https://zenyoga.blob.core.windows.net/studio-photos/Studio3ProfilePhoto.jpg" },
                    { 4, "101 Maple St", 6, "contact@sunriseyoga.com", "4567890123", "A peaceful yoga retreat overlooking the town's river, offering sunrise Vinyasa flows and meditation classes to start your day with positivity and energy.", "Sunrise Yoga Haven", 4, "https://zenyoga.blob.core.windows.net/studio-photos/Studio4ProfilePhoto.jpg" }
                });

            migrationBuilder.InsertData(
                table: "Instructors",
                columns: new[] { "Id", "Biography", "Certificates", "Diplomas", "StudioId" },
                values: new object[,]
                {
                    { 6, "Experienced yoga instructor specializing in Hatha and Vinyasa yoga. Passionate about helping students build strength and flexibility.", "Advanced Hatha Yoga Certification", "Certified Yoga Teacher (RYT 200)", 1 },
                    { 7, "Dedicated instructor with a background in Yin and Restorative yoga. Focuses on deep relaxation and mindfulness.", "Meditation & Breathwork Certification", "RYT 500 - Yoga Alliance", 3 },
                    { 8, "Energetic Vinyasa yoga teacher with experience in power yoga and flow sequences. Encourages a dynamic and engaging practice.", "Power Yoga Certification", "RYT 200", 2 }
                });

            migrationBuilder.InsertData(
                table: "Paymments",
                columns: new[] { "Id", "Amount", "CreatedAt", "PaymentDate", "Status", "StudioId", "SubscriptionTypeId", "UserId" },
                values: new object[,]
                {
                    { 1, 50m, new DateTime(2026, 1, 14, 10, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2026, 1, 14, 10, 0, 0, 0, DateTimeKind.Unspecified), "processing", 3, 1, 11 },
                    { 2, 50m, new DateTime(2026, 1, 14, 10, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2026, 1, 14, 10, 0, 0, 0, DateTimeKind.Unspecified), "processing", 3, 1, 9 },
                    { 3, 50m, new DateTime(2026, 1, 14, 10, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2026, 1, 14, 10, 0, 0, 0, DateTimeKind.Unspecified), "processing", 3, 1, 10 },
                    { 4, 50m, new DateTime(2026, 1, 14, 10, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2026, 1, 14, 10, 0, 0, 0, DateTimeKind.Unspecified), "processing", 2, 1, 10 }
                });

            migrationBuilder.InsertData(
                table: "StudioGalleries",
                columns: new[] { "GalleryId", "PhotoUrl", "StudioId" },
                values: new object[,]
                {
                    { 1, "https://zenyoga.blob.core.windows.net/studio-photos/Studio1Gallery1.jpg", 1 },
                    { 2, "https://zenyoga.blob.core.windows.net/studio-photos/Studio1Gallery2.jpg", 1 },
                    { 3, "https://zenyoga.blob.core.windows.net/studio-photos/Studio1Gallery3.jpg", 1 },
                    { 4, "https://zenyoga.blob.core.windows.net/studio-photos/Studio1Gallery4.jpg", 1 },
                    { 5, "https://zenyoga.blob.core.windows.net/studio-photos/Studio2Gallery1.jpg", 2 },
                    { 6, "https://zenyoga.blob.core.windows.net/studio-photos/Studio2Gallery2.jpg", 2 },
                    { 7, "https://zenyoga.blob.core.windows.net/studio-photos/Studio3Gallery1.jpg", 3 },
                    { 8, "https://zenyoga.blob.core.windows.net/studio-photos/Studio3Gallery2.jpg", 3 },
                    { 9, "https://zenyoga.blob.core.windows.net/studio-photos/Studio4Gallery1.jpg", 4 },
                    { 10, "https://zenyoga.blob.core.windows.net/studio-photos/Studio4Gallery2.jpg", 4 },
                    { 11, "https://zenyoga.blob.core.windows.net/studio-photos/Studio4Gallery3.jpg", 4 }
                });

            migrationBuilder.InsertData(
                table: "Classes",
                columns: new[] { "Id", "Description", "EndDate", "InstructorId", "Location", "MaxParticipants", "Name", "StartDate", "StudioId", "YogaTypeId" },
                values: new object[,]
                {
                    { 1, "", new DateTime(2026, 1, 20, 9, 0, 0, 0, DateTimeKind.Unspecified), 6, "Room 1", 20, "Morning Flow", new DateTime(2026, 1, 20, 8, 0, 0, 0, DateTimeKind.Unspecified), 1, 1 },
                    { 2, "", new DateTime(2026, 1, 20, 11, 0, 0, 0, DateTimeKind.Unspecified), 7, "Main Hall", 20, "Power Yoga", new DateTime(2026, 1, 20, 10, 0, 0, 0, DateTimeKind.Unspecified), 3, 2 },
                    { 3, "", new DateTime(2026, 1, 20, 19, 0, 0, 0, DateTimeKind.Unspecified), 7, "Room 2", 20, "Relaxing Yin", new DateTime(2026, 1, 20, 18, 0, 0, 0, DateTimeKind.Unspecified), 3, 3 },
                    { 4, "", new DateTime(2026, 1, 21, 8, 0, 0, 0, DateTimeKind.Unspecified), 8, "Room 1", 20, "Evening Flow", new DateTime(2026, 1, 21, 7, 0, 0, 0, DateTimeKind.Unspecified), 2, 1 },
                    { 5, "", new DateTime(2026, 1, 21, 10, 30, 0, 0, DateTimeKind.Unspecified), 8, "Main Hall", 20, "Core Strength", new DateTime(2026, 1, 21, 9, 30, 0, 0, DateTimeKind.Unspecified), 2, 2 },
                    { 6, "", new DateTime(2026, 1, 21, 19, 30, 0, 0, DateTimeKind.Unspecified), 7, "Room 2", 20, "Gentle Flow", new DateTime(2026, 1, 21, 18, 30, 0, 0, DateTimeKind.Unspecified), 1, 3 },
                    { 7, "", new DateTime(2026, 1, 22, 9, 0, 0, 0, DateTimeKind.Unspecified), 7, "Room 1", 20, "Dynamic Yoga", new DateTime(2026, 1, 22, 8, 0, 0, 0, DateTimeKind.Unspecified), 3, 1 }
                });

            migrationBuilder.InsertData(
                table: "UserClasses",
                columns: new[] { "Id", "ClassId", "JoinedAt", "UserId" },
                values: new object[,]
                {
                    { 1, 2, new DateTime(2026, 1, 14, 10, 0, 0, 0, DateTimeKind.Unspecified), 9 },
                    { 2, 3, new DateTime(2026, 1, 14, 10, 0, 0, 0, DateTimeKind.Unspecified), 10 },
                    { 3, 4, new DateTime(2026, 1, 14, 10, 0, 0, 0, DateTimeKind.Unspecified), 10 },
                    { 4, 3, new DateTime(2026, 1, 14, 10, 0, 0, 0, DateTimeKind.Unspecified), 11 },
                    { 5, 7, new DateTime(2026, 1, 14, 10, 0, 0, 0, DateTimeKind.Unspecified), 11 }
                });

            migrationBuilder.CreateIndex(
                name: "IX_Classes_InstructorId",
                table: "Classes",
                column: "InstructorId");

            migrationBuilder.CreateIndex(
                name: "IX_Classes_StudioId",
                table: "Classes",
                column: "StudioId");

            migrationBuilder.CreateIndex(
                name: "IX_Classes_YogaTypeId",
                table: "Classes",
                column: "YogaTypeId");

            migrationBuilder.CreateIndex(
                name: "IX_Instructors_StudioId",
                table: "Instructors",
                column: "StudioId");

            migrationBuilder.CreateIndex(
                name: "IX_Paymments_StudioId",
                table: "Paymments",
                column: "StudioId");

            migrationBuilder.CreateIndex(
                name: "IX_Paymments_SubscriptionTypeId",
                table: "Paymments",
                column: "SubscriptionTypeId");

            migrationBuilder.CreateIndex(
                name: "IX_Paymments_UserId",
                table: "Paymments",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_StudioAnalytics_StudioId",
                table: "StudioAnalytics",
                column: "StudioId");

            migrationBuilder.CreateIndex(
                name: "IX_StudioGalleries_StudioId",
                table: "StudioGalleries",
                column: "StudioId");

            migrationBuilder.CreateIndex(
                name: "IX_Studios_CityId",
                table: "Studios",
                column: "CityId");

            migrationBuilder.CreateIndex(
                name: "IX_Studios_OwnerId",
                table: "Studios",
                column: "OwnerId");

            migrationBuilder.CreateIndex(
                name: "IX_UserClasses_ClassId",
                table: "UserClasses",
                column: "ClassId");

            migrationBuilder.CreateIndex(
                name: "IX_UserClasses_UserId",
                table: "UserClasses",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_Users_CityId",
                table: "Users",
                column: "CityId");

            migrationBuilder.CreateIndex(
                name: "IX_Users_RoleId",
                table: "Users",
                column: "RoleId");

            migrationBuilder.CreateIndex(
                name: "IX_UserStudio_StudioId",
                table: "UserStudio",
                column: "StudioId");

            migrationBuilder.CreateIndex(
                name: "IX_UserStudio_UserId",
                table: "UserStudio",
                column: "UserId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "AppAnalytics");

            migrationBuilder.DropTable(
                name: "Notifications");

            migrationBuilder.DropTable(
                name: "Paymments");

            migrationBuilder.DropTable(
                name: "StudioAnalytics");

            migrationBuilder.DropTable(
                name: "StudioGalleries");

            migrationBuilder.DropTable(
                name: "UserClasses");

            migrationBuilder.DropTable(
                name: "UserStudio");

            migrationBuilder.DropTable(
                name: "SubscriptionTypes");

            migrationBuilder.DropTable(
                name: "Classes");

            migrationBuilder.DropTable(
                name: "Instructors");

            migrationBuilder.DropTable(
                name: "YogaTypes");

            migrationBuilder.DropTable(
                name: "Studios");

            migrationBuilder.DropTable(
                name: "Users");

            migrationBuilder.DropTable(
                name: "Cities");

            migrationBuilder.DropTable(
                name: "Roles");
        }
    }
}
