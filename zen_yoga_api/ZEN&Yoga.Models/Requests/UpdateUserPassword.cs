namespace ZEN_Yoga.Models.Requests
{
    public class UpdateUserPassword
    {
        public int UserId { get; set; }

        public string? OldPassword { get; set; }

        public required string NewPassword { get; set; }
    }
}