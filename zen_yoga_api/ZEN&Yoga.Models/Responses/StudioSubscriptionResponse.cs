using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ZEN_Yoga.Models.Responses
{
    public class StudioSubscriptionResponse
    {
        public int Id { get; set; }        
        public int StudioId { get; set; }
        public int SubscriptionTypeId { get; set; }      
        public required string Name { get; set; }
        public string? Description { get; set; }
        public required int DurationInDays { get; set; }
        public decimal Price { get; set; }

    }
}
