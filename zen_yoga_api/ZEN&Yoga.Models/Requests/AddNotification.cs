using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ZEN_Yoga.Models.Requests
{
    public class AddNotification
    {
        public int UserId { get; set; }
        public required string Title { get; set; }
        public string? Content { get; set; }
        public required string Type { get; set; }
    }
}
