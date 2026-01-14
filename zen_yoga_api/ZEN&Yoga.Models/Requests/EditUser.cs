using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ZEN_Yoga.Models.Requests
{
    public class EditUser
    {
        [Required(ErrorMessage = "First name is required!")]
        [MaxLength(30, ErrorMessage = "First name can't have more that 30 characters.")]
        public required string FirstName { get; set; }

        [Required(ErrorMessage = "Last name is required!")]
        [MaxLength(30, ErrorMessage = "First name can't have more that 30 characters.")]
        public required string LastName { get; set; }
        public string? Gender { get; set; }

        [EmailAddress(ErrorMessage = "Please enter a valid email address format. (user@example.com)")]
        public required string Email { get; set; }
        public string? ProfileImageUrl { get; set; }
    }
}
