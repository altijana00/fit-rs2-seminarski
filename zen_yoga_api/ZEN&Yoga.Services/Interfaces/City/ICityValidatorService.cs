using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ZEN_Yoga.Services.Interfaces.City
{
    public interface ICityValidatorService
    {
        Task<bool> ValidateCity(int id);
    }
}
