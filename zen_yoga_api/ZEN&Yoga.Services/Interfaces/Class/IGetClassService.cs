using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ZEN_Yoga.Models.Responses;
using ZEN_Yoga.Models.SearchObjects;
using ZEN_Yoga.Services.Interfaces.Base;

namespace ZEN_Yoga.Services.Interfaces.Class
{
    public interface IGetClassService : IGetService<Models.Class, ClassResponse>
    {

        Task<List<ClassResponse>> GetByInstructorId(int instructorId, ClassQuery? classQuery);

        Task<List<ClassResponse>> GetByStudioId(int studioId);

        Task<GrouppedClasses> GetGroupped();

        Task<GrouppedClasses> GetStudioGroupped(int studioId);
    }
}
