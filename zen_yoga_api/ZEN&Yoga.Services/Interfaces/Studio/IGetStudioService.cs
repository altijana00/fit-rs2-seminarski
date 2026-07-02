using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ZEN_Yoga.Models.Requests;
using ZEN_Yoga.Models.Responses;
using ZEN_Yoga.Models.SearchObjects;
using ZEN_Yoga.Services.Interfaces.Base;

namespace ZEN_Yoga.Services.Interfaces.Studio
{
    public interface IGetStudioService : IGetService<Models.Studio, StudioResponse>
    {
        Task<PagedResponse<StudioResponse>> GetStudiosQuery(StudioQuery studioQuery, PagedRequest request);
        Task<List<StudioResponse>> GetByOwner(int ownerId);
        Task<StudioResponse> GetByOwnerAndStudioName(int ownerId, string name);
    }
}
