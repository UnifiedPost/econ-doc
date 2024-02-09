using EuroConnector.API.DTOs.PeppolServices;
using EuroConnector.API.DTOs.Users;

namespace EuroConnector.API.DTOs.Entities
{
    public class EntityDto
    {
        public CompanyCreateRequestDto EntityInfo { get; set; } = new();
        public UserBaseRequestDto UserInfo { get; set; } = new();
        public PeppolServiceCreateDto PeppolService { get; set; } = new();
    }
}
