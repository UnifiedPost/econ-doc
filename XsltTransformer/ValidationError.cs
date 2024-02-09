namespace XsltTransformer
{
    public class ValidationError
    {
        public string XPath { get; set; } = default!;
        public string Condition { get; set; } = default!;
        public string ErrorMessage { get; set; } = default!;
    }
}
