using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ZEN_Yoga.Models;

namespace ZEN_Yoga.Services.Interfaces.Analytics
{
    public interface IAppAnalyticsService
    {
        Task<AppAnalytics> GetAppAnalytics();
    }
}
