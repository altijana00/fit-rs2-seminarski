using ZEN_Yoga.Services.Interfaces.Base;

namespace ZEN_Yoga.Services.Interfaces.Notification
{
    public interface IDeleteNotificationService 
    {
        Task<bool> Delete(int id, int userId);
    }
}
