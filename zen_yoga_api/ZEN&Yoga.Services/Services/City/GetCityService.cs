using AutoMapper;
using Microsoft.EntityFrameworkCore;
using ZEN_Yoga.Models;
using ZEN_Yoga.Models.Enums;
using ZEN_Yoga.Models.Requests;
using ZEN_Yoga.Models.Responses;
using ZEN_Yoga.Models.SearchObjects;
using ZEN_Yoga.Services.Interfaces.City;

namespace ZEN_Yoga.Services.Services.City
{
    public class GetCityService : IGetCityService
    {
        private readonly ZenYogaDbContext _dbContext;
        private readonly IMapper _mapper;


        public GetCityService(ZenYogaDbContext dbContext, IMapper mapper)
        {
            _dbContext = dbContext;
            _mapper = mapper;

        }

        public async Task<PagedResponse<CityResponse>> GetAll(PagedRequest request)
        {
            var query = _dbContext.Cities
                                  .AsNoTracking()
                                  .OrderByDescending(r => r.Id);

            var totalCount = await query.CountAsync();

            var cities = await query
                .Skip((request.Page - 1) * request.PageSize)
                .Take(request.PageSize)
                .ToListAsync();

            return new PagedResponse<CityResponse>
            {
                Items = _mapper.Map<List<CityResponse>>(cities),
                TotalCount = totalCount,
                Page = request.Page,
                PageSize = request.PageSize
            };

        }

        public async Task<CityResponse> GetById(int id)
        {
            var city = await _dbContext.Cities.AsNoTracking().FirstOrDefaultAsync(c => c.Id == id);

            return _mapper.Map<CityResponse>(city);
        }


        public async Task<PagedResponse<CityResponse>> GetCitiesQuery(CityQuery cityQuery, PagedRequest request)
        {
            var query = _dbContext.Cities.AsNoTracking().AsQueryable();

            if (!string.IsNullOrWhiteSpace(cityQuery.Search))
            {
                var search = cityQuery.Search.ToLower();
                query = query.Where(u => u.Name.ToLower().Contains(search));
            }

            query = query.OrderByDescending(c => c.Id);
            var totalCount = await query.CountAsync();

            var results = await query
               .Skip((request.Page - 1) * request.PageSize)
               .Take(request.PageSize)
               .ToListAsync();
            

            return new PagedResponse<CityResponse>
            {
                Items = _mapper.Map<List<CityResponse>>(results),
                TotalCount = totalCount,
                Page = request.Page,
                PageSize = request.PageSize
            };

        }


    }
}
