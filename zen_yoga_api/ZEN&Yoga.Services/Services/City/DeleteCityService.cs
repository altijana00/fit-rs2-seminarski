using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ZEN_Yoga.Models;
using ZEN_Yoga.Services.Interfaces.City;

namespace ZEN_Yoga.Services.Services.City
{
    public class DeleteCityService : IDeleteCityService
    {
        private readonly ZenYogaDbContext _dbContext;


        public DeleteCityService(ZenYogaDbContext dbContext)
        {

            _dbContext = dbContext;

        }

        public async Task<bool> Delete(int id)
        {
            var city = await _dbContext.Cities.FirstOrDefaultAsync(u => u.Id == id);
            var studios = await _dbContext.Studios.Where(u => u.CityId == id).ToListAsync();
            var users = await _dbContext.Users.Where(u => u.CityId == id).ToListAsync();

            if (city != null)
            {
                if (studios.Any() || users.Any()) 
                {
                    return false;
                }


                _dbContext.Remove(city);
                await _dbContext.SaveChangesAsync();
                return true;
            }
            return false;
        }
    }
}
