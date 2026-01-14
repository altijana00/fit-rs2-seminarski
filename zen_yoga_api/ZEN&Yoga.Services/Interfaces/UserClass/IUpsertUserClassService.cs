namespace ZEN_Yoga.Services.Interfaces.UserClass
{
    public interface IUpsertUserClassService
    {
        Task<bool> Join(int classId, int userId);
    }
}
