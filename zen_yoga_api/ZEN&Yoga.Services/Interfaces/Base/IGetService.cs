using ZEN_Yoga.Models.Requests;
using ZEN_Yoga.Models.Responses;

namespace ZEN_Yoga.Services.Interfaces.Base
{
    public interface IGetService<T, TEntity> where T : class where TEntity : class
    {
        Task<PagedResponse<TEntity>> GetAll(PagedRequest request);

        Task<TEntity> GetById(int id);
    }
}
