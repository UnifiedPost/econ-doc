namespace EuroConnector.API.DTOs.Entities
{
    public class EntityFullDto: EntityBaseDto
    {
        public Guid EntityId { get; set; }
        public bool IsEnabled { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime UpdatedAt { get; set; }
    }
}
