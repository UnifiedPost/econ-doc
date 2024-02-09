namespace EuroConnector.API.DTOs.Documents
{
    public class DocumentSearchResponse
    {
        public List<DocumentCustomFieldsDto> Documents { get; set; } = new List<DocumentCustomFieldsDto>();
    }
}
