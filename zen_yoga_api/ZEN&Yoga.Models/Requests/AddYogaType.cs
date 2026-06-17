using System.ComponentModel.DataAnnotations;

namespace ZEN_Yoga.Models.Requests
{
    public class AddYogaType
    {
        [Required]
        public required string Name { get; set; }
        public string? Description { get; set; }
    }
}
