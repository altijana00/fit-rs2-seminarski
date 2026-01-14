using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ZEN_Yoga.Models
{
    [Table("Cities")]
    public class City
    {
        [Key]
        public int Id { get; set; }
        [Required]
        [MaxLength(100)]
        public required string Name { get; set; }

        public ICollection<User> Users { get; set; } = new List<User>();
        public ICollection<Studio> Studios { get; set; } = new List<Studio>();
        
    }
}
