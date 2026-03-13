using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ZEN_Yoga.Models;
using ZEN_Yoga.Services.Interfaces.YogaType;

namespace ZEN_Yoga.Services.Services.YogaType
{
    public class DeleteYogaTypeService : IDeleteYogaTypeService
    {
        private readonly ZenYogaDbContext _dbContext;


        public DeleteYogaTypeService(ZenYogaDbContext dbContext)
        {

            _dbContext = dbContext;

        }

        public async Task<bool> Delete(int id)
        {
            var yogaType = await _dbContext.YogaTypes.FirstOrDefaultAsync(u => u.Id == id);

            if (yogaType != null)
            {

                _dbContext.Remove(yogaType);
                await _dbContext.SaveChangesAsync();
                return true;
            }
            return false;
        }
    }
}
