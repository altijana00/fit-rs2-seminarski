using AutoMapper;
using Microsoft.EntityFrameworkCore;
using ZEN_Yoga.Models;
using ZEN_Yoga.Models.Requests;
using ZEN_Yoga.Models.Responses;
using ZEN_Yoga.Models.SearchObjects;
using ZEN_Yoga.Services.Interfaces.YogaType;
using static Microsoft.EntityFrameworkCore.DbLoggerCategory;

namespace ZEN_Yoga.Services.Services.YogaType
{
    public class GetYogaTypeService : IGetYogaTypeService
    {
        private readonly ZenYogaDbContext _dbContext;
        private readonly IMapper _mapper;

        public GetYogaTypeService(ZenYogaDbContext dbContext, IMapper mapper)
        {
            _dbContext = dbContext;
            _mapper = mapper;
        }

        public async Task<PagedResponse<YogaTypeResponse>> GetAll(PagedRequest request)
        {
            var query = _dbContext.YogaTypes
                                  .AsNoTracking()
                                  .OrderByDescending(r => r.Id);

            var totalCount = await query.CountAsync();

            var yogaTypes = await query
                .Skip((request.Page - 1) * request.PageSize)
                .Take(request.PageSize)
                .ToListAsync();

            return new PagedResponse<YogaTypeResponse>
            {
                Items = _mapper.Map<List<YogaTypeResponse>>(yogaTypes),
                TotalCount = totalCount,
                Page = request.Page,
                PageSize = request.PageSize
            };
        }

        public async Task<YogaTypeResponse> GetById(int id)
        {
            var type = await _dbContext.YogaTypes.AsNoTracking().FirstOrDefaultAsync(t => t.Id == id);

            return _mapper.Map<YogaTypeResponse>(type);
        }

        public async Task<PagedResponse<YogaTypeResponse>> GetYogaTypesQuery(YogaTypeQuery yogaTypeQuery, PagedRequest request)
        {
            IQueryable<ZEN_Yoga.Models.YogaType> yogaTypes = _dbContext.YogaTypes.AsNoTracking().AsQueryable();

            if (!string.IsNullOrWhiteSpace(yogaTypeQuery.Search))
            {
                var search = yogaTypeQuery.Search.ToLower();

                yogaTypes = yogaTypes.Where(u =>
                    u.Name.ToLower().Contains(search) ||
                    u.Description!.ToLower().Contains(search) 
                    
                );

               var results = await yogaTypes
               .Skip((request.Page - 1) * request.PageSize)
               .Take(request.PageSize)
               .ToListAsync();

                

            }
            var totalCount = await yogaTypes.CountAsync();

            return new PagedResponse<YogaTypeResponse>
            {
                Items = _mapper.Map<List<YogaTypeResponse>>(yogaTypes),
                TotalCount = totalCount,
                Page = request.Page,
                PageSize = request.PageSize
            };

        }
    }
}
