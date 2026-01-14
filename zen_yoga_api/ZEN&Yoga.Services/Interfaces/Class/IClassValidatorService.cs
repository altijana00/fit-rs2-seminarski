using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ZEN_Yoga.Services.Interfaces.Class
{
    public interface IClassValidatorService
    {
        Task<bool> ValidateClass(int id);
    }
}
