using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ZEN_Yoga.Models.Requests
{
    public class AddClass
    {
        [Required(ErrorMessage ="You must select a yoga type.")]
        public int YogaTypeId { get; set; }
        

        [Required(ErrorMessage ="You must enter a name for your class.")]
        [MaxLength(50, ErrorMessage ="Class name can't contain more than 50 characters.")]
        public required string Name { get; set; }


        [MaxLength(150, ErrorMessage = "Class description can't contain more than 150 characters.")]
        public string? Description { get; set; }


        [MaxLength(20, ErrorMessage ="Location can't have more than 20 characters.")]
        public string? Location { get; set; }

        [Required(ErrorMessage ="You must select a start date for your class.")]
        public DateTime StartDate { get; set; }

        [Required(ErrorMessage = "You must select an end date for your class.")]
        public DateTime EndDate { get; set; }
        [Range(0,50, ErrorMessage = "Maximum number of participants is 50.")]
        public int? MaxParticipants { get; set; }
    }
}
