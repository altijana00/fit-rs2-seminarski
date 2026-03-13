using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ZEN_Yoga.Models.Requests
{
    public class AddCity
    {
        [Required]
        [MaxLength(100)]
        public required string Name { get; set; }
    }
}
