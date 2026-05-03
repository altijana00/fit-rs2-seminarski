using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace ZEN_Yoga.Models
{
    [Table("Studios")]
    public class Studio
    {
        [Key]
        public int Id { get; set; }

        [ForeignKey(nameof(Owner))]
        public int OwnerId { get; set; }
        public User? Owner { get; set; }
        [Required]
        public required string Name { get; set; }

        [MaxLength(300)]
        public string? Description { get; set; }

        [ForeignKey(nameof(City))]
        public int CityId { get; set; }
        public City? City { get; set; }

        public string? Address { get; set; }

        [EmailAddress]
        public string? ContactEmail { get; set; }

        [Phone]
        public string? ContactPhone { get; set; }
        public string? ProfileImageUrl { get; set; }

        public required float MembershipPrice { get; set; }

       public ICollection<Instructor> StudioInstructors { get; set; } = new List<Instructor>();
       public ICollection<Class> StudioClasses { get; set; } = new List<Class>();
       public ICollection<StudioAnalytics> StudioAnalytics { get; set; } = new List<StudioAnalytics>();

    }
}
