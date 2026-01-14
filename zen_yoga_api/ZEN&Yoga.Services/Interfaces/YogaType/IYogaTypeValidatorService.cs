using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ZEN_Yoga.Services.Interfaces.YogaType
{
    public interface IYogaTypeValidatorService
    {
        Task<bool> ValidateYogaTypeId(int id);
    }
}
