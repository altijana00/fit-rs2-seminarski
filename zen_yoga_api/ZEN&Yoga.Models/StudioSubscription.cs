using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ZEN_Yoga.Models
{
    [Table("StudioSubscriptions")]
    public class StudioSubscription
    {
        public int Id { get; set; }
        public int StudioId { get; set; }
        public Studio? Studio { get; set; }
        public int SubscriptionTypeId { get; set; }
        public SubscriptionType? SubscriptionType { get; set; }
        public decimal Price { get; set; }
        public string? Description { get; set; }

    }
}
