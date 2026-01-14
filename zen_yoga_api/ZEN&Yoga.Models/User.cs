using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ZEN_Yoga.Models
{
    [Table("Users")]
    public class User
    {
        [Key]
        public int Id { get; set; }
        [Required]
        public required string FirstName { get; set; }
        [Required]
        public required string LastName { get; set; }
        public string? Gender { get; set; }
        public DateTime? DateOfBirth {  get; set; }
        [EmailAddress]
        public required string Email { get; set; }
        
        public required string PasswordHash { get; set; }
        public required string PasswordSalt { get; set; }
        public string? ProfileImageUrl { get; set; }

        [ForeignKey(nameof(Role))]
        public int RoleId { get; set; }
        public Role? Role { get; set; }

        [ForeignKey(nameof(City))]
        public int CityId { get; set; }
        public  City? City { get; set; }

        public ICollection<UserStudio> UserStudios { get; set; } = new List<UserStudio>();
        public ICollection<UserClass> UserClasses { get; set; } = new List<UserClass>();
        public ICollection<Payment> UserPayments { get; set; } = new List<Payment>();

        public Instructor? Instructor { get; set; }

    }
}
