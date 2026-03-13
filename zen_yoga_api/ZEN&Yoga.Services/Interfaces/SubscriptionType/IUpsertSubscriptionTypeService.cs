using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ZEN_Yoga.Models.Requests;
using ZEN_Yoga.Services.Interfaces.Base;

namespace ZEN_Yoga.Services.Interfaces.SubscriptionType
{
    public interface IUpsertSubscriptionTypeService<TEntity> : IUpsertService<EditSubscriptionType> where TEntity : class
    {
        Task Add(AddSubscriptionType addSubscriptionType);
    }
}
