using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace ZEN_YogaWebAPI.Migrations
{
    /// <inheritdoc />
    public partial class CleaningUpUnusedModels : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Paymments_SubscriptionTypes_SubscriptionTypeId",
                table: "Paymments");

            migrationBuilder.DropTable(
                name: "SubscriptionTypes");

            migrationBuilder.DropTable(
                name: "UserStudio");

            migrationBuilder.DropIndex(
                name: "IX_Paymments_SubscriptionTypeId",
                table: "Paymments");

            migrationBuilder.DropColumn(
                name: "SubscriptionTypeId",
                table: "Paymments");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<int>(
                name: "SubscriptionTypeId",
                table: "Paymments",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.CreateTable(
                name: "SubscriptionTypes",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Description = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    DurationInDays = table.Column<int>(type: "int", nullable: false),
                    Name = table.Column<string>(type: "nvarchar(max)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_SubscriptionTypes", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "UserStudio",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    StudioId = table.Column<int>(type: "int", nullable: false),
                    UserId = table.Column<int>(type: "int", nullable: false),
                    JoinedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                    SubscriptionEnd = table.Column<DateTime>(type: "datetime2", nullable: false),
                    SubscriptionStart = table.Column<DateTime>(type: "datetime2", nullable: false),
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

            migrationBuilder.UpdateData(
                table: "Paymments",
                keyColumn: "Id",
                keyValue: 1,
                column: "SubscriptionTypeId",
                value: 1);

            migrationBuilder.UpdateData(
                table: "Paymments",
                keyColumn: "Id",
                keyValue: 2,
                column: "SubscriptionTypeId",
                value: 1);

            migrationBuilder.UpdateData(
                table: "Paymments",
                keyColumn: "Id",
                keyValue: 3,
                column: "SubscriptionTypeId",
                value: 1);

            migrationBuilder.UpdateData(
                table: "Paymments",
                keyColumn: "Id",
                keyValue: 4,
                column: "SubscriptionTypeId",
                value: 1);

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

            migrationBuilder.CreateIndex(
                name: "IX_Paymments_SubscriptionTypeId",
                table: "Paymments",
                column: "SubscriptionTypeId");

            migrationBuilder.CreateIndex(
                name: "IX_UserStudio_StudioId",
                table: "UserStudio",
                column: "StudioId");

            migrationBuilder.CreateIndex(
                name: "IX_UserStudio_UserId",
                table: "UserStudio",
                column: "UserId");

            migrationBuilder.AddForeignKey(
                name: "FK_Paymments_SubscriptionTypes_SubscriptionTypeId",
                table: "Paymments",
                column: "SubscriptionTypeId",
                principalTable: "SubscriptionTypes",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);
        }
    }
}
