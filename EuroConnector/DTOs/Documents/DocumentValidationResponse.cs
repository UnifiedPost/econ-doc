using EuroConnector.Data.Models;

namespace EuroConnector.API.DTOs.Documents
{
    public class DocumentValidationResponse
    {
        public DocumentValidationResponse(DocStandard docStandard) 
        {
            Message = $"{docStandard} document has been validated successfully.";
        }
        public int StatusCode { get; set; } = 200;
        public string Message { get; set; } = "Document has been validated successfully.";

    }
}
