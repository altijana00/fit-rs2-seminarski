using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ZEN_Yoga.Models;
using ZEN_Yoga.Models.Exceptions;
using ZEN_Yoga.Services.Interfaces.YogaType;

namespace ZEN_Yoga.Services.Services.YogaType
{
    public class YogaTypeValidatorService : IYogaTypeValidatorService
    {
        private readonly ZenYogaDbContext _dbContext;


        public YogaTypeValidatorService(ZenYogaDbContext dbContext)
        {
            _dbContext = dbContext;

        }
        public async Task<bool> ValidateYogaTypeId(int id)
        {
            var yogaType = await _dbContext.YogaTypes.FirstOrDefaultAsync(y => y.Id == id);

            if (yogaType == null)
            {
                throw new YogaTypeNotFoundException("Invalid yoga type!");

            }

            return true;
        }
    }
}
