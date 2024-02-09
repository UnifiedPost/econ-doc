using EuroConnector.API.DTOs.Entities;
using EuroConnector.API.DTOs.Erp;

namespace EuroConnector.API.Services
{
    public interface IErpProviderService
    {
        Task<ErpProviderInfoDto> GetErpProviderById(Guid id);
        Task<ErpProviderInfoDto> GetErpProviderByUserId(Guid userId);
        Task<ErpProviderCreateResponseDto> CreateErpProvider(CompanyCreateRequestDto entity);
        Task<ErpResponseDto> CreateErpProvider(ErpCreateRequestDto erp);
    }
}