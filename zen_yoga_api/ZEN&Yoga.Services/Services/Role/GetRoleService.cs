using AutoMapper;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ZEN_Yoga.Models;
using ZEN_Yoga.Models.Responses;
using ZEN_Yoga.Services.Interfaces.Role;

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

        public async Task<List<RoleResponse>> GetAll()
        {
            var roles = await _dbContext.Roles.ToListAsync();
            return _mapper.Map<List<RoleResponse>>(roles);
        }

        public async Task<RoleResponse> GetById(int id)
        {
            var role = await _dbContext.Roles.FirstOrDefaultAsync(r => r.Id == id);
            return _mapper.Map<RoleResponse>(role);
        }


    }
}
