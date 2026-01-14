using ZEN_Yoga.Models.Requests;
using ZEN_Yoga.Services.Interfaces.Base;
using ZEN_Yoga.Services.Interfaces.User;

namespace ZEN_Yoga.Services.Interfaces.Instructor
{
    public interface IUpsertInstructorService<TEntity> : IUpsertService<EditInstructor> where TEntity : class
    {
        Task<bool> Add(IGetUserService getUserService, IInstructorValidatorService instructorValidatorService, AddInstructor addInstructor, string email, int studioId);

       
    }
}
