using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace ZEN_Yoga.Models
{
    [Table("YogaTypes")]
    public class YogaType
    {
        [Key]
        public int Id { get; set; }
        [Required]
        public required string Name { get; set; }
        [Required]
        public string? Description { get; set; }

        public ICollection<Class> YogaTypeClasses { get; set; } = new List<Class>();
    }
}
