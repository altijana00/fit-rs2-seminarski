using ZEN_Yoga.Models;
using ZEN_Yoga.Models.Responses;

namespace ZEN_Yoga.Services.Interfaces.Analytics
{
    public interface IAppAnalyticsService
    {
        Task<AppAnalytics> GetAppAnalytics();

        Task<ParticipantAnalyticsResponse> GetAppAnalyticsForParticipant(int userId);
    }
}
