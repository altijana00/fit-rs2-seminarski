using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;
using ZEN_Yoga.Models;
using ZEN_Yoga.Models.Exceptions;
using ZEN_Yoga.Services.Interfaces.Studio;

namespace ZEN_Yoga.Services.Services.Studio
{
    public class StudioValidatorService : IStudioValidatorService
    {
        private readonly ZenYogaDbContext _dbContext;

        public StudioValidatorService(ZenYogaDbContext dbContext)
        {
            _dbContext = dbContext;

        }
        public async Task<bool> ValidateName(string name)
        {
            var studio = await _dbContext.Studios.FirstOrDefaultAsync(s=> s.Name == name);

            if(studio!=null)
            {
                throw new StudioAlreadyExistsException("There is already a studio registered with this name!");
            }

            return true;
        }

        public async Task<bool> ValidateStudio(int id)
        {
            var studio = await _dbContext.Studios.FirstOrDefaultAsync(s => s.Id == id);

            if (studio == null)
            {
                throw new StudioAlreadyExistsException("There is no studio with this Id!");
            }

            return true;
        }
    }
}
