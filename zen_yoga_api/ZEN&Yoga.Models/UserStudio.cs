using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ZEN_Yoga.Models
{
    [Table("UserStudio")]
    public class UserStudio
    {
        [Key]
        public int Id { get; set; }

        [ForeignKey(nameof(User))] 
        public int UserId { get; set; }
        public User? User { get; set; }

        [ForeignKey(nameof(Studio))]
        public int StudioId { get; set; }
        public Studio? Studio { get; set; }

        public DateTime JoinedAt { get; set; }
        public DateTime SubscriptionStart { get; set; }
        public DateTime SubscriptionEnd { get; set; }

        public bool isActive {  get; set; }

    }
}
