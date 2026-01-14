using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

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

       public ICollection<UserStudio> StudioMembers { get; set; } = new List<UserStudio>();
       public ICollection<StudioSubscription> StudioSubscriptions { get; set; } = new List<StudioSubscription>();
       public ICollection<Instructor> StudioInstructors { get; set; } = new List<Instructor>();
       public ICollection<Class> StudioClasses { get; set; } = new List<Class>();
       public ICollection<StudioAnalytics> StudioAnalytics { get; set; } = new List<StudioAnalytics>();

    }
}
