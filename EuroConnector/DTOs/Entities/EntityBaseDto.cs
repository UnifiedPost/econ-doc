namespace EuroConnector.API.DTOs.Entities
{
    public class EntityBaseDto
    {
        public string EntityCode { get; set; } = default!;
        public string? VatNumber { get; set; }
        public string EntityName { get; set; } = default!;
        public string EmailAddress { get; set; } = default!;
        public string? PhoneNumber { get; set; } = default!;
        public string? Street { get; set; }
        public string? Locality { get; set; }
        public string? Municipality { get; set; }
        public string? PostalCode { get; set; }
        public string CountryCode { get; set; } = default!;
    }
}
