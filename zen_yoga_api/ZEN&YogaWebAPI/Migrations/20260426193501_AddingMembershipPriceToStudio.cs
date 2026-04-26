using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace ZEN_YogaWebAPI.Migrations
{
    /// <inheritdoc />
    public partial class AddingMembershipPriceToStudio : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<float>(
                name: "MembershipPrice",
                table: "Studios",
                type: "real",
                nullable: false,
                defaultValue: 0f);

            migrationBuilder.UpdateData(
                table: "Studios",
                keyColumn: "Id",
                keyValue: 1,
                column: "MembershipPrice",
                value: 50f);

            migrationBuilder.UpdateData(
                table: "Studios",
                keyColumn: "Id",
                keyValue: 2,
                column: "MembershipPrice",
                value: 65f);

            migrationBuilder.UpdateData(
                table: "Studios",
                keyColumn: "Id",
                keyValue: 3,
                column: "MembershipPrice",
                value: 45f);

            migrationBuilder.UpdateData(
                table: "Studios",
                keyColumn: "Id",
                keyValue: 4,
                column: "MembershipPrice",
                value: 49.99f);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "MembershipPrice",
                table: "Studios");
        }
    }
}
