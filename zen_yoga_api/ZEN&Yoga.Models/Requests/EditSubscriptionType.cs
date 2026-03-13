using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ZEN_Yoga.Models.Requests
{
    public class EditSubscriptionType
    {
        public required string Name { get; set; }
        public string? Description { get; set; }
        public required int DurationInDays { get; set; }
    }
}
