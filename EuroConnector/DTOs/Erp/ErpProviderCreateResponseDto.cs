using EuroConnector.API.DTOs.Entities;

namespace EuroConnector.API.DTOs.Erp
{
    public class ErpProviderCreateResponseDto: ErpProviderBaseDto
    {
        public CompanyInfoDto Entity { get; set; } = new();
    }
}
