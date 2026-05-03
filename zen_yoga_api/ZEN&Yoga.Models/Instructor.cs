using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace ZEN_Yoga.Models
{
    [Table("Instructors")]
    public class Instructor
    {
        [Key]
        [Required]
        public int Id { get; set; }

        [ForeignKey(nameof(Id))]
        public User? User { get; set; }

        
        [MaxLength(200)]
        public string? Biography { get; set; }

        
        [MaxLength(200)]
        public string? Diplomas { get; set; }

        
        [MaxLength(200)]
        public string? Certificates { get; set; }

        public int StudioId { get; set; } 
        public Studio? Studio { get; set; }

        public ICollection<Class> InstructorClasses { get; set; } = new List<Class>();


    }
}
