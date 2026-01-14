using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ZEN_Yoga.Models.Responses
{
    public class StudioResponse
    {
  
        public int Id { get; set; }

        
        public int OwnerId { get; set; }
        
    
        public required string Name { get; set; }

        [MaxLength(300)]
        public string? Description { get; set; }

        
        public int CityId { get; set; }
     

        public string? Address { get; set; }

        [EmailAddress]
        public string? ContactEmail { get; set; }

        [Phone]
        public string? ContactPhone { get; set; }
        public string? ProfileImageUrl { get; set; }
    }
}
