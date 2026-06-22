using System.ComponentModel.DataAnnotations.Schema;

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
        public required string Status { get; set; }
        public DateTime? CancelledAt { get; set; }
        public int? CancelledByUserId { get; set; }
    }
}
