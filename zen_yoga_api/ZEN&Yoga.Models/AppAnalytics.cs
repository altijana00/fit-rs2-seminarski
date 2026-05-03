using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace ZEN_Yoga.Models
{
    [Table("AppAnalytics")]
    public class AppAnalytics
    {
        [Key]
        public int Id { get; set; }
        public DateTime? CreatedAt { get; set; }
        public int? TotalUsers { get; set; }
        public int? TotalStudios { get; set; }
        public string? MostPopularCity { get; set; }
    }
}
