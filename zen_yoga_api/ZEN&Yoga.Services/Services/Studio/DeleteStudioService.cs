using AutoMapper;
using Microsoft.EntityFrameworkCore;
using ZEN_Yoga.Models;
using ZEN_Yoga.Services.Interfaces.Studio;

namespace ZEN_Yoga.Services.Services.Studio
{
    public class DeleteStudioService : IDeleteStudioService
    {
        private readonly ZenYogaDbContext _dbContext;

        public DeleteStudioService(ZenYogaDbContext dbContext)
        {
            _dbContext = dbContext;
            
        }

        public async Task<bool> Delete(int id)
        {
            var studio = await _dbContext.Studios
        .FirstOrDefaultAsync(s => s.Id == id);

            if (studio == null)
                return false;

            var classIds = await _dbContext.Classes
                .Where(c => c.StudioId == id)
                .Select(c => c.Id)
                .ToListAsync();

            var userClasses = await _dbContext.UserClasses
                .Where(uc => classIds.Contains(uc.ClassId))
                .ToListAsync();

            var classes = await _dbContext.Classes
                .Where(c => c.StudioId == id)
                .ToListAsync();

            var instructors = await _dbContext.Instructors
                .Where(i => i.StudioId == id)
                .ToListAsync();

            var payments = await _dbContext.Payments
                .Where(p => p.StudioId == id)
                .ToListAsync();

            _dbContext.UserClasses.RemoveRange(userClasses);
            _dbContext.Classes.RemoveRange(classes);
            _dbContext.Instructors.RemoveRange(instructors);
            _dbContext.Payments.RemoveRange(payments);

            _dbContext.Studios.Remove(studio);

            await _dbContext.SaveChangesAsync();

            return true;
        }
    }
}
