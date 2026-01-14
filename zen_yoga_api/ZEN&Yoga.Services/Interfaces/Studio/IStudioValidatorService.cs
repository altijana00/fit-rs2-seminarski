using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ZEN_Yoga.Services.Interfaces.Studio
{
    public interface IStudioValidatorService
    {
        Task<bool> ValidateName(string name);
        Task<bool> ValidateStudio(int id);
    }
}
