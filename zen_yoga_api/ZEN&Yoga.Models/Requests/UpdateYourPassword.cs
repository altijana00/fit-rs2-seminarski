namespace ZEN_Yoga.Models.Requests
{
    public class UpdateYourPassword
    {
        public required string OldPassword { get; set; }
        public required string NewPassword { get; set; }
    }
}
