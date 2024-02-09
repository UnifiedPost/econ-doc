using AutoMapper;
using EuroConnector.API.DTOs.Entities;
using EuroConnector.API.Infrastructure.Objects;
using EuroConnector.API.DTOs.PeppolServices.PeppolAccessPoint;
using EuroConnector.API.UOW;
using EuroConnector.Data.Contract;
using ValueHasher;
using ILogger = Serilog.ILogger;
using EuroConnector.API.Clients;

namespace EuroConnector.API.Services
{
    public class PeppolAccessPointService : IPeppolAccessPointService
    {
        private readonly IPeppolAccessPointRepository _peppolAccessPointRepo;
        private readonly IPeppolAccessPointUserRepository _peppolAccessPointUserRepo;
        private readonly IPeppolServiceRepository _peppolServiceRepo;
        private readonly IPeppolUserSecretRepository _peppolUserSecretRepo;
        private readonly IUserRepository _userRepo;
        private readonly ICompanyRepository _companyRepo;
        private readonly IPeppolLookupClient _peppolLookupClient;
        private readonly IValueHasher _valueHasher;
        private readonly IMapper _mapper;
        private readonly ILogger _logger;
        private readonly EntityUnitOfWork _entityUnitOfWork;
        private readonly UserUnitOfWork _userUnitOfWork;

        public PeppolAccessPointService(
            IPeppolAccessPointRepository peppolAccessPointRepo, 
            IPeppolAccessPointUserRepository peppolAccessPointUserRepo,
            IPeppolServiceRepository peppolServiceRepo, 
            IPeppolUserSecretRepository peppolUserSecretRepo, 
            ICompanyRepository companyRepo,
            IUserRepository userRepo,
            IPeppolLookupClient peppolLookupClient,
            IValueHasher valueHasher, 
            IMapper mapper, 
            ILogger logger,
            EntityUnitOfWork entityUnitOfWork,
            UserUnitOfWork userUnitOfWork)
        {
            _peppolAccessPointRepo = peppolAccessPointRepo;
            _peppolAccessPointUserRepo = peppolAccessPointUserRepo;
            _peppolServiceRepo = peppolServiceRepo;
            _peppolUserSecretRepo = peppolUserSecretRepo;
            _companyRepo = companyRepo;
            _userRepo = userRepo;
            _peppolLookupClient = peppolLookupClient;
            _valueHasher = valueHasher;
            _mapper = mapper;
            _logger = logger;
            _entityUnitOfWork = entityUnitOfWork;
            _userUnitOfWork = userUnitOfWork;
        }

        public Task<Result<PeppolUserCreateResponseDto>> CreatePeppolAccessPointUser(string userName, string peppolAccessPointName, bool isEnabled)
        {
            throw new NotImplementedException();
        }

        public Task<Result<EntityCreateResponseDto>> OnboardNewEntity(EntityDto entity, Guid erpProviderId)
        {
            throw new NotImplementedException();
        }

        public Task<Result<EntityLookupResponseDto>> PeppolLookup(string participantId)
        {
            throw new NotImplementedException();
        }
    }
}
