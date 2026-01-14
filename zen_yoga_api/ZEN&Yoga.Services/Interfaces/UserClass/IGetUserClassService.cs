using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ZEN_Yoga.Models.Responses;
using ZEN_Yoga.Services.Interfaces.Base;
using ZEN_Yoga.Services.Interfaces.Studio;

namespace ZEN_Yoga.Services.Interfaces.UserClass
{
    public interface IGetUserClassService : IGetService<Models.UserClass, UserClassesResponse>
    {
        Task<List<StudioResponse>> GetUserRecommendedStudios(int userId, IGetStudioService getStudioService);

        Task<List<ClassResponse>> GetByUserId(int userId);
    }
}
