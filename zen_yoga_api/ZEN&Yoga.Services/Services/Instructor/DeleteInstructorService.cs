using Microsoft.EntityFrameworkCore;
using ZEN_Yoga.Models;
using ZEN_Yoga.Services.Interfaces.Instructor;

namespace ZEN_Yoga.Services.Services.Instructor
{
    public class DeleteInstructorService : IDeleteInstructorService
    {
        private readonly ZenYogaDbContext _dbContext;

        public DeleteInstructorService(ZenYogaDbContext dbContext)
        {
            _dbContext = dbContext;
        }
        //public async Task<bool> Delete(int id)
        //{
        //    var instructor = await _dbContext.Instructors.FirstOrDefaultAsync(i => i.Id == id);
        //    var classes = await _dbContext.Classes.Where(c => c.InstructorId == id).ToListAsync();


        //    if (instructor != null)
        //    {
        //        foreach (var c in classes)
        //        {

        //            var userClasses = await _dbContext.UserClasses
        //                .Where(uc => uc.ClassId == c.Id)
        //                .ToListAsync();

        //            _dbContext.UserClasses.RemoveRange(userClasses);

        //            _dbContext.Classes.Remove(c);

        //        }

        //        _dbContext.Remove(instructor);
        //        await _dbContext.SaveChangesAsync();
        //        return true;
        //    }
        //    return false;
        //}

        public async Task<bool> Delete(int id)
        {
            var instructor = await _dbContext.Instructors
                .FirstOrDefaultAsync(i => i.Id == id);

            if (instructor == null)
                return false;

            var classIds = await _dbContext.Classes
                .Where(c => c.InstructorId == id)
                .Select(c => c.Id)
                .ToListAsync();

            var userClasses = await _dbContext.UserClasses
                .Where(uc => classIds.Contains(uc.ClassId))
                .ToListAsync();

            var classes = await _dbContext.Classes
                .Where(c => c.InstructorId == id)
                .ToListAsync();

            _dbContext.UserClasses.RemoveRange(userClasses);
            _dbContext.Classes.RemoveRange(classes);
            _dbContext.Instructors.Remove(instructor);

            await _dbContext.SaveChangesAsync();

            return true;
        }
    }
}
