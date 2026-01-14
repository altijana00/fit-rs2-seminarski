using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Diagnostics.Contracts;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Text;
using System.Threading.Tasks;

namespace ZEN_Yoga.Models
{
    [Table("Classes")]
    public class Class
    {
        [Key]
        [Required]
        public int Id { get; set; }

        [ForeignKey(nameof(Studio))]
        public int StudioId { get; set; }
        public Studio? Studio { get; set; }

        [ForeignKey(nameof(Instructor))]
        public int InstructorId { get; set; }
        public Instructor? Instructor { get; set; }

        [ForeignKey(nameof(YogaType))]
        public int YogaTypeId { get; set; }
        public YogaType? YogaType { get; set; }

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
