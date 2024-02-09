using AutoMapper;
using EuroConnector.API.Clients;
using EuroConnector.API.DTOs.Entities;
using EuroConnector.API.Infrastructure.Objects;
using EuroConnector.API.UOW;
using EuroConnector.Data.Contract;
using ILogger = Serilog.ILogger;

namespace EuroConnector.API.Services
{
	public class CompanyService : ICompanyService
	{
		private readonly UserUnitOfWork _userUnitOfWork;
		private readonly IMapper _mapper;
		private readonly ILogger _logger;
		private readonly EntityUnitOfWork _entityUnitOfWork;
		private readonly IDxGatewayClient _dxGatewayClient;

		public CompanyService(ICompanyRepository companyRepo,
			UserUnitOfWork userUnitOfWork,
			EntityUnitOfWork entityUnitOfWork,
			IMapper mapper,
			ILogger logger,
			IDxGatewayClient dxGatewayClient)
		{
			_userUnitOfWork = userUnitOfWork;
			_mapper = mapper;
			_logger = logger;
			_entityUnitOfWork = entityUnitOfWork;
			_dxGatewayClient = dxGatewayClient;
		}

        public Task<CompanyInfoDto> CreateCompany(CompanyCreateRequestDto company)
        {
            throw new NotImplementedException();
        }

        public Task<Result<EntityDeleteResponseDto>> DeleteEntity(Guid entityId, Guid connectedErpProviderId)
        {
            throw new NotImplementedException();
        }

        public Task<Result<EntityEditResponseDto>> EditEntity(Guid entityId, Guid connectedErpProviderId, EntityEditRequestDto request)
        {
            throw new NotImplementedException();
        }

        public Task<CompanyInfoDto> GetCompanyById(Guid id)
        {
            throw new NotImplementedException();
        }

        public Task<EntityInfoDto> GetCompanyById(Guid id, Guid connectedErpProviderId)
        {
            throw new NotImplementedException();
        }

        public Task<Result<EntitySearchResponse>> SearchForEntity(EntitySearchRequest request, Guid connectedErpProviderId)
        {
            throw new NotImplementedException();
        }

        public Task<Result<EntityKeyUpdateResponseDto>> UpdateEntitySecretKey(Guid id, Guid connectedErpProviderId)
        {
            throw new NotImplementedException();
        }
    }
}
