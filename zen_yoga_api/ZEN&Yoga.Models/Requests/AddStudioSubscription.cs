using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ZEN_Yoga.Models.Requests
{
    public class AddStudioSubscription
    {
        public decimal Price { get; set; }
        public string? Description { get; set; }
    }

}
