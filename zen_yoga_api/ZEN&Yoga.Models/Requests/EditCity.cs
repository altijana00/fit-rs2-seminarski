using System.ComponentModel.DataAnnotations;

namespace ZEN_Yoga.Models.Requests
{
    public class EditCity
    {
        [Required]
        [MaxLength(100)]
        public required string Name { get; set; }
    }
}
