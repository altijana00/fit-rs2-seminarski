using AutoMapper;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ZEN_Yoga.Models;
using ZEN_Yoga.Services.Interfaces.Base;
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
            var studio = await _dbContext.Studios.
                FirstOrDefaultAsync(s => s.Id == id);

            var classes = await _dbContext.Classes.Where(c => c.StudioId == id).ToListAsync();
            var instructors = await _dbContext.Instructors.Where(i => i.StudioId == id).ToListAsync();
            var subscriptions = await _dbContext.StudioSubscriptions.Where(ss => ss.StudioId == id).ToListAsync();
            var payments = await _dbContext.Payments.Where(p => p.StudioId == id).ToListAsync();



            try
            {
                if (studio != null)
                {
                    foreach (var classs in classes)
                    {

                        var uc =   _dbContext.UserClasses.Where(c => c.ClassId == classs.Id);
                        if (uc != null) _dbContext.UserClasses.RemoveRange(uc);

                        _dbContext.Classes.Remove(classs);
                    }

                    _dbContext.Instructors.RemoveRange(instructors);
                    _dbContext.StudioSubscriptions.RemoveRange(subscriptions);
                    _dbContext.Payments.RemoveRange(payments);

                    _dbContext.Remove(studio);
                    await _dbContext.SaveChangesAsync();
                    return true;
                }
            }
            catch (Exception ex)
            {

                throw;
            }
            return false;
        }
    }
}
