using EuroConnector.API.DTOs.Documents;
using System.Text;
using XsltTransformer.Interfaces;
using EuroConnector.API.Infrastructure.Objects;
using EuroConnector.API.UOW;
using EuroConnector.API.DTOs.Users;
using EuroConnector.Data.Models;
using AutoMapper;
using ILogger = Serilog.ILogger;
using EuroConnector.API.Helpers;
using EuroConnector.API.DTOs.Extensions;

namespace EuroConnector.API.Services
{
    public class DocumentService : IDocumentService
    {
        private readonly ISchematronValidator _schematronValidator;
        private readonly DocUnitOfWork _docUnitOfWork;
        private readonly IMapper _mapper;
        IObserver<QueueDocument> _documentSender;
        private readonly ILogger _logger;

        public DocumentService(
            DocUnitOfWork docUnitOfWork,
            ISchematronValidator schematronValidator,
            IMapper mapper,
            IObserver<QueueDocument> documentSender,
            ILogger logger)
        {
            _docUnitOfWork = docUnitOfWork;
            _schematronValidator = schematronValidator;
            _mapper = mapper;
            _documentSender = documentSender;
            _logger = logger;
        }

        public Result<bool> IsValid(DocumentValidationRequestDto request)
        {
            switch (request.DocumentStandard)
            {
                case DocStandard.BIS3: return IsValidateBIS3Document(request.DocumentContent);
                default:
                    break;
            }
            return default;
        }

        private Result<bool> IsValidateBIS3Document(string documentData)
        {
            try
            {
                var documentBytes = Convert.FromBase64String(documentData);
                var document = new UTF8Encoding(false).GetString(documentBytes);
                var docType = UblParser.IdentifyDocumentType(document);

                var errors = _schematronValidator.Validate(document, docType.ToString());

                if (!errors.Any())
                {
                    return true;
                }
                else
                {
                    var error = new KnownErrors.DocumentValidation().InvalidDocument;
                    foreach ( var validationError in errors)
                    {
                        error.AddPropertyError(
                            validationError.XPath,
                            $"Condition: {validationError.Condition}, Error message: {validationError.ErrorMessage}");
                    }
                    return error;
                }
            }
            catch (Exception)
            {
                throw;
            }
        }

        public Task<Result<BillingReportResponseDto>> GetBillingReort(DateOnly periodFrom, DateOnly periodTo, Guid connectedErpProviderId)
        {
            throw new NotImplementedException();
        }

        public Task<Result<DocumentGetResponse>> GetDocument(Guid documentId, Guid userId, UserValidationResultDto connectedCompany)
        {
            throw new NotImplementedException();
        }

        public Task<Result<DocumentContentResponse>> GetDocumentContent(Guid documentId, Guid userId, UserValidationResultDto connectedCompany)
        {
            throw new NotImplementedException();
        }

        public Task<Result<DocumentRecieveResponse>> RecieveDocuments(Guid userId, UserValidationResultDto connectedCompany)
        {
            throw new NotImplementedException();
        }

        public Task<Result<DocumentSearchResponse>> SearchForDocument(DocumentSearchRequest request, Guid userId, UserValidationResultDto connectedCompany)
        {
            throw new NotImplementedException();
        }

        public Task<Result<DocumentStatusResponse>> SetStatus(Guid id, DocStatusType status, Guid userId, UserValidationResultDto connectedCompany)
        {
            throw new NotImplementedException();
        }

        public Task<DocumentsSendResponseDto> SendNewDocument(DocumentSendRequestDto request, Guid userId, UserValidationResultDto connectedCompany)
        {
            throw new NotImplementedException();
        }
    }
}
