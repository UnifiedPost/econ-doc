namespace EuroConnector.API.DTOs.Entities
{
    public class EntitySearchRequest
    {
        public Guid? EntityId { get; set; }
        public string? EntityCode { get; set; }
        public string? VatNumber { get; set; }
        public string? EntityName { get; set; }
        public string? EmailAddress { get; set; }
        public string? PhoneNumber { get; set; }
        public string? Street { get; set; }
        public string? Locality { get; set; }
        public string? Municipality { get; set; }
        public string? PostalCode { get; set; }
        public string? CountryCode { get; set; }
        public int RecordsCountLimit { get; set; } = 100;

    }
}
