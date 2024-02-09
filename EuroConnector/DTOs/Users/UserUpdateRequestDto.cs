using System.ComponentModel.DataAnnotations;

namespace EuroConnector.API.DTOs.Users
{
    public class UserUpdateRequestDto:UserBaseRequestDto
    {
        public Guid? CompanyId { get; set; }
        public Guid? ErpProviderId { get; set; }
        public Guid? PapUserId { get; set; }
        public bool? IsEnabled { get; set; }
    }
}
