using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ZEN_Yoga.Models.Requests
{
    public class LoginUser
    {
        [Required(ErrorMessage ="Email is required.")]
        [EmailAddress]
        public required string Email { get; set; }

        [Required(ErrorMessage ="Password is required.")]       
        public required string Password { get; set; }
    }
}
