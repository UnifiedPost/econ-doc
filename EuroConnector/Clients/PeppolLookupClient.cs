namespace EuroConnector.API.Clients
{
    public class PeppolLookupClient : IPeppolLookupClient
    {
        private readonly IHttpClientFactory _httpClientFactory;
        private readonly IConfiguration _config;
        private readonly Serilog.ILogger _logger;

        public PeppolLookupClient(
            IHttpClientFactory httpClientFactory,
            IConfiguration config,
            Serilog.ILogger logger)
        {
            _httpClientFactory = httpClientFactory;
            _config = config;
            _logger = logger;
        }

        public async Task<string> GetServiceGroup(string hash, string participantId)
        {
            var outboundConnections = _config.GetSection("OUTBOUND_CONNECTIONS");
            var sml = outboundConnections.GetValue<string>("PEPPOL_LOOKUP_SML")!;

            var url = $"http://b-{hash}.iso6523-actorid-upis.{sml}/iso6523-actorid-upis::{participantId}";
            _logger.Information("Sending PeppolLookupServiceGroup: request URL {Url}", url);

            using var request = new HttpRequestMessage(HttpMethod.Get, url);
            var client = _httpClientFactory.CreateClient("PeppolLookup");

            using var response = await client.SendAsync(request);

            var xmlResponse = await response.Content.ReadAsStringAsync();
            if (response.IsSuccessStatusCode) return xmlResponse;

            throw new Exception($"The requested Peppol participant {participantId} was not found in SML {sml}");
        }

        public async Task<string> GetBusinessCard(string hash, string participantId)
        {
            var outboundConnections = _config.GetSection("OUTBOUND_CONNECTIONS");
            var sml = outboundConnections.GetValue<string>("PEPPOL_LOOKUP_SML")!;

            var url = $"http://b-{hash}.iso6523-actorid-upis.{sml}/businesscard/iso6523-actorid-upis::{participantId}";
            _logger.Information("Sending PeppolLookupBusinessCard: request URL {Url}", url);

            using var request = new HttpRequestMessage(HttpMethod.Get, url);
            var client = _httpClientFactory.CreateClient("PeppolLookup");

            using var response = await client.SendAsync(request);

            if (response.IsSuccessStatusCode)
            {
                var xmlResponse = await response.Content.ReadAsStringAsync();
                return xmlResponse;
            }

            return string.Empty;
        }

        public async Task<string> GetServiceMetadata(string url)
        {
            _logger.Information("Sending PeppolLookupServiceMetadata: request URL {Url}", url);

            using var request = new HttpRequestMessage(HttpMethod.Get, url);
            var client = _httpClientFactory.CreateClient("PeppolLookup");

            try
            {
                using var response = await client.SendAsync(request);

                if (response.IsSuccessStatusCode)
                {
                    var xmlResponse = await response.Content.ReadAsStringAsync();
                    return xmlResponse;
                }

                return string.Empty;
            }
            catch (Exception)
            {
                return string.Empty;
            }
        }

        private async Task<string> Response(HttpResponseMessage response, string errorResponseMessage)
        {
            var xmlResponse = await response.Content.ReadAsStringAsync();
            if (response.IsSuccessStatusCode) return xmlResponse;

            throw new Exception(errorResponseMessage);
        }
    }
}
