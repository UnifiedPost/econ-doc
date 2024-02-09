namespace EuroConnector.API.DTOs.PeppolServices
{
    public class PeppolServiceFullDto: PeppolServiceBaseDto
    {
        public Guid PeppolServiceId { get; set; }
        public Guid? CompanyId { get; set; }
        public bool IsEnabled { get; set; } = false;
        public DateTime CreatedAt { get; set; }
        public DateTime UpdatedAt { get; set; }
    }
}
