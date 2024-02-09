namespace EuroConnector.API.DTOs.Erp
{
    public class ErpProviderBaseDto
    {
        public Guid ErpProviderId { get; set; }
        public bool IsEnabled { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime UpdatedAt { get; set; }
    }
}
