using EuroConnector.Data.Models;

namespace EuroConnector.API.DTOs.Users
{
    public class UserDto
    {
        public Guid UserId { get; set; }
        public string EmailAddress { get; set; } = default!;
        public string UserName { get; set; } = default!;
        public ICollection<RolesType> Roles { get; set; } = new List<RolesType>();
        public string? FirstName { get; set; }
        public string? LastName { get; set; }
        public bool IsEnabled { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime UpdatedAt { get; set; }
        public Guid? CompanyId { get; set; }
        public Guid? ErpProviderId { get; set; }
    }
}
