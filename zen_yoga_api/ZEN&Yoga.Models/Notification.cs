using System.ComponentModel.DataAnnotations.Schema;

namespace ZEN_Yoga.Models
{
    [Table("Notifications")]
    public class Notification
    {
        public int Id { get; set; }

        [ForeignKey(nameof(User))]
        public int UserId { get; set; }
        public User? User { get; set; }
        public required string Title { get; set; }
        public string? Content { get; set; }
        public required string Type { get; set; }
        public bool IsRead { get; set; }
        public DateTime CreatedAt { get; set; }
      
    }
}
