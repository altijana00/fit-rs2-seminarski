using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ZEN_Yoga.Models.Enums
{
    public enum PaymentStatus
    {
        Processing = 0,
        Succeeded = 1,
        Canceled = 3,
        Requires_Capture = 4,
        Requires_Reauthorization = 5,
        Requires_Confirmation = 6,
        Requires_Action = 7
    }
}
