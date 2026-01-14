using AutoMapper;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ZEN_Yoga.Models;
using ZEN_Yoga.Services.Interfaces.Base;
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
        public async Task<bool> Delete(int id)
        {
            var instructor = await _dbContext.Instructors.FirstOrDefaultAsync(i => i.Id == id);
            var classes = await _dbContext.Classes.Where(c => c.InstructorId == id).ToListAsync();


            if (instructor != null)
            {
                foreach (var c in classes)
                {
                    _dbContext.Classes.Remove(c);
                }

                _dbContext.Remove(instructor);
                await _dbContext.SaveChangesAsync();
                return true;
            }
            return false;
        }
    }
}
