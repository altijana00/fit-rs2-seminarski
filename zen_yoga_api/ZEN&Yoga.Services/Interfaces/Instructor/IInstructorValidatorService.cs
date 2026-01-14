using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ZEN_Yoga.Services.Interfaces.Instructor
{
    public interface IInstructorValidatorService
    {
        Task<bool> ValidateEmail(string email);

        Task<bool> ValidateInstructorId(int id);
    }
}
