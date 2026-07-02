using AutoMapper;
using Microsoft.EntityFrameworkCore;
using ZEN_Yoga.Models;
using ZEN_Yoga.Models.Helpers;
using ZEN_Yoga.Models.Requests;
using ZEN_Yoga.Models.Responses;
using ZEN_Yoga.Models.SearchObjects;
using ZEN_Yoga.Services.Interfaces.User;

namespace ZEN_Yoga.Services.Services.User
{
    public class GetUserService : IGetUserService
    {

        private readonly IMapper _mapper;
        private readonly ZenYogaDbContext _dbContext;

        public GetUserService(IMapper mapper, ZenYogaDbContext dbContext)
        {
            _mapper = mapper;
            _dbContext = dbContext;

        }

        public async Task<PagedResponse<UserResponse>> GetAll(PagedRequest request) 
        {
            var query = _dbContext.Users
                      .AsNoTracking()
                      .OrderByDescending(r => r.Id);

            var totalCount = await query.CountAsync();

            var result = await query
                .Skip((request.Page - 1) * request.PageSize)
                .Take(request.PageSize)
                .ToListAsync();

            return new PagedResponse<UserResponse>
            {
                Items = _mapper.Map<List<UserResponse>>(result),
                TotalCount = totalCount,
                Page = request.Page,
                PageSize = request.PageSize
            };
        }

        public async Task<PagedResponse<UserResponse>> GetUsersQuery(UserQuery userQuery, PagedRequest request)
        { 
            IQueryable<ZEN_Yoga.Models.User> query = _dbContext.Users.AsNoTracking().AsQueryable();

            if(!string.IsNullOrWhiteSpace(userQuery.Search))
            {
                var search = userQuery.Search.ToLower();

                query = query.Where(u =>
                    u.FirstName.ToLower().Contains(search) ||
                    u.LastName.ToLower().Contains(search) ||
                    u.Email.ToLower().Contains(search)
                );          
            }

            if (userQuery.RoleId.HasValue)
            {
                query = query.Where(u => u.RoleId == userQuery.RoleId);
            }

            if (userQuery.CityId.HasValue)
            {
                query = query.Where(u => u.CityId == userQuery.CityId);
            }

            query = query.OrderByDescending(c => c.Id);
            var totalCount = await query.CountAsync();

            var results = await query
               .Skip((request.Page - 1) * request.PageSize)
               .Take(request.PageSize)
               .ToListAsync();


            return new PagedResponse<UserResponse>
            {
                Items = _mapper.Map<List<UserResponse>>(results),
                TotalCount = totalCount,
                Page = request.Page,
                PageSize = request.PageSize
            };
        }

        public async Task<UserResponse> GetByEmail(string email)
        {
            var user = await _dbContext.Users.AsNoTracking().
                FirstOrDefaultAsync(u => u.Email == email);
            return _mapper.Map<UserResponse>(user);
        }

        public async Task<UserResponse> GetByEmailandPassword(string email, string password)
        {
            var user = await _dbContext.Users.AsNoTracking().
                   FirstOrDefaultAsync(u => u.Email == email && u.PasswordHash == PasswordHelpers.HashPassword(password).Hash);
            return _mapper.Map<UserResponse>(user);
        }

        public async Task<UserResponse> GetById(int id)
        {
            var user = await _dbContext.Users.AsNoTracking().
                FirstOrDefaultAsync(u => u.Id == id);


            return _mapper.Map<UserResponse>(user);


        }

        public async Task<List<UserResponse>> GetAdminUsers(int roleId) 
        {
            var users = await _dbContext.Users.AsNoTracking().Where(u => u.RoleId == roleId).ToListAsync();

            return _mapper.Map<List<UserResponse>>(users).OrderByDescending(u => u.Id).ToList();
        }
    }
}
