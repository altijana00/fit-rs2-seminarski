using AutoMapper;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ZEN_Yoga.Models;
using ZEN_Yoga.Models.Exceptions;
using ZEN_Yoga.Services.Interfaces.Role;

namespace ZEN_Yoga.Services.Services.Role
{
    public class RoleValidatorService : IRoleValidatorService
    {
        private readonly ZenYogaDbContext _dbContext;


        public RoleValidatorService(ZenYogaDbContext dbContext)
        {
            _dbContext = dbContext;

        }

        public async Task<bool> ValidateRoleId(int id)
        {
            var role = await _dbContext.Roles.FirstOrDefaultAsync(r => r.Id == id);

            if (role == null) 
            {
                throw new RoleNotFoundException("Invalid role!");

            }

            return true;
        }
    }
}
