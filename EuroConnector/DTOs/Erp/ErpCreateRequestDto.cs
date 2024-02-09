using EuroConnector.API.DTOs.Entities;
using EuroConnector.API.DTOs.Users;

namespace EuroConnector.API.DTOs.Erp
{
    public class ErpCreateRequestDto
    {
        public CompanyCreateRequestDto EntityInfo { get; set; } = new();
        public UserBaseRequestDto UserInfo { get; set; } = new();
    }
}
