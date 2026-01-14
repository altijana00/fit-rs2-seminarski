using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ZEN_Yoga.Models.SearchObjects
{
    public class UserQuery
    {
        public string? Search { get; set; }
        public int? RoleId { get; set; }
        public int? CityId { get; set; }
    }
}
