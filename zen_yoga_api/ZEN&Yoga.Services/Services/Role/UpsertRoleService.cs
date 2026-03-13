using AutoMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ZEN_Yoga.Models.Requests;
using ZEN_Yoga.Models;
using ZEN_Yoga.Services.Interfaces.YogaType;
using ZEN_Yoga.Services.Interfaces.Role;
using Microsoft.EntityFrameworkCore;

namespace ZEN_Yoga.Services.Services.Role
{
    public class UpsertRoleService : IUpsertRoleService<AddRole>
    {
        private readonly IMapper _mapper;
        private readonly ZenYogaDbContext _dbContext;


        public UpsertRoleService(IMapper mapper, ZenYogaDbContext dbContext)
        {
            _dbContext = dbContext;
            _mapper = mapper;

        }

        public async Task Add(AddRole addRole)
        {
            var role = _mapper.Map<Models.Role>(addRole);

            await _dbContext.Roles.AddAsync(role);

            await _dbContext.SaveChangesAsync();
        }

        public async Task Edit(EditRole editRole, int id)
        {
            var role = await _dbContext.Roles.FirstOrDefaultAsync(u => u.Id == id);

            if (role != null)
            {
                _mapper.Map(editRole, role);

                await _dbContext.SaveChangesAsync();
            }
        }
    }
}
