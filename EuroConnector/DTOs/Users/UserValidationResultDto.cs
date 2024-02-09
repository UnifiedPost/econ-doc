namespace EuroConnector.API.DTOs.Users
{
    public class UserValidationResultDto
    {
        public Guid CompanyId { get; set; }
        public string? CompanyIdExt { get; set; }
        public bool IsCompanyEnabled { get; set; }
        public Guid AccessPointId { get; set; }
        public bool IsAccessPointEnabled { get; set; }
        public string? AccessPointCode { get; set; }
    }
}
