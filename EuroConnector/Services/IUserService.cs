using EuroConnector.API.DTOs.Tokens;
using EuroConnector.API.DTOs.Users;
using EuroConnector.API.Infrastructure.Objects;

namespace EuroConnector.API.Services
{
    public interface IUserService
    {
        Task<Result<UserDto?>> GetUserViaAuthentication(TokenRequestDto tokenRequest);
        Task<Guid?> GetConnectedErpProviderId(Guid userId);
        Task<UserDto> GetUserById(Guid id);
        Task<UserDto> GetUserWithRoles(Guid id);
        Task<UserDto> GetUserByErpAndCompanyId(Guid companyId, Guid erpProviderId);
        Task<UserCreateResponseDto> CreateUser(UserCreateRequestDto user);
        Task<UserCreateResponseDto> CreateUserForEntity(UserBaseRequestDto entity, Guid companyId, Guid erpProviderId);
        Task<UserCreateResponseDto> CreateUserForErp(UserBaseRequestDto entity, Guid companyId);
        string CreateUserSecret(Guid userId);
        Task UpdateUser(Guid userId, UserUpdateRequestDto user);
        Task<Result<UserValidationResultDto>> UserIsValid(Guid userId);
    }
}
