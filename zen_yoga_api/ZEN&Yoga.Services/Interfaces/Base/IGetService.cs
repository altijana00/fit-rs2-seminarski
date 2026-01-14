using ZEN_Yoga.Models.Requests;

namespace ZEN_Yoga.Services.Interfaces.Base
{
    public interface IGetService<T, TEntity> where T : class where TEntity : class
    {
        Task<List<TEntity>> GetAll();

        Task<TEntity> GetById(int id);
    }
}
