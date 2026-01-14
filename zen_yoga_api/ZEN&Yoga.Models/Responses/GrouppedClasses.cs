using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ZEN_Yoga.Models.Responses
{
    public class GrouppedClasses
    {
        public List<ClassResponse> HathaYoga { get; set; } = new List<ClassResponse>();

        public List<ClassResponse> YinYoga { get; set; } = new List<ClassResponse>();

        public List<ClassResponse> VinyasaYoga { get; set; } = new List<ClassResponse>();
    }
}
