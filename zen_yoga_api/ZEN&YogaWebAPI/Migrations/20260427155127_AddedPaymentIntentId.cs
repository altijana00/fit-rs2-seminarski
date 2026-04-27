using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace ZEN_YogaWebAPI.Migrations
{
    /// <inheritdoc />
    public partial class AddedPaymentIntentId : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "PaymentIntentId",
                table: "Paymments",
                type: "nvarchar(max)",
                nullable: true);

            migrationBuilder.UpdateData(
                table: "Paymments",
                keyColumn: "Id",
                keyValue: 1,
                column: "PaymentIntentId",
                value: "pi_1");

            migrationBuilder.UpdateData(
                table: "Paymments",
                keyColumn: "Id",
                keyValue: 2,
                column: "PaymentIntentId",
                value: "pi_2");

            migrationBuilder.UpdateData(
                table: "Paymments",
                keyColumn: "Id",
                keyValue: 3,
                column: "PaymentIntentId",
                value: "pi_3");

            migrationBuilder.UpdateData(
                table: "Paymments",
                keyColumn: "Id",
                keyValue: 4,
                column: "PaymentIntentId",
                value: "pi_4");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "PaymentIntentId",
                table: "Paymments");
        }
    }
}
