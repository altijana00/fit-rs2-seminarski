using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ZEN_Yoga.Models.Exceptions;
using ZEN_Yoga.Models;
using ZEN_Yoga.Services.Interfaces.City;
using Microsoft.EntityFrameworkCore;

namespace ZEN_Yoga.Services.Services.City
{
    public class CityValidatorService : ICityValidatorService
    {
        private readonly ZenYogaDbContext _dbContext;


        public CityValidatorService(ZenYogaDbContext dbContext)
        {
            _dbContext = dbContext;

        }

        public async Task<bool> ValidateCity(int id)
        {
            var city = await _dbContext.Cities.FirstOrDefaultAsync(c => c.Id == id);

            if (city == null)
            {
                throw new RoleNotFoundException("City not found!");

            }

            return true;
        }
    }
}
