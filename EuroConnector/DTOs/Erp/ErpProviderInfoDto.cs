using EuroConnector.API.DTOs.Entities;

namespace EuroConnector.API.DTOs.Erp
{
    public class ErpProviderInfoDto: ErpProviderFullDto
    {
        public CompanyInfoDto EntityInfo { get; set; } = new();
    }
}
