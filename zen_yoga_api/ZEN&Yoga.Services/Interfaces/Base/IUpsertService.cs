namespace ZEN_Yoga.Services.Interfaces.Base
{
    public interface IUpsertService<TEntity> where TEntity : class
    {
        Task Edit(TEntity entity, int id);
    }
}
