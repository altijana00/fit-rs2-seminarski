using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ZEN_Yoga.Services.Interfaces.Payment
{
    public interface IPaymentService
    {
        Task<bool> AddPayment(int userId, int studioId);

        Task<bool> IsUserPaidMember(int userId, int studioId);

    }
}
