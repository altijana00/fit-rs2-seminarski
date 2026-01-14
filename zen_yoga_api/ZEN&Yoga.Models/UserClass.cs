using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ZEN_Yoga.Models
{
    [Table("UserClasses")]
    public class UserClass
    {
        public int Id { get; set; }
        public int UserId { get; set; }
        public User? User { get; set; }
        public int ClassId { get; set; }
        public Class? Class { get; set; }
        public DateTime JoinedAt { get; set; } = DateTime.UtcNow;
    }
}
