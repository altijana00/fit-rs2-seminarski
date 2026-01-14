using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ZEN_Yoga.Models.Requests
{
    public class EditInstructor
    {
        [Required(ErrorMessage = "First name is required!")]
        [MaxLength(30, ErrorMessage = "First name can't have more that 30 characters.")]
        public required string FirstName { get; set; }

        [Required(ErrorMessage = "Last name is required!")]
        [MaxLength(30, ErrorMessage = "Last name can't have more that 30 characters.")]
        public required string LastName { get; set; }
        public string? Gender { get; set; }

        [EmailAddress(ErrorMessage = "Please enter a valid email address format. (user@example.com)")]
        public required string Email { get; set; }
        public string? ProfileImageUrl { get; set; }

        [MaxLength(200, ErrorMessage = "Biography can't contain more than 200 characters.")]
        public string? Biography { get; set; }


        [MaxLength(200, ErrorMessage = "Diplomas can't contain more than 200 characters.")]
        public string? Diplomas { get; set; }


        [MaxLength(200, ErrorMessage = "Certificates can't contain more than 200 characters.")]
        public string? Certificates { get; set; }
    }
}
