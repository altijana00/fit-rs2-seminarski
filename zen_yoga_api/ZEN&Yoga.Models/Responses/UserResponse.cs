namespace ZEN_Yoga.Models.Responses
{
    public class UserResponse
    {
        public int Id { get; set; }       
        public required string FirstName { get; set; }    
        public required string LastName { get; set; }
        public string? Gender { get; set; }
        public DateTime? DateOfBirth { get; set; }
        public required string Email { get; set; }
        public string? ProfileImageUrl { get; set; }
        public int RoleId { get; set; }
        public int CityId { get; set; }
     
    }
}
