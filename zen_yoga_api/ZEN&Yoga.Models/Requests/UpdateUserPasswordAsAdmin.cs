namespace ZEN_Yoga.Models.Requests
{
    public class UpdateUserPasswordAsAdmin
    {
        public int UserId { get; set; }

        public required string NewPassword { get; set; }
    }
}