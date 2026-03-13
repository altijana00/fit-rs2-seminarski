using AutoMapper;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ZEN_Yoga.Models;
using ZEN_Yoga.Models.Requests;
using ZEN_Yoga.Services.Interfaces.City;

namespace ZEN_Yoga.Services.Services.City
{
    public class UpsertCityService : IUpsertCityService<AddCity>
    {
        private readonly IMapper _mapper;
        private readonly ZenYogaDbContext _dbContext;


        public UpsertCityService(IMapper mapper, ZenYogaDbContext dbContext)
        {
            _dbContext = dbContext;
            _mapper = mapper;

        }

        public async Task Add(AddCity addCity)
        {
            var city = _mapper.Map<Models.City>(addCity);

            await _dbContext.Cities.AddAsync(city);

            await _dbContext.SaveChangesAsync();
        }

        public async Task Edit(EditCity editCity, int id)
        {
            var city = await _dbContext.Cities.FirstOrDefaultAsync(u => u.Id == id);

            if (city != null)
            {
                _mapper.Map(editCity, city);

                await _dbContext.SaveChangesAsync();
            }
        }
    }
}
