using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ZEN_Yoga.Models;
using ZEN_Yoga.Models.Exceptions;
using ZEN_Yoga.Services.Interfaces.Class;

namespace ZEN_Yoga.Services.Services.Class
{
    public class ClassValidatorService : IClassValidatorService
    {
        private readonly ZenYogaDbContext _dbContext;

        public ClassValidatorService(ZenYogaDbContext dbContext)
        {
            _dbContext = dbContext;

        }
        public async Task<bool> ValidateClass(int id)
        {
            var classRes = await _dbContext.Classes.FirstOrDefaultAsync(c => c.Id == id);

            if (classRes == null)
            {
                throw new ClassNotFoundException("There is no class with this Id!");
            }

            return true;
        }
    }
}
