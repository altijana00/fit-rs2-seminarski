using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ZEN_Yoga.Models.Responses
{
    public class StudioParticipantsByCityResponse
    {
        public required string  CityName { get; set; }
        public required int NumberOfParticipants { get; set; }
    }
}
