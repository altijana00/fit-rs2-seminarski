using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ZEN_Yoga.Models
{
    [Table("StudioAnalytics")]
    public class StudioAnalytics
    {
        public int Id { get; set; }
        public int StudioId { get; set; }
        public Studio? Studio { get; set; }
        public int Month { get; set; }
        public int Year { get; set; }
        public decimal TotalRevenue { get; set; }
        public int TotalParticipants { get; set; }

    }
}
