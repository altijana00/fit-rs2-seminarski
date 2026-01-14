using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ZEN_Yoga.Models.Responses
{
    public class ClassResponse
    {
        
        public int Id { get; set; }

       
        public int StudioId { get; set; }
       

        
        public int InstructorId { get; set; }
       

        
        public int YogaTypeId { get; set; }
       

        [Required]
        [MaxLength(50)]
        public required string Name { get; set; }


        [MaxLength(150)]
        public string? Description { get; set; }


        [MaxLength(20)]
        public string? Location { get; set; }

        [Required]
        public DateTime StartDate { get; set; }

        [Required]
        public DateTime EndDate { get; set; }

        public int? MaxParticipants { get; set; }
    }
}
