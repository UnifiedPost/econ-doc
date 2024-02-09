namespace EuroConnector.API.DTOs.Extensions
{
    public class BillingReportResponseDto
    {
        public Guid ReportId { get; set; } = Guid.NewGuid();
        public DateOnly BillingPeriodFrom { get; set; }
        public DateOnly BillingPeriodTo { get; set; }
        public List<BillingInfoDto> BillingInfo { get; set; } = new List<BillingInfoDto>();

        public class BillingInfoDto
        {
            public string ParticipantId { get; set; } = default!;
            public int DocumentsSent { get; set; }
            public int DocumentsReceived { get; set; }

        }
    }
}
