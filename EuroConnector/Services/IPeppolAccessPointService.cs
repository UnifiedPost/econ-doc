using EuroConnector.API.DTOs.Entities;
using EuroConnector.API.DTOs.Erp;
using EuroConnector.API.DTOs.PeppolServices;
using EuroConnector.API.DTOs.PeppolServices.PeppolAccessPoint;
using EuroConnector.API.Infrastructure.Objects;

namespace EuroConnector.API.Services
{
    public interface IPeppolAccessPointService
    {
        // Access Points

        // Access Point Users
        Task<Result<PeppolUserCreateResponseDto>> CreatePeppolAccessPointUser(string userName, string peppolAccessPointName, bool isEnabled);

        // Services
        //Task<PeppolServiceCreateResponseDto> CreatePeppolServiceByErp(EntityDto entity,Guid erpProviderId);
        //Task<PeppolServiceDto> UpdatePeppolService(PeppolServiceCreateResponseDto peppolService, EntityCrossnetCreateResponseDto crossnetResponse);
        Task<Result<EntityCreateResponseDto>> OnboardNewEntity(EntityDto entity, Guid erpProviderId);
        Task<Result<EntityLookupResponseDto>> PeppolLookup(string participantId);
    }
}