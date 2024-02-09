using AutoMapper;
using EuroConnector.API.DTOs.Tokens;
using EuroConnector.API.DTOs.Users;
using EuroConnector.API.Infrastructure.Objects;
using EuroConnector.API.UOW;
using EuroConnector.Data.Contract;
using ValueHasher;
using ILogger = Serilog.ILogger;

namespace EuroConnector.API.Services
{
    public class UserService : IUserService
    {
        private readonly IUserRepository _userRepo;
        private readonly IRoleRepository _roleRepo;
        private readonly IUserSecretRepository _userSecretRepo;
        private readonly IMapper _mapper;
        private readonly IValueHasher _valueHasher;
        private readonly ILogger _logger;
        private readonly UserUnitOfWork _userUnitOfWork;

        public UserService(
            IUserRepository userRepo,
            IRoleRepository roleRepo,
            IUserSecretRepository userSecretRepo,
            IMapper mapper,
            IValueHasher valueHasher,
            ILogger logger,
            UserUnitOfWork userUnitOfWork)
        {
            _userRepo = userRepo;
            _roleRepo = roleRepo;
            _userSecretRepo = userSecretRepo;
            _mapper = mapper;
            _valueHasher = valueHasher;
            _logger = logger;
            _userUnitOfWork = userUnitOfWork;
        }

        public Task<UserCreateResponseDto> CreateUser(UserCreateRequestDto user)
        {
            throw new NotImplementedException();
        }

        public Task<UserCreateResponseDto> CreateUserForEntity(UserBaseRequestDto entity, Guid companyId, Guid erpProviderId)
        {
            throw new NotImplementedException();
        }

        public Task<UserCreateResponseDto> CreateUserForErp(UserBaseRequestDto entity, Guid companyId)
        {
            throw new NotImplementedException();
        }

        public string CreateUserSecret(Guid userId)
        {
            throw new NotImplementedException();
        }

        public Task<Guid?> GetConnectedErpProviderId(Guid userId)
        {
            throw new NotImplementedException();
        }

        public Task<UserDto> GetUserByErpAndCompanyId(Guid companyId, Guid erpProviderId)
        {
            throw new NotImplementedException();
        }

        public Task<UserDto> GetUserById(Guid id)
        {
            throw new NotImplementedException();
        }

        public Task<Result<UserDto?>> GetUserViaAuthentication(TokenRequestDto tokenRequest)
        {
            throw new NotImplementedException();
        }

        public Task<UserDto> GetUserWithRoles(Guid id)
        {
            throw new NotImplementedException();
        }

        public Task UpdateUser(Guid userId, UserUpdateRequestDto user)
        {
            throw new NotImplementedException();
        }

        public Task<Result<UserValidationResultDto>> UserIsValid(Guid userId)
        {
            throw new NotImplementedException();
        }
    }
}
