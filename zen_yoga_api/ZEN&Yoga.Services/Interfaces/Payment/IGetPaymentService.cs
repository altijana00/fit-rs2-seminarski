using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ZEN_Yoga.Models.Responses;
using ZEN_Yoga.Models.SearchObjects;
using ZEN_Yoga.Services.Interfaces.Base;

namespace ZEN_Yoga.Services.Interfaces.Payment
{
    public interface IGetPaymentService : IGetService<Models.Payment, PaymentResponse>
    {
        Task<List<PaymentResponse>> GetPaymentsQuery(PaymentQuery paymentQuery);

        Task<decimal> GetPaymentsTotal();
        Task<List<PaymentResponse>> GetUserPayments(int userId);

        Task<List<PaymentResponse>> GetPaymentsOfOwnerStudios(int ownerId);


    }
}
