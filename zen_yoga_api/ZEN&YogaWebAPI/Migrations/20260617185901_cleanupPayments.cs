using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace ZEN_YogaWebAPI.Migrations
{
    /// <inheritdoc />
    public partial class cleanupPayments : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DeleteData(
                table: "Paymments",
                keyColumn: "Id",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "Paymments",
                keyColumn: "Id",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "Paymments",
                keyColumn: "Id",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "Paymments",
                keyColumn: "Id",
                keyValue: 4);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.InsertData(
                table: "Paymments",
                columns: new[] { "Id", "Amount", "CreatedAt", "PaymentDate", "PaymentIntentId", "Status", "StudioId", "UserId" },
                values: new object[,]
                {
                    { 1, 50m, new DateTime(2026, 1, 14, 10, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2026, 1, 14, 10, 0, 0, 0, DateTimeKind.Unspecified), "pi_1", "Succeeded", 3, 11 },
                    { 2, 50m, new DateTime(2026, 1, 14, 10, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2026, 1, 14, 10, 0, 0, 0, DateTimeKind.Unspecified), "pi_2", "Succeeded", 3, 9 },
                    { 3, 50m, new DateTime(2026, 1, 14, 10, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2026, 1, 14, 10, 0, 0, 0, DateTimeKind.Unspecified), "pi_3", "Succeeded", 3, 10 },
                    { 4, 50m, new DateTime(2026, 1, 14, 10, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2026, 1, 14, 10, 0, 0, 0, DateTimeKind.Unspecified), "pi_4", "Succeeded", 2, 10 }
                });
        }
    }
}
