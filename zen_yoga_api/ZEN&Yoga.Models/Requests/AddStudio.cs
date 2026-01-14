using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ZEN_Yoga.Models.Requests
{
    public class AddStudio
    {
       
        public int OwnerId { get; set; }

        [Required(ErrorMessage = "Studio name is required!")]
        public required string Name { get; set; }

        [MaxLength(300, ErrorMessage = "Description can't have more than 300 characters.")]
        public string? Description { get; set; }
       
        public int CityId { get; set; }

        [MaxLength(100, ErrorMessage = "Address can't have more than 100 characters.")]
        public string? Address { get; set; }

        [EmailAddress(ErrorMessage = "Please enter a valid email format. (studio@example.com)")]
        public string? ContactEmail { get; set; }

        [Phone(ErrorMessage = "Please enter a valid phone format. (...)")]
        public string? ContactPhone { get; set; }
        public string? ProfileImageUrl { get; set; }
    }
}
