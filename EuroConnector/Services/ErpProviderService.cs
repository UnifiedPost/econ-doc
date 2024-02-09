using AutoMapper;
using EuroConnector.API.DTOs.Entities;
using EuroConnector.API.DTOs.Erp;
using EuroConnector.API.UOW;

namespace EuroConnector.API.Services
{
    public class ErpProviderService : IErpProviderService
    {
        private readonly ErpUnitOfWork _erpUnitOfWork;
        private readonly IUserService _userService;
        private readonly IMapper _mapper;

        public ErpProviderService(
            ErpUnitOfWork erpUnitOfWork,
            IUserService userService,
            IMapper mapper
            )
        {
            _erpUnitOfWork = erpUnitOfWork;
            _userService = userService;
            _mapper = mapper;
        }

        public Task<ErpProviderCreateResponseDto> CreateErpProvider(CompanyCreateRequestDto entity)
        {
            throw new NotImplementedException();
        }

        public Task<ErpResponseDto> CreateErpProvider(ErpCreateRequestDto erp)
        {
            throw new NotImplementedException();
        }

        public Task<ErpProviderInfoDto> GetErpProviderById(Guid id)
        {
            throw new NotImplementedException();
        }

        public Task<ErpProviderInfoDto> GetErpProviderByUserId(Guid userId)
        {
            throw new NotImplementedException();
        }
    }
}
