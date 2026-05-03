using System.ComponentModel.DataAnnotations;

namespace ZEN_Yoga.Models.Responses
{
    public class CityResponse
    {
        public int Id { get; set; }
        [Required]
        [MaxLength(100)]
        public required string Name { get; set; }
    }
}