namespace XsltTransformer.Interfaces
{
    public interface IXsltTransformer
    {
        string Transform(string xsl, string xml);
    }
}
