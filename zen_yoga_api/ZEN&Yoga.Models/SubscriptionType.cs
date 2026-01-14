using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ZEN_Yoga.Models
{
    [Table("SubscriptionTypes")]
    public class SubscriptionType
    {
        public int Id { get; set; }
        public required string Name { get; set; }
        public string? Description { get; set; }
        public required int DurationInDays { get; set; }

        public ICollection<StudioSubscription> StudioSubscriptions { get; set; } = new List<StudioSubscription>();
    }
}
