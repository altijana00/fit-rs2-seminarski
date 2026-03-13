using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ZEN_Yoga.Models.Requests
{
    public class EditRole
    {
        public required string Name { get; set; }
        public string? Description { get; set; }
    }
}
