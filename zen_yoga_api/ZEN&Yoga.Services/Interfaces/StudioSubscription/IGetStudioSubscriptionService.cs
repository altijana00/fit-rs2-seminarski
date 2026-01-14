using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ZEN_Yoga.Models;
using ZEN_Yoga.Models.Responses;
using ZEN_Yoga.Services.Interfaces.Base;
using ZEN_Yoga.Services.Services.StudioSubscription;

namespace ZEN_Yoga.Services.Interfaces.StudioSubscription
{
    public interface IGetStudioSubscriptionService : IGetService<Models.StudioSubscription, StudioSubscriptionResponse>
    {
    }
}
