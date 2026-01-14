using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ZEN_Yoga.Services.Interfaces.SubscriptionType
{
    public interface ISubscriptionTypeValidatorService
    {
        Task<bool> ValidateSubscriptionTypeId(int id);
    }
}
