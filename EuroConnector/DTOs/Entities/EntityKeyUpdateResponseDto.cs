namespace EuroConnector.API.DTOs.Entities
{
    public class EntityKeyUpdateResponseDto
    {
        public IEnumerable<EntityCreateResponseObj> Entities { get; set; } = new List<EntityCreateResponseObj>();
    }
}
