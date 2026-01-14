using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ZEN_Yoga.Models.Requests;
using ZEN_Yoga.Services.Interfaces.Base;

namespace ZEN_Yoga.Services.Interfaces.StudioSubscription
{
    public interface IUpsertStudioSubscriptionService<TEntity> : IUpsertService<EditSubscription> where TEntity : class
    {
        Task<bool> Add(int studioId, int subscriptionTypeId, AddStudioSubscription addStudioSubscription);
    }
}
