using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

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
        public int SubscriptionTypeId { get; set; }
        public SubscriptionType? SubscriptionType { get; set; }
        public StudioSubscription? StudioSubscription { get; set; }

        public DateTime PaymentDate { get; set; }
        public decimal Amount { get; set; }
        public required string Status { get; set; }
        public DateTime CreatedAt { get; set; }
        
    }
}
