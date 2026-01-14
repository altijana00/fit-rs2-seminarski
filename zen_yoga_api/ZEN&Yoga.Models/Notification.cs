using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ZEN_Yoga.Models
{
    [Table("Notifications")]
    public class Notification
    {
        public int Id { get; set; }
        public required string Title { get; set; }
        public string? Content { get; set; }
        public required string Type { get; set; }
        public bool IsRead { get; set; }
        public DateTime CreatedAt { get; set; }
      
    }
}
