using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ZEN_Yoga.Models.Responses;

namespace ZEN_Yoga.Services.Interfaces.Analytics
{
    public interface IStudioAnalyticsService
    {
        Task<float> GetByStudio(int studioId);

        Task<int> GetNumberofParticipants (int studioId);

        Task<List<StudioParticipantsByCityResponse>> GetMostPopularStudioCities();
    }
}
