using EuroConnector.API.DTOs.Documents;
using EuroConnector.API.DTOs.Users;
using EuroConnector.API.Infrastructure.Extensions;
using EuroConnector.API.Infrastructure.Objects;
using EuroConnector.API.Services;
using EuroConnector.Data.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Swashbuckle.AspNetCore.Annotations;
using System.Security.Claims;

namespace EuroConnector.API.Controllers
{
    [ApiController]
    [Route("api/public/v{version:apiVersion}/[controller]")]
    [ApiVersion("1.0")]
    public class DocumentsController : ControllerBase
    {
        private readonly IDocumentService _documentService;
        private readonly IUserService _userService;

        public DocumentsController(IDocumentService documentService, IUserService userService)
        {
            _documentService = documentService;
            _userService = userService;
        }

        [HttpPost]
        [Route("validate")]
        [SwaggerOperation(Summary = "Entity validates document content if it follows the particular standard")]
        [ProducesResponseType(typeof(DocumentValidationResponse), 200)]
        [ProducesResponseType(typeof(Error), 400)]
        [Authorize(Roles = "User")]
        public async Task<IActionResult> ValidateAsync(DocumentValidationRequestDto request)
        {
            Guid userId = new Guid(User.FindFirst(ClaimTypes.NameIdentifier)?.Value!);
            var userIsValidResult = await _userService.UserIsValid(userId);
            if (userIsValidResult.IsError) return new KnownErrors.UsersErrors().InvalidCredencials.ToErrorResponse();
            var result = _documentService.IsValid(request);

            return result.ToResponse(ok => new DocumentValidationResponse(request.DocumentStandard));
        }

        [HttpPost]
        [Route("send")]
        [SwaggerOperation(Summary = "Entity sends a document in UBL BIS3 format")]
        [ProducesResponseType(typeof(DocumentsSendResponseDto), 202)]
        [Authorize(Roles = "User")]
        public async Task<IActionResult> SendAsync(DocumentSendRequestDto request)
        {
            //validate user
            Guid userId = new Guid(User.FindFirst(ClaimTypes.NameIdentifier)?.Value!);
            var userIsValidResult = await _userService.UserIsValid(userId);
            if (userIsValidResult.IsError) return new KnownErrors.UsersErrors().InvalidCredencials.ToErrorResponse();


            //validate doc
            var docIsValidResult = _documentService.IsValid(new DocumentValidationRequestDto
            {
                DocumentContent = request.DocumentContent,
                DocumentStandard = request.DocumentStandard
            });
            if (docIsValidResult.IsError) return docIsValidResult.ToResponse();

            //save and triger send doc
            var sendNewDocResult = await _documentService.
                SendNewDocument(request, userId, userIsValidResult.SuccessValue<UserValidationResultDto>());
            return new ObjectResult(sendNewDocResult)
            {
                StatusCode = 202,
            };

        }
        [HttpGet]
        [Route("received-list")]
        [SwaggerOperation(Summary = "Entity gets a list of new documents received")]
        [ProducesResponseType(typeof(DocumentRecieveResponse), 200)]
        [Authorize(Roles = "User")]
        public async Task<IActionResult> ReceiveAsync()
        {
            Guid userId = new Guid(User.FindFirst(ClaimTypes.NameIdentifier)?.Value!);
            var userIsValidResult = await _userService.UserIsValid(userId);
            if (userIsValidResult.IsError) return new KnownErrors.UsersErrors().InvalidCredencials.ToErrorResponse();

            var recieveDocsResult = await _documentService.
                RecieveDocuments(userId, userIsValidResult.SuccessValue<UserValidationResultDto>());
            return recieveDocsResult.ToResponse();
        }

        [HttpPost]
        [Route("search")]
        [SwaggerOperation(Summary = "Entity searches documents by query and gets a list in return")]
        [ProducesResponseType(typeof(DocumentSearchResponse), 200)]
        [Authorize(Roles = "User")]
        public async Task<IActionResult> Search(DocumentSearchRequest request)
        {
            Guid userId = new Guid(User.FindFirst(ClaimTypes.NameIdentifier)?.Value!);
            var userIsValidResult = await _userService.UserIsValid(userId);
            if (userIsValidResult.IsError) return new KnownErrors.UsersErrors().InvalidCredencials.ToErrorResponse();

            Result<DocumentSearchResponse> searchDocumentsResult = await _documentService.
                SearchForDocument(request, userId, userIsValidResult.SuccessValue<UserValidationResultDto>());
            return searchDocumentsResult.ToResponse();
        }

        [HttpGet]
        [Route("{id}")]
        [SwaggerOperation(Summary = "Entity retrieves information about the document")]
        [ProducesResponseType(typeof(DocumentGetResponse), 200)]
        [Authorize(Roles = "User")]
        public async Task<IActionResult> GetAsync(Guid id)
        {
            Guid userId = new Guid(User.FindFirst(ClaimTypes.NameIdentifier)?.Value!);
            var userIsValidResult = await _userService.UserIsValid(userId);
            if (userIsValidResult.IsError) return new KnownErrors.UsersErrors().InvalidCredencials.ToErrorResponse();

            Result<DocumentGetResponse> getDocumentResult = await _documentService.
                GetDocument(id, userId, userIsValidResult.SuccessValue<UserValidationResultDto>());
            return getDocumentResult.ToResponse();
        }

        [HttpPut]
        [Route("{id}/status/{status}")]
        [SwaggerOperation(Summary = "Entity updates a status of recieved document")]
        [ProducesResponseType(typeof(DocumentStatusResponse), 200)]
        [Authorize(Roles = "User")]
        public async Task<IActionResult> Update(Guid id, DocStatusType status)
        {
            if(status == DocStatusType.Sent)
            {
                var error = new KnownErrors.DocumentValidation().InvalidStatus;
                error.Message = "The value 'sent' is not valid.";
                return error.ToErrorResponse();
            }

            Guid userId = new Guid(User.FindFirst(ClaimTypes.NameIdentifier)?.Value!);
            var userIsValidResult = await _userService.UserIsValid(userId);
            if (userIsValidResult.IsError) return new KnownErrors.UsersErrors().InvalidCredencials.ToErrorResponse();

            Result<DocumentStatusResponse> setStatusResult = await _documentService.
                SetStatus(id, status, userId, userIsValidResult.SuccessValue<UserValidationResultDto>());
            return setStatusResult.ToResponse();
        }


        [HttpGet]
        [Route("{id}/content")]
        [SwaggerOperation(Summary = "Entity retrieves the content (UBL BIS3) of the document")]
        [ProducesResponseType(typeof(DocumentContentResponse), 200)]
        [Authorize(Roles = "User")]
        public async Task<IActionResult> GetContent(Guid id)
        {
            Guid userId = new Guid(User.FindFirst(ClaimTypes.NameIdentifier)?.Value!);
            var userIsValidResult = await _userService.UserIsValid(userId);
            if (userIsValidResult.IsError) return new KnownErrors.UsersErrors().InvalidCredencials.ToErrorResponse();


            Result<DocumentContentResponse> getDocumentContentResult = await _documentService.
                GetDocumentContent(id, userId, userIsValidResult.SuccessValue<UserValidationResultDto>());
            return getDocumentContentResult.ToResponse();
        }

        [HttpGet]
        [Route("standards")]
        [SwaggerOperation(Summary = "Lists all the available document standards (specifications)")]
        [ProducesResponseType(typeof(IEnumerable<DocStandard>), 200)]
        [AllowAnonymous]
        public IActionResult DocumentStandards()
        {
            var standards = Enum.GetValues<DocStandard>();

            return Ok(standards);
        }

        [HttpGet]
        [Route("types")]
        [SwaggerOperation(Summary = "Lists all the available document types")]
        [ProducesResponseType(typeof(IEnumerable<DocType>), 200)]
        [AllowAnonymous]
        public IActionResult DocumentTypes()
        {
            var types = Enum.GetValues<DocType>();

            return Ok(types);
        }
    }
}
