using EuroConnector.API.DTOs.Documents;
using EuroConnector.API.DTOs.Extensions;
using EuroConnector.API.DTOs.Users;
using EuroConnector.API.Infrastructure.Objects;
using EuroConnector.Data.Models;

namespace EuroConnector.API.Services
{
    public interface IDocumentService
    {
        Task<Result<BillingReportResponseDto>> GetBillingReort(DateOnly periodFrom, DateOnly periodTo, Guid connectedErpProviderId);
        Task<Result<DocumentGetResponse>> GetDocument(Guid documentId, Guid userId, UserValidationResultDto connectedCompany);
        Task<Result<DocumentContentResponse>> GetDocumentContent(Guid documentId, Guid userId, UserValidationResultDto connectedCompany);
        Result<bool> IsValid(DocumentValidationRequestDto request);
        Task<Result<DocumentRecieveResponse>> RecieveDocuments(Guid userId, UserValidationResultDto connectedCompany);
        Task<Result<DocumentSearchResponse>> SearchForDocument(DocumentSearchRequest request, Guid userId, UserValidationResultDto connectedCompany);
        Task<DocumentsSendResponseDto> SendNewDocument(DocumentSendRequestDto request, Guid userId, UserValidationResultDto connectedCompany);
        Task<Result<DocumentStatusResponse>> SetStatus(Guid id, DocStatusType status, Guid userId, UserValidationResultDto connectedCompany);
    }
}