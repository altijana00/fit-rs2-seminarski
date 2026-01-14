using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ZEN_Yoga.Services.Interfaces.UserStudio
{
    public interface IUpsertUserStudioService
    {
        public Task<bool> Add(int userId, int studioId, int subscriptionTypeId);
    }
}
