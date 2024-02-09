using EuroConnector.API.DTOs.PeppolServices;
using EuroConnector.API.DTOs.Users;

namespace EuroConnector.API.DTOs.Entities
{
    public class CompanyInfoDto: EntityFullDto
    {
        public ICollection<UserDto> Users { get; set; } = new List<UserDto>();
        public ICollection<PeppolServiceDto> PeppolServices { get; set; } = new List<PeppolServiceDto>();
    }
}
