using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ZEN_Yoga.Models.Requests;
using ZEN_Yoga.Services.Interfaces.Base;

namespace ZEN_Yoga.Services.Interfaces.YogaType
{
    public interface IUpsertYogaTypeService<TEntity> : IUpsertService<EditYogaType> where TEntity : class
    {
        Task Add(AddYogaType addYogaType);
    }
}
