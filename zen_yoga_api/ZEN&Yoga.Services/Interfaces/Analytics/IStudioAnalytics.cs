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
