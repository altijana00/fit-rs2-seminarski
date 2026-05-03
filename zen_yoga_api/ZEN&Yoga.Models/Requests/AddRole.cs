using System.ComponentModel.DataAnnotations;

namespace ZEN_Yoga.Models.Requests
{
    public class AddRole
    {
        [Required(ErrorMessage = "You must input a role name")]
        public required string Name { get; set; }
        public string? Description { get; set; }
    }
}