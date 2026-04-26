using ZEN_Yoga.Models.Requests;
using ZEN_Yoga.Services.Interfaces.Base;

namespace ZEN_Yoga.Services.Interfaces.Notification
{
    public interface IUpsertNotificationService<TEntity> : IUpsertService<EditNotification> where TEntity : class
    {
        Task Add(AddNotification addNotification);

        Task ToggleReadNotification(int id);
    }
}
