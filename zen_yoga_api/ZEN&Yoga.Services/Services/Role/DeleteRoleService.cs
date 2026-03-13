using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ZEN_Yoga.Models;
using ZEN_Yoga.Services.Interfaces.Role;

namespace ZEN_Yoga.Services.Services.Role
{
    public class DeleteRoleService : IDeleteRoleService
    {
        private readonly ZenYogaDbContext _dbContext;


        public DeleteRoleService(ZenYogaDbContext dbContext)
        {

            _dbContext = dbContext;

        }

        public async Task<bool> Delete(int id)
        {
            var role = await _dbContext.Roles.FirstOrDefaultAsync(u => u.Id == id);

            if (role != null)
            {

                _dbContext.Remove(role);
                await _dbContext.SaveChangesAsync();
                return true;
            }
            return false;
        }
    }
}
