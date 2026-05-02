using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ZEN_Yoga.Models.Requests
{
    public class UpdateUserPassword
    {
        public int UserId { get; set; }

        public string? OldPassword { get; set; }

        public required string NewPassword { get; set; }
    }
}
