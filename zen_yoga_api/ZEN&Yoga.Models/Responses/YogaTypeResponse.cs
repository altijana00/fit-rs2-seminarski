using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ZEN_Yoga.Models.Responses
{
    public class YogaTypeResponse
    {
        public int Id { get; set; }
       
        public required string Name { get; set; }
        
        public string? Description { get; set; }
    }
}
