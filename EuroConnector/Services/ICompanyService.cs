using EuroConnector.API.DTOs.Entities;
using EuroConnector.API.Infrastructure.Objects;

namespace EuroConnector.API.Services
{
    public interface ICompanyService
    {
        Task<CompanyInfoDto> CreateCompany(CompanyCreateRequestDto company);
        Task<Result<EntityEditResponseDto>> EditEntity(Guid entityId, Guid connectedErpProviderId, EntityEditRequestDto request);
        Task<Result<EntityDeleteResponseDto>> DeleteEntity(Guid entityId, Guid connectedErpProviderId);
        Task<CompanyInfoDto> GetCompanyById(Guid id);
        Task<EntityInfoDto> GetCompanyById(Guid id, Guid connectedErpProviderId);
        Task<Result<EntitySearchResponse>> SearchForEntity(EntitySearchRequest request, Guid connectedErpProviderId);
		Task<Result<EntityKeyUpdateResponseDto>> UpdateEntitySecretKey(Guid id, Guid connectedErpProviderId);
    }
}