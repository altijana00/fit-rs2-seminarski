using System.ComponentModel.DataAnnotations;

namespace ZEN_Yoga.Models.Requests
{
    public class AddYogaType
    {
        public required string Name { get; set; }
        [Required]
        public string? Description { get; set; }
    }
}
