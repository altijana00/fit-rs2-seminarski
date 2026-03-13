using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ZEN_Yoga.Models.Requests;
using ZEN_Yoga.Services.Interfaces.Base;

namespace ZEN_Yoga.Services.Interfaces.Role
{
    public interface IUpsertRoleService<TEntity> : IUpsertService<EditRole> where TEntity : class
    {
        Task Add(AddRole addRole);
    }
}
