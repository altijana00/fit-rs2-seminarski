using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ZEN_Yoga.Models.Responses
{
    public  class PaymentResponse
    {
        public int UserId { get; set; }

        public int StudioId { get; set; }
        public DateTime PaymentDate { get; set; }
        public decimal Amount { get; set; }
        public required string Status { get; set; }

    }
}
