using AutoMapper;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ZEN_Yoga.Models;
using ZEN_Yoga.Models.Exceptions;
using ZEN_Yoga.Models.Helpers;
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

        public async Task<List<UserResponse>> GetAll() 
        { 
            var users = await _dbContext.Users.ToListAsync(); 
            
            return _mapper.Map<List<UserResponse>>(users); 
        }

        public async Task<List<UserResponse>> GetUsersQuery(UserQuery userQuery)
        { 
            IQueryable<ZEN_Yoga.Models.User> users = _dbContext.Users.AsQueryable();

            if(!string.IsNullOrWhiteSpace(userQuery.Search))
            {
                var search = userQuery.Search.ToLower();

                users = users.Where(u =>
                    u.FirstName.ToLower().Contains(search) ||
                    u.LastName.ToLower().Contains(search) ||
                    u.Email.ToLower().Contains(search)
                );          
            }

            if (userQuery.RoleId.HasValue)
            {
                users = users.Where(u => u.RoleId == userQuery.RoleId);
            }

            if (userQuery.CityId.HasValue)
            {
                users = users.Where(u => u.CityId == userQuery.CityId);
            }

            var result = await users.ToListAsync();
            return _mapper.Map<List<UserResponse>>(result);
        }

        public async Task<UserResponse> GetByEmail(string email)
        {
            var user = await _dbContext.Users.
                FirstOrDefaultAsync(u => u.Email == email);
            return _mapper.Map<UserResponse>(user);
        }

        public async Task<UserResponse> GetByEmailandPassword(string email, string password)
        {
            var user = await _dbContext.Users.
                   FirstOrDefaultAsync(u => u.Email == email && u.PasswordHash == PasswordHelpers.HashPassword(password).Hash);
            return _mapper.Map<UserResponse>(user);
        }

        public async Task<UserResponse> GetById(int id)
        {
            var user = await _dbContext.Users.
                FirstOrDefaultAsync(u => u.Id == id);


            return _mapper.Map<UserResponse>(user);


        }
    }
}
