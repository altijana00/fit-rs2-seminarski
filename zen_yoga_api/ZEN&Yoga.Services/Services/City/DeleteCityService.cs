using Microsoft.EntityFrameworkCore;
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

        //public async Task<bool> Delete(int id)
        //{
        //    var city = await _dbContext.Cities.FirstOrDefaultAsync(u => u.Id == id);
        //    var studios = await _dbContext.Studios.Where(u => u.CityId == id).ToListAsync();
        //    var users = await _dbContext.Users.Where(u => u.CityId == id).ToListAsync();

        //    if (city != null)
        //    {
        //        if (studios.Any() || users.Any()) 
        //        {
        //            return false;
        //        }


        //        _dbContext.Remove(city);
        //        await _dbContext.SaveChangesAsync();
        //        return true;
        //    }
        //    return false;
        //}

        public async Task<bool> Delete(int id)
        {
            var city = await _dbContext.Cities.FirstOrDefaultAsync(u => u.Id == id);

            if (city is null)
                return false;

            var hasStudios = await _dbContext.Studios.AnyAsync(s => s.CityId == id);
            var hasUsers = await _dbContext.Users.AnyAsync(u => u.CityId == id);

            if (hasStudios || hasUsers)
                return false;

            _dbContext.Cities.Remove(city);
            await _dbContext.SaveChangesAsync();
            return true;

        }
    }
}
