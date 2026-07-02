using AutoMapper;
using Microsoft.EntityFrameworkCore;
using ZEN_Yoga.Models;
using ZEN_Yoga.Models.Requests;
using ZEN_Yoga.Models.Responses;
using ZEN_Yoga.Models.SearchObjects;
using ZEN_Yoga.Services.Interfaces.Role;
using static Microsoft.EntityFrameworkCore.DbLoggerCategory;

namespace ZEN_Yoga.Services.Services.Role
{
    public class GetRoleService : IGetRoleService
    {
        private readonly ZenYogaDbContext _dbContext;
        private readonly IMapper _mapper;

        public GetRoleService(ZenYogaDbContext dbContext, IMapper mapper)
        {
            _dbContext = dbContext;
            _mapper = mapper;
        }

        public async Task<PagedResponse<RoleResponse>> GetAll(PagedRequest request)
        {
            var query = _dbContext.Roles
                      .AsNoTracking()
                      .OrderByDescending(r => r.Id);

            var totalCount = await query.CountAsync();

            var result = await query
                .Skip((request.Page - 1) * request.PageSize)
                .Take(request.PageSize)
                .ToListAsync();

            return new PagedResponse<RoleResponse>
            {
                Items = _mapper.Map<List<RoleResponse>>(result),
                TotalCount = totalCount,
                Page = request.Page,
                PageSize = request.PageSize
            };
        }

        public async Task<RoleResponse> GetById(int id)
        {
            var role = await _dbContext.Roles.AsNoTracking().FirstOrDefaultAsync(r => r.Id == id);
            return _mapper.Map<RoleResponse>(role);
        }

        public async Task<PagedResponse<RoleResponse>> GetRolesQuery(RoleQuery roleQuery, PagedRequest request)
        {
            IQueryable<ZEN_Yoga.Models.Role> query = _dbContext.Roles.AsNoTracking().AsQueryable();

            if (!string.IsNullOrWhiteSpace(roleQuery.Search))
            {
                var search = roleQuery.Search.ToLower();

                query = query.Where(u =>
                    u.Name.ToLower().Contains(search) ||
                    u.Description!.ToLower().Contains(search)

                );
            }

            query = query.OrderByDescending(c => c.Id);
            var totalCount = await query.CountAsync();

            var results = await query
               .Skip((request.Page - 1) * request.PageSize)
               .Take(request.PageSize)
               .ToListAsync();


            return new PagedResponse<RoleResponse>
            {
                Items = _mapper.Map<List<RoleResponse>>(results),
                TotalCount = totalCount,
                Page = request.Page,
                PageSize = request.PageSize
            };

        }

    }
}
