using System.ComponentModel.DataAnnotations.Schema;

namespace ZEN_Yoga.Models
{
    [Table("Paymments")]
    public class Payment
    {
        public int Id { get; set; }

        public int UserId { get; set; }
        public User? User { get; set; }

        public int StudioId { get; set; }
        public Studio? Studio { get; set; }
        public DateTime PaymentDate { get; set; }
        public decimal Amount { get; set; }
        public required string Status { get; set; }
        public DateTime CreatedAt { get; set; }

        public string? PaymentIntentId { get; set; }
    }
}
