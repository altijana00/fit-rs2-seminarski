using AutoMapper;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ZEN_Yoga.Models;
using ZEN_Yoga.Services.Interfaces.Base;
using ZEN_Yoga.Services.Interfaces.Class;

namespace ZEN_Yoga.Services.Services.Class
{
    public class DeleteClassService : IDeleteClassService
    {
        private readonly IMapper _mapper;
        private readonly ZenYogaDbContext _dbContext;

        public DeleteClassService(IMapper mapper, ZenYogaDbContext dbContext)
        {
            _mapper = mapper;
            _dbContext = dbContext;
        }
        public async Task<bool> Delete(int id)
        {
            var classRes = await _dbContext.Classes.FirstOrDefaultAsync(i => i.Id == id);
            var userClasses = await _dbContext.UserClasses.Where(c => c.ClassId == id).ToListAsync();


            if (classRes != null)
            {
                foreach (var c in userClasses)
                {
                    _dbContext.UserClasses.Remove(c);
                }

                _dbContext.Remove(classRes);
                await _dbContext.SaveChangesAsync();
                return true;
            }
            return false;
        }
    }
}
