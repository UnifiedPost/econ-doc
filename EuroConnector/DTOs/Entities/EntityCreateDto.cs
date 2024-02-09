using EuroConnector.API.DTOs.PeppolServices;
using EuroConnector.API.DTOs.Users;

namespace EuroConnector.API.DTOs.Entities
{
    public class EntityCreateDto
    {
        public UserCreateResponseDto UserInfo { get; set; } = new();
        public PeppolServiceFullDto PeppolService { get; set; } = new();
        public EntityFullDto EntityInfo { get; set; } = new();
    }
}
