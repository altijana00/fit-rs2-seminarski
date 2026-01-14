using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ZEN_Yoga.Models.Requests
{
    public class AddInstructor
    {

        

        [MaxLength(200, ErrorMessage ="Biography can't contain more than 200 characters.")]
        public string? Biography { get; set; }


        [MaxLength(200, ErrorMessage = "Diplomas can't contain more than 200 characters.")]
        public string? Diplomas { get; set; }


        [MaxLength(200, ErrorMessage = "Certificates can't contain more than 200 characters.")]
        public string? Certificates { get; set; }

        
    }
}
