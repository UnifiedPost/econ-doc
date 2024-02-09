namespace EuroConnector.API.DTOs.Entities
{
    public class EntityEditRequestDto
    {
        public EntityEditDto EntityInfo { get; set; } = default!;
    }

    public class EntityEditDto
    {
        public string? EntityName { get; set; } = default!;
        public string? EmailAddress { get; set; } = default!;
        public string? Street { get; set; } = default!;
        public string? Locality { get; set; } = default!;
        public string? Municipality { get; set; } = default!;
        public string? PostalCode { get; set; } = default!;
        public bool? IsEnabled { get; set; }
    }

}
