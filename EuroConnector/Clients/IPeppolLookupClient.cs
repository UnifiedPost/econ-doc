
namespace EuroConnector.API.Clients
{
    public interface IPeppolLookupClient
    {
        Task<string> GetBusinessCard(string hash, string participantId);
        Task<string> GetServiceGroup(string hash, string participantId);
        Task<string> GetServiceMetadata(string url);
    }
}