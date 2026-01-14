using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

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
