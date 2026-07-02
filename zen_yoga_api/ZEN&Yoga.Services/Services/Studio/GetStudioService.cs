using AutoMapper;
using Microsoft.EntityFrameworkCore;
using ZEN_Yoga.Models;
using ZEN_Yoga.Models.Requests;
using ZEN_Yoga.Models.Responses;
using ZEN_Yoga.Models.SearchObjects;
using ZEN_Yoga.Services.Interfaces.Studio;

namespace ZEN_Yoga.Services.Services.Studio
{
    public class GetStudioService : IGetStudioService
    {
        private readonly IMapper _mapper;
        private readonly ZenYogaDbContext _dbContext;

        public GetStudioService(IMapper mapper, ZenYogaDbContext dbContext)
        {
            _dbContext = dbContext;
            _mapper = mapper;
        }
        public async Task<PagedResponse<StudioResponse>> GetAll(PagedRequest request)
        {
            var query = _dbContext.Studios
                                 .AsNoTracking()
                                 .OrderByDescending(r => r.Id);

            var totalCount = await query.CountAsync();

            var result = await query
                .Skip((request.Page - 1) * request.PageSize)
                .Take(request.PageSize)
                .ToListAsync();

            return new PagedResponse<StudioResponse>
            {
                Items = _mapper.Map<List<StudioResponse>>(result),
                TotalCount = totalCount,
                Page = request.Page,
                PageSize = request.PageSize
            };
        }

        public async Task<PagedResponse<StudioResponse>> GetStudiosQuery(StudioQuery studioQuery, PagedRequest request)
        {

            IQueryable<ZEN_Yoga.Models.Studio> query = _dbContext.Studios.AsNoTracking().AsQueryable();

            if (!string.IsNullOrWhiteSpace(studioQuery.Search))
            {
                var search = studioQuery.Search.ToLower();

                query = query.Where(s =>
                    s.Name.ToLower().Contains(search) ||
                    s.Address!.ToLower().Contains(search) ||
                    s.ContactEmail!.ToLower().Contains(search) ||
                    s.ContactPhone!.Contains(search)

                );
            }

            if (studioQuery.CityId.HasValue)
            {
                query = query.Where(s => s.CityId == studioQuery.CityId);
            }


            query = query.OrderByDescending(c => c.Id);
            var totalCount = await query.CountAsync();

            var results = await query
               .Skip((request.Page - 1) * request.PageSize)
               .Take(request.PageSize)
               .ToListAsync();


            return new PagedResponse<StudioResponse>
            {
                Items = _mapper.Map<List<StudioResponse>>(results),
                TotalCount = totalCount,
                Page = request.Page,
                PageSize = request.PageSize
            };
        }

        public async Task<List<StudioResponse>> GetByOwner(int ownerId)
        {
            var studios = await _dbContext.Studios.AsNoTracking().Where(s => s.OwnerId == ownerId).ToListAsync();
            return _mapper.Map<List<StudioResponse>>(studios).OrderByDescending(s => s.Id).ToList();
        }

        public async Task<StudioResponse> GetByOwnerAndStudioName(int ownerId, string name)
        {
            var studio = await _dbContext.Studios.AsNoTracking().FirstOrDefaultAsync(s => s.OwnerId == ownerId && s.Name == name);
            return _mapper.Map<StudioResponse>(studio);
        }

        public async Task<StudioResponse> GetById(int id)
        {
            var studio = await _dbContext.Studios.AsNoTracking().FirstOrDefaultAsync(s => s.Id == id);

            return _mapper.Map<StudioResponse>(studio);
        }
    }
}
