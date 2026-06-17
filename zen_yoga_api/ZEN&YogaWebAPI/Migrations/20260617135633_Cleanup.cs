using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace ZEN_YogaWebAPI.Migrations
{
    /// <inheritdoc />
    public partial class Cleanup : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "Month",
                table: "StudioAnalytics");

            migrationBuilder.DropColumn(
                name: "TotalParticipants",
                table: "StudioAnalytics");

            migrationBuilder.DropColumn(
                name: "Year",
                table: "StudioAnalytics");

            migrationBuilder.DropColumn(
                name: "MostPopularCity",
                table: "AppAnalytics");

            migrationBuilder.UpdateData(
                table: "Classes",
                keyColumn: "Id",
                keyValue: 1,
                columns: new[] { "EndDate", "StartDate" },
                values: new object[] { new DateTime(2026, 6, 20, 9, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2026, 6, 20, 8, 0, 0, 0, DateTimeKind.Unspecified) });

            migrationBuilder.UpdateData(
                table: "Classes",
                keyColumn: "Id",
                keyValue: 2,
                columns: new[] { "EndDate", "StartDate" },
                values: new object[] { new DateTime(2026, 7, 20, 11, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2026, 7, 20, 10, 0, 0, 0, DateTimeKind.Unspecified) });

            migrationBuilder.UpdateData(
                table: "Classes",
                keyColumn: "Id",
                keyValue: 3,
                columns: new[] { "EndDate", "StartDate" },
                values: new object[] { new DateTime(2026, 6, 25, 19, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2026, 6, 25, 18, 0, 0, 0, DateTimeKind.Unspecified) });

            migrationBuilder.UpdateData(
                table: "Classes",
                keyColumn: "Id",
                keyValue: 4,
                columns: new[] { "EndDate", "StartDate" },
                values: new object[] { new DateTime(2026, 7, 21, 8, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2026, 7, 21, 7, 0, 0, 0, DateTimeKind.Unspecified) });

            migrationBuilder.UpdateData(
                table: "Classes",
                keyColumn: "Id",
                keyValue: 5,
                columns: new[] { "EndDate", "StartDate" },
                values: new object[] { new DateTime(2026, 7, 11, 10, 30, 0, 0, DateTimeKind.Unspecified), new DateTime(2026, 7, 11, 9, 30, 0, 0, DateTimeKind.Unspecified) });

            migrationBuilder.UpdateData(
                table: "Classes",
                keyColumn: "Id",
                keyValue: 6,
                columns: new[] { "EndDate", "StartDate" },
                values: new object[] { new DateTime(2026, 6, 29, 19, 30, 0, 0, DateTimeKind.Unspecified), new DateTime(2026, 6, 29, 18, 30, 0, 0, DateTimeKind.Unspecified) });

            migrationBuilder.UpdateData(
                table: "Classes",
                keyColumn: "Id",
                keyValue: 7,
                columns: new[] { "EndDate", "StartDate" },
                values: new object[] { new DateTime(2026, 7, 2, 9, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2026, 7, 2, 8, 0, 0, 0, DateTimeKind.Unspecified) });

            migrationBuilder.UpdateData(
                table: "Paymments",
                keyColumn: "Id",
                keyValue: 1,
                column: "Status",
                value: "Succeeded");

            migrationBuilder.UpdateData(
                table: "Paymments",
                keyColumn: "Id",
                keyValue: 2,
                column: "Status",
                value: "Succeeded");

            migrationBuilder.UpdateData(
                table: "Paymments",
                keyColumn: "Id",
                keyValue: 3,
                column: "Status",
                value: "Succeeded");

            migrationBuilder.UpdateData(
                table: "Paymments",
                keyColumn: "Id",
                keyValue: 4,
                column: "Status",
                value: "Succeeded");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<int>(
                name: "Month",
                table: "StudioAnalytics",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<int>(
                name: "TotalParticipants",
                table: "StudioAnalytics",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<int>(
                name: "Year",
                table: "StudioAnalytics",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<string>(
                name: "MostPopularCity",
                table: "AppAnalytics",
                type: "nvarchar(max)",
                nullable: true);

            migrationBuilder.UpdateData(
                table: "Classes",
                keyColumn: "Id",
                keyValue: 1,
                columns: new[] { "EndDate", "StartDate" },
                values: new object[] { new DateTime(2026, 2, 20, 9, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2026, 2, 20, 8, 0, 0, 0, DateTimeKind.Unspecified) });

            migrationBuilder.UpdateData(
                table: "Classes",
                keyColumn: "Id",
                keyValue: 2,
                columns: new[] { "EndDate", "StartDate" },
                values: new object[] { new DateTime(2026, 2, 20, 11, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2026, 2, 20, 10, 0, 0, 0, DateTimeKind.Unspecified) });

            migrationBuilder.UpdateData(
                table: "Classes",
                keyColumn: "Id",
                keyValue: 3,
                columns: new[] { "EndDate", "StartDate" },
                values: new object[] { new DateTime(2026, 2, 20, 19, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2026, 2, 20, 18, 0, 0, 0, DateTimeKind.Unspecified) });

            migrationBuilder.UpdateData(
                table: "Classes",
                keyColumn: "Id",
                keyValue: 4,
                columns: new[] { "EndDate", "StartDate" },
                values: new object[] { new DateTime(2026, 2, 21, 8, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2026, 2, 21, 7, 0, 0, 0, DateTimeKind.Unspecified) });

            migrationBuilder.UpdateData(
                table: "Classes",
                keyColumn: "Id",
                keyValue: 5,
                columns: new[] { "EndDate", "StartDate" },
                values: new object[] { new DateTime(2026, 2, 21, 10, 30, 0, 0, DateTimeKind.Unspecified), new DateTime(2026, 2, 21, 9, 30, 0, 0, DateTimeKind.Unspecified) });

            migrationBuilder.UpdateData(
                table: "Classes",
                keyColumn: "Id",
                keyValue: 6,
                columns: new[] { "EndDate", "StartDate" },
                values: new object[] { new DateTime(2026, 2, 21, 19, 30, 0, 0, DateTimeKind.Unspecified), new DateTime(2026, 2, 21, 18, 30, 0, 0, DateTimeKind.Unspecified) });

            migrationBuilder.UpdateData(
                table: "Classes",
                keyColumn: "Id",
                keyValue: 7,
                columns: new[] { "EndDate", "StartDate" },
                values: new object[] { new DateTime(2026, 2, 22, 9, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2026, 2, 22, 8, 0, 0, 0, DateTimeKind.Unspecified) });

            migrationBuilder.UpdateData(
                table: "Paymments",
                keyColumn: "Id",
                keyValue: 1,
                column: "Status",
                value: "processing");

            migrationBuilder.UpdateData(
                table: "Paymments",
                keyColumn: "Id",
                keyValue: 2,
                column: "Status",
                value: "processing");

            migrationBuilder.UpdateData(
                table: "Paymments",
                keyColumn: "Id",
                keyValue: 3,
                column: "Status",
                value: "processing");

            migrationBuilder.UpdateData(
                table: "Paymments",
                keyColumn: "Id",
                keyValue: 4,
                column: "Status",
                value: "processing");
        }
    }
}
