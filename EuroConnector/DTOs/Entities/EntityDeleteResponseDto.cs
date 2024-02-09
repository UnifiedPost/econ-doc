namespace EuroConnector.API.DTOs.Entities
{
    public class EntityDeleteResponseDto
    {
        public EntityDeleteResponseDto(Guid entityId) 
        {
            Message = $"The Entity {entityId} was deleted successfully";
        }

        public int StatusCode { get; set; } = 200;
        public string Message { get; set; } = "";
    }
}
