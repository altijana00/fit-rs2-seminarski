using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace ZEN_YogaWebAPI.Migrations
{
    /// <inheritdoc />
    public partial class AfterReviewUpdate : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Paymments_Studios_StudioId",
                table: "Paymments");

            migrationBuilder.DropForeignKey(
                name: "FK_Paymments_Users_UserId",
                table: "Paymments");

            migrationBuilder.DropIndex(
                name: "IX_UserClasses_UserId",
                table: "UserClasses");

            migrationBuilder.DropPrimaryKey(
                name: "PK_Paymments",
                table: "Paymments");

            migrationBuilder.RenameTable(
                name: "Paymments",
                newName: "Payments");

            migrationBuilder.RenameIndex(
                name: "IX_Paymments_UserId",
                table: "Payments",
                newName: "IX_Payments_UserId");

            migrationBuilder.RenameIndex(
                name: "IX_Paymments_StudioId",
                table: "Payments",
                newName: "IX_Payments_StudioId");

            migrationBuilder.AddColumn<DateTime>(
                name: "CancelledAt",
                table: "UserClasses",
                type: "datetime2",
                nullable: true);

            migrationBuilder.AddColumn<int>(
                name: "CancelledByUserId",
                table: "UserClasses",
                type: "int",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "Status",
                table: "UserClasses",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddPrimaryKey(
                name: "PK_Payments",
                table: "Payments",
                column: "Id");

            migrationBuilder.UpdateData(
                table: "UserClasses",
                keyColumn: "Id",
                keyValue: 1,
                columns: new[] { "CancelledAt", "CancelledByUserId", "JoinedAt", "Status" },
                values: new object[] { null, null, new DateTime(2026, 6, 14, 10, 0, 0, 0, DateTimeKind.Unspecified), "Joined" });

            migrationBuilder.UpdateData(
                table: "UserClasses",
                keyColumn: "Id",
                keyValue: 2,
                columns: new[] { "CancelledAt", "CancelledByUserId", "JoinedAt", "Status" },
                values: new object[] { null, null, new DateTime(2026, 6, 14, 10, 0, 0, 0, DateTimeKind.Unspecified), "Joined" });

            migrationBuilder.UpdateData(
                table: "UserClasses",
                keyColumn: "Id",
                keyValue: 3,
                columns: new[] { "CancelledAt", "CancelledByUserId", "JoinedAt", "Status" },
                values: new object[] { null, null, new DateTime(2026, 6, 14, 10, 0, 0, 0, DateTimeKind.Unspecified), "Joined" });

            migrationBuilder.UpdateData(
                table: "UserClasses",
                keyColumn: "Id",
                keyValue: 4,
                columns: new[] { "CancelledAt", "CancelledByUserId", "JoinedAt", "Status" },
                values: new object[] { null, null, new DateTime(2026, 6, 14, 10, 0, 0, 0, DateTimeKind.Unspecified), "Joined" });

            migrationBuilder.UpdateData(
                table: "UserClasses",
                keyColumn: "Id",
                keyValue: 5,
                columns: new[] { "CancelledAt", "CancelledByUserId", "JoinedAt", "Status" },
                values: new object[] { null, null, new DateTime(2026, 6, 14, 10, 0, 0, 0, DateTimeKind.Unspecified), "Joined" });

            migrationBuilder.CreateIndex(
                name: "IX_UserClasses_UserId_ClassId",
                table: "UserClasses",
                columns: new[] { "UserId", "ClassId" },
                unique: true);

            migrationBuilder.AddForeignKey(
                name: "FK_Payments_Studios_StudioId",
                table: "Payments",
                column: "StudioId",
                principalTable: "Studios",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_Payments_Users_UserId",
                table: "Payments",
                column: "UserId",
                principalTable: "Users",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Payments_Studios_StudioId",
                table: "Payments");

            migrationBuilder.DropForeignKey(
                name: "FK_Payments_Users_UserId",
                table: "Payments");

            migrationBuilder.DropIndex(
                name: "IX_UserClasses_UserId_ClassId",
                table: "UserClasses");

            migrationBuilder.DropPrimaryKey(
                name: "PK_Payments",
                table: "Payments");

            migrationBuilder.DropColumn(
                name: "CancelledAt",
                table: "UserClasses");

            migrationBuilder.DropColumn(
                name: "CancelledByUserId",
                table: "UserClasses");

            migrationBuilder.DropColumn(
                name: "Status",
                table: "UserClasses");

            migrationBuilder.RenameTable(
                name: "Payments",
                newName: "Paymments");

            migrationBuilder.RenameIndex(
                name: "IX_Payments_UserId",
                table: "Paymments",
                newName: "IX_Paymments_UserId");

            migrationBuilder.RenameIndex(
                name: "IX_Payments_StudioId",
                table: "Paymments",
                newName: "IX_Paymments_StudioId");

            migrationBuilder.AddPrimaryKey(
                name: "PK_Paymments",
                table: "Paymments",
                column: "Id");

            migrationBuilder.UpdateData(
                table: "UserClasses",
                keyColumn: "Id",
                keyValue: 1,
                column: "JoinedAt",
                value: new DateTime(2026, 1, 14, 10, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.UpdateData(
                table: "UserClasses",
                keyColumn: "Id",
                keyValue: 2,
                column: "JoinedAt",
                value: new DateTime(2026, 1, 14, 10, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.UpdateData(
                table: "UserClasses",
                keyColumn: "Id",
                keyValue: 3,
                column: "JoinedAt",
                value: new DateTime(2026, 1, 14, 10, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.UpdateData(
                table: "UserClasses",
                keyColumn: "Id",
                keyValue: 4,
                column: "JoinedAt",
                value: new DateTime(2026, 1, 14, 10, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.UpdateData(
                table: "UserClasses",
                keyColumn: "Id",
                keyValue: 5,
                column: "JoinedAt",
                value: new DateTime(2026, 1, 14, 10, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.CreateIndex(
                name: "IX_UserClasses_UserId",
                table: "UserClasses",
                column: "UserId");

            migrationBuilder.AddForeignKey(
                name: "FK_Paymments_Studios_StudioId",
                table: "Paymments",
                column: "StudioId",
                principalTable: "Studios",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_Paymments_Users_UserId",
                table: "Paymments",
                column: "UserId",
                principalTable: "Users",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }
    }
}
