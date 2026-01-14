using ZEN_Yoga.Models.Requests;
using ZEN_Yoga.Services.Interfaces.Base;
using ZEN_Yoga.Services.Interfaces.YogaType;

namespace ZEN_Yoga.Services.Interfaces.Class
{
    public interface IUpsertClassService<TEntity> : IUpsertService<EditClass> where TEntity : class
    {
        Task Add(TEntity entity, int instructorId, IYogaTypeValidatorService yogaTypeValidatorService);
    }
}
