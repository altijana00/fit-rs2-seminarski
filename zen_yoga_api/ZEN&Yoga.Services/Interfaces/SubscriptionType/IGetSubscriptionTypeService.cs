using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ZEN_Yoga.Models;
using ZEN_Yoga.Models.Responses;
using ZEN_Yoga.Services.Interfaces.Base;

namespace ZEN_Yoga.Services.Interfaces.SubscriptionType
{
    public interface IGetSubscriptionTypeService : IGetService<Models.SubscriptionType, SubscriptionTypeResponse>
    {

    }
}
