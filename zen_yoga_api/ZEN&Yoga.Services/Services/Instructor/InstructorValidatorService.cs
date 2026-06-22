using Microsoft.EntityFrameworkCore;
using ZEN_Yoga.Models;
using ZEN_Yoga.Models.Exceptions;
using ZEN_Yoga.Services.Interfaces.Instructor;

namespace ZEN_Yoga.Services.Services.Instructor
{
    public class InstructorValidatorService : IInstructorValidatorService
    {
        private readonly ZenYogaDbContext _dbContext;

        public InstructorValidatorService(ZenYogaDbContext dbContext)
        {
            _dbContext = dbContext;

        }
        public async Task<bool> ValidateEmail(string email)
        {
            var user = await _dbContext.Users.FirstOrDefaultAsync(u => u.Email == email);


            if (user == null) 
            {
                throw new InstructorNotFoundException("There is no user registered with this email.");
            }
            var instructor = await _dbContext.Instructors.FirstOrDefaultAsync(i => i.Id == user!.Id);

            if(instructor != null)
            {
                throw new InstructorAlreadyExistsException("There is already an instructor registered with this email.");
            }
            return true;
        }

        public async Task<bool> ValidateInstructorId(int id)
        {
            var instructor = await _dbContext.Instructors.FirstOrDefaultAsync(i => i.Id == id);

            if (instructor == null)
            {
                throw new InstructorNotFoundException("There is no instructor with this Id.");
            }
            return true;
        }
    }
}
