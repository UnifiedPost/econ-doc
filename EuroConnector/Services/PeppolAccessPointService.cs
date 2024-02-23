using AutoMapper;
using EuroConnector.API.DTOs.Entities;
using EuroConnector.API.Infrastructure.Objects;
using EuroConnector.API.DTOs.PeppolServices.PeppolAccessPoint;
using EuroConnector.API.DTOs.Users;
using EuroConnector.API.UOW;
using EuroConnector.Data.Contract;
using EuroConnector.Data.Models;
using ValueHasher;
using ILogger = Serilog.ILogger;
using EuroConnector.API.DTOs.PeppolServices;
using EuroConnector.API.Infrastructure.Helpers;
using EuroConnector.API.Clients;
using System.Xml.Linq;
using System.Xml;
using System.Xml.XPath;

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

        public async Task<Result<EntityLookupResponseDto>> PeppolLookup(string participantId)
        {
            var md5 = Helper.GetMD5ForString(participantId.ToLower());

            var serviceGroup = string.Empty;
            try
            {
                serviceGroup = await _peppolLookupClient.GetServiceGroup(md5, participantId);
            }
            catch (HttpRequestException)
            {
                return new KnownErrors.GeneralErrors().BadRequest;
            }
            catch (Exception ex)
            {
                return new Error(ex.Message, 400);
            }

            var businessCard = await _peppolLookupClient.GetBusinessCard(md5, participantId);
            if (string.IsNullOrEmpty(businessCard)) _logger.Information("Business card for {ParticipantId} was not found.", participantId);

            try
            {
                var metadataUrl = GetMetadataUrlFromServiceGroup(serviceGroup);
                var serviceMetadata = string.IsNullOrEmpty(metadataUrl) ? string.Empty : await _peppolLookupClient.GetServiceMetadata(metadataUrl);

                return MapServiceMetadataToResponse(serviceGroup, serviceMetadata, businessCard);
            }
            catch (Exception)
            {
                return new KnownErrors.GeneralErrors().BadRequest;
            }
        }


        private string? GetMetadataUrlFromServiceGroup(string serviceGroupXml)
        {
            var xdoc = XDocument.Parse(serviceGroupXml);

            var element = xdoc.XPathSelectElement("./*[local-name() = \"ServiceGroup\"]/*[local-name() = \"ServiceMetadataReferenceCollection\"]/*[local-name() = \"ServiceMetadataReference\"]");
            var href = element?.Attribute("href")?.Value;

            return href;
        }

        private EntityLookupResponseDto MapServiceMetadataToResponse(string serviceGroupXml, string serviceMetadataXml, string businessCardXml)
        {
            var serviceGroup = XDocument.Parse(serviceGroupXml);
            XDocument? serviceMetadata = null;
            XDocument? businessCard = null;
            if (!string.IsNullOrEmpty(businessCardXml)) businessCard = XDocument.Parse(businessCardXml);
            if (!string.IsNullOrEmpty(serviceMetadataXml)) serviceMetadata = XDocument.Parse(serviceMetadataXml);

            var participantIdElement = serviceGroup.XPathSelectElement("./*[local-name() = \"ServiceGroup\"]/*[local-name() = \"ParticipantIdentifier\"]");
            var businessEntityElement = businessCard?.XPathSelectElement("./*[local-name() = \"BusinessCard\"]/*[local-name() = \"BusinessEntity\"]");

            var accessPoint = serviceMetadata?
                        .XPathSelectElement("./*[local-name() = \"SignedServiceMetadata\"]/*[local-name() = \"ServiceMetadata\"]/*[local-name() = \"ServiceInformation\"]/*[local-name() = \"ProcessList\"]/*[local-name() = \"Process\"]/*[local-name() = \"ServiceEndpointList\"]/*[local-name() = \"Endpoint\"]/*[local-name() = \"ServiceDescription\"]")!
                        .Value;
            var endpointSchemeId = participantIdElement!.Value.Split(":")[0];
            var participantId = participantIdElement!.Value;
            var participantIdentifierSchemeId = participantIdElement!.Attribute("scheme")!.Value;
            var createdAt = businessEntityElement?.Attribute("registrationDate")?.Value;

            return new()
            {
                PeppolService = new()
                {
                    AccessPoint = accessPoint,
                    EndpointSchemeId = endpointSchemeId,
                    ParticipantId = participantId,
                    ParticipantIdentifierSchemeId = participantIdentifierSchemeId,
                    Status = "active",
                    IsEnabled = true,
                    CreatedAt = createdAt
                }
            };
        }

    }
}
