using ZEN_Yoga.Models.Responses;
using ZEN_Yoga.Services.Interfaces.Base;

namespace ZEN_Yoga.Services.Interfaces.Instructor
{
    public interface IGetInstructorService : IGetService<Models.Instructor, InstructorResponse>
    {
        Task<List<InstructorResponse>> GetByStudioId(int studioId);
        Task<InstructorResponse> GetByEmail(string email);
    }
}
