using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace ZEN_YogaWebAPI.Migrations
{
    /// <inheritdoc />
    public partial class ExtendedInitial : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.UpdateData(
                table: "Instructors",
                keyColumn: "Id",
                keyValue: 6,
                columns: new[] { "Biography", "Certificates", "Diplomas" },
                values: new object[] { "Experienced yoga instructor specializing in Hatha and Vinyasa yoga. Passionate about helping students build strength and flexibility.", "Advanced Hatha Yoga Certification", "Certified Yoga Teacher (RYT 200)" });

            migrationBuilder.UpdateData(
                table: "Instructors",
                keyColumn: "Id",
                keyValue: 7,
                columns: new[] { "Biography", "Certificates", "Diplomas" },
                values: new object[] { "Dedicated instructor with a background in Yin and Restorative yoga. Focuses on deep relaxation and mindfulness.", "Meditation & Breathwork Certification", "RYT 500 - Yoga Alliance" });

            migrationBuilder.UpdateData(
                table: "Instructors",
                keyColumn: "Id",
                keyValue: 8,
                columns: new[] { "Biography", "Certificates", "Diplomas" },
                values: new object[] { "Energetic Vinyasa yoga teacher with experience in power yoga and flow sequences. Encourages a dynamic and engaging practice.", "Power Yoga Certification", "RYT 200" });

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

            migrationBuilder.UpdateData(
                table: "Studios",
                keyColumn: "Id",
                keyValue: 1,
                columns: new[] { "ContactPhone", "Description", "Name", "ProfileImageUrl" },
                values: new object[] { "1234567890", "Serene Flow Yoga is a tranquil oasis designed for relaxation, self-discovery, and holistic well-being.", "Serene Flow Yoga", "https://zenyoga.blob.core.windows.net/studio-photos/Studio1ProfilePhoto.jpg" });

            migrationBuilder.UpdateData(
                table: "Studios",
                keyColumn: "Id",
                keyValue: 2,
                columns: new[] { "CityId", "ContactPhone", "Description", "Name", "ProfileImageUrl" },
                values: new object[] { 3, "2345678901", "Tranquil Lotus Yoga is a sanctuary for those seeking balance, flexibility, and inner harmony.", "Tranquil Lotus Yoga", "https://zenyoga.blob.core.windows.net/studio-photos/Studio2ProfilePhoto.jpg" });

            migrationBuilder.UpdateData(
                table: "Studios",
                keyColumn: "Id",
                keyValue: 3,
                columns: new[] { "ContactPhone", "Description", "ProfileImageUrl" },
                values: new object[] { "3456789012", "Harmony Yoga offers a variety of classes, from gentle restorative yoga to power flows, catering to busy city dwellers seeking balance.", "https://zenyoga.blob.core.windows.net/studio-photos/Studio3ProfilePhoto.jpg" });

            migrationBuilder.UpdateData(
                table: "Studios",
                keyColumn: "Id",
                keyValue: 4,
                columns: new[] { "ContactPhone", "Description", "Name", "ProfileImageUrl" },
                values: new object[] { "4567890123", "A peaceful yoga retreat overlooking the town's river, offering sunrise Vinyasa flows and meditation classes to start your day with positivity and energy.", "Sunrise Yoga Haven", "https://zenyoga.blob.core.windows.net/studio-photos/Studio4ProfilePhoto.jpg" });

            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "Id",
                keyValue: 1,
                columns: new[] { "FirstName", "LastName", "ProfileImageUrl" },
                values: new object[] { "Aiden", "Morris", "https://zenyoga.blob.core.windows.net/user-photos/AidenMorris.jpg" });

            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "Id",
                keyValue: 2,
                columns: new[] { "FirstName", "LastName", "ProfileImageUrl" },
                values: new object[] { "Mia", "Lopez", "https://zenyoga.blob.core.windows.net/user-photos/MiaLopez.jpg" });

            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "Id",
                keyValue: 3,
                columns: new[] { "Email", "FirstName", "LastName", "ProfileImageUrl" },
                values: new object[] { "liam.smith@email.com", "Liam", "Smith", "https://zenyoga.blob.core.windows.net/user-photos/LiamSmith.jpg" });

            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "Id",
                keyValue: 5,
                columns: new[] { "Email", "FirstName", "LastName", "ProfileImageUrl" },
                values: new object[] { "noah.brown@email.com", "Noah", "Brown", "https://zenyoga.blob.core.windows.net/user-photos/NoahBrown.jpg" });

            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "Id",
                keyValue: 6,
                columns: new[] { "FirstName", "LastName", "ProfileImageUrl" },
                values: new object[] { "Sophia", "Davis", "https://zenyoga.blob.core.windows.net/user-photos/SophiaDavis.jpg" });

            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "Id",
                keyValue: 7,
                columns: new[] { "Email", "FirstName", "LastName", "ProfileImageUrl" },
                values: new object[] { "jackson.miller@email.com", "Jackson", "Miller", "https://zenyoga.blob.core.windows.net/user-photos/JacksonMiller.jpg" });

            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "Id",
                keyValue: 8,
                columns: new[] { "Email", "FirstName", "LastName", "ProfileImageUrl" },
                values: new object[] { "amelia.garcia@email.com", "Amelia", "Garcia", "https://zenyoga.blob.core.windows.net/user-photos/AmeliaGarcia.jpg" });

            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "Id",
                keyValue: 9,
                columns: new[] { "FirstName", "LastName", "ProfileImageUrl" },
                values: new object[] { "James", "Martinez", "https://zenyoga.blob.core.windows.net/user-photos/JamesMartinez.jpg" });

            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "Id",
                keyValue: 10,
                columns: new[] { "Email", "FirstName", "LastName", "ProfileImageUrl" },
                values: new object[] { "isabella.scott@email.com", "Isabella", "Scott", "https://zenyoga.blob.core.windows.net/user-photos/IsabellaScott.jpg" });

            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "Id",
                keyValue: 11,
                columns: new[] { "Email", "FirstName", "LastName", "ProfileImageUrl" },
                values: new object[] { "mason.walker@email.com", "Mason", "Walker", "https://zenyoga.blob.core.windows.net/user-photos/MasonWalker.jpg" });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DeleteData(
                table: "StudioGalleries",
                keyColumn: "GalleryId",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "StudioGalleries",
                keyColumn: "GalleryId",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "StudioGalleries",
                keyColumn: "GalleryId",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "StudioGalleries",
                keyColumn: "GalleryId",
                keyValue: 4);

            migrationBuilder.DeleteData(
                table: "StudioGalleries",
                keyColumn: "GalleryId",
                keyValue: 5);

            migrationBuilder.DeleteData(
                table: "StudioGalleries",
                keyColumn: "GalleryId",
                keyValue: 6);

            migrationBuilder.DeleteData(
                table: "StudioGalleries",
                keyColumn: "GalleryId",
                keyValue: 7);

            migrationBuilder.DeleteData(
                table: "StudioGalleries",
                keyColumn: "GalleryId",
                keyValue: 8);

            migrationBuilder.DeleteData(
                table: "StudioGalleries",
                keyColumn: "GalleryId",
                keyValue: 9);

            migrationBuilder.DeleteData(
                table: "StudioGalleries",
                keyColumn: "GalleryId",
                keyValue: 10);

            migrationBuilder.DeleteData(
                table: "StudioGalleries",
                keyColumn: "GalleryId",
                keyValue: 11);

            migrationBuilder.UpdateData(
                table: "Instructors",
                keyColumn: "Id",
                keyValue: 6,
                columns: new[] { "Biography", "Certificates", "Diplomas" },
                values: new object[] { "", "", "" });

            migrationBuilder.UpdateData(
                table: "Instructors",
                keyColumn: "Id",
                keyValue: 7,
                columns: new[] { "Biography", "Certificates", "Diplomas" },
                values: new object[] { "", "", "" });

            migrationBuilder.UpdateData(
                table: "Instructors",
                keyColumn: "Id",
                keyValue: 8,
                columns: new[] { "Biography", "Certificates", "Diplomas" },
                values: new object[] { "", "", "" });

            migrationBuilder.UpdateData(
                table: "Studios",
                keyColumn: "Id",
                keyValue: 1,
                columns: new[] { "ContactPhone", "Description", "Name", "ProfileImageUrl" },
                values: new object[] { "123-456-7890", "Peaceful yoga studio", "Zen Yoga Center", "" });

            migrationBuilder.UpdateData(
                table: "Studios",
                keyColumn: "Id",
                keyValue: 2,
                columns: new[] { "CityId", "ContactPhone", "Description", "Name", "ProfileImageUrl" },
                values: new object[] { 4, "234-567-8901", "Modern yoga classes", "Lotus Studio", "" });

            migrationBuilder.UpdateData(
                table: "Studios",
                keyColumn: "Id",
                keyValue: 3,
                columns: new[] { "ContactPhone", "Description", "ProfileImageUrl" },
                values: new object[] { "345-678-9012", "Yoga for all levels", "" });

            migrationBuilder.UpdateData(
                table: "Studios",
                keyColumn: "Id",
                keyValue: 4,
                columns: new[] { "ContactPhone", "Description", "Name", "ProfileImageUrl" },
                values: new object[] { "456-789-0123", "Morning yoga and meditation", "Sunrise Yoga", "" });

            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "Id",
                keyValue: 1,
                columns: new[] { "FirstName", "LastName", "ProfileImageUrl" },
                values: new object[] { "Test1", "", "" });

            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "Id",
                keyValue: 2,
                columns: new[] { "FirstName", "LastName", "ProfileImageUrl" },
                values: new object[] { "Test2", "", "" });

            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "Id",
                keyValue: 3,
                columns: new[] { "Email", "FirstName", "LastName", "ProfileImageUrl" },
                values: new object[] { "amir.hodzic@email.com", "Amir", "Hodžić", "" });

            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "Id",
                keyValue: 5,
                columns: new[] { "Email", "FirstName", "LastName", "ProfileImageUrl" },
                values: new object[] { "nermin.hadzic@email.com", "Nermin", "Hadžić", "" });

            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "Id",
                keyValue: 6,
                columns: new[] { "FirstName", "LastName", "ProfileImageUrl" },
                values: new object[] { "Amina", "Mehmedović", "" });

            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "Id",
                keyValue: 7,
                columns: new[] { "Email", "FirstName", "LastName", "ProfileImageUrl" },
                values: new object[] { "haris.begic@email.com", "Haris", "Begić", "" });

            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "Id",
                keyValue: 8,
                columns: new[] { "Email", "FirstName", "LastName", "ProfileImageUrl" },
                values: new object[] { "selma.delic@email.com", "Selma", "Delić", "" });

            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "Id",
                keyValue: 9,
                columns: new[] { "FirstName", "LastName", "ProfileImageUrl" },
                values: new object[] { "Kenan", "Musić", "" });

            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "Id",
                keyValue: 10,
                columns: new[] { "Email", "FirstName", "LastName", "ProfileImageUrl" },
                values: new object[] { "marija.petrovic@email.com", "Marija", "Petrović", "" });

            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "Id",
                keyValue: 11,
                columns: new[] { "Email", "FirstName", "LastName", "ProfileImageUrl" },
                values: new object[] { "adnan.karic@email.com", "Adnan", "Karić", "" });
        }
    }
}
