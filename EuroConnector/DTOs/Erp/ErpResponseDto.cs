using EuroConnector.API.DTOs.Entities;
using EuroConnector.API.DTOs.Users;

namespace EuroConnector.API.DTOs.Erp
{
    public class ErpResponseDto
    {
        public ErpProviderCreateResponseDto ErpProviderInfo { get; set; } = new();
        public UserCreateResponseDto UserInfo { get; set; } = new();
    }
}
