using System.Reflection;
using System.Xml.Linq;
using XsltTransformer.Interfaces;

namespace XsltTransformer
{
    public class SchematronValidator : ISchematronValidator
    {
        private readonly IXsltTransformer _xsltTransformer;

        public SchematronValidator(IXsltTransformer xsltTransformer)
        {
            _xsltTransformer = xsltTransformer;
        }

        public IEnumerable<ValidationError> Validate(string documentContent, string docType)
        {
            var xslContent = ReadXslContent(docType);
            var transformationResult = _xsltTransformer.Transform(xslContent, documentContent);

            var resultXDoc = XDocument.Parse(transformationResult);

            var errors = new List<ValidationError>();

            foreach (var element in resultXDoc.Root!.Elements())
            {
                if (element.Name.LocalName.ToLower() == "failed-assert")
                {
                    errors.Add(new ValidationError()
                    {
                        XPath = element.Attribute("location")!.Value,
                        Condition = element.Attribute("test")!.Value,
                        ErrorMessage = element.Element("{http://purl.oclc.org/dsdl/svrl}text")!.Value
                    });
                }
            }

            return errors;
        }

        private string ReadXslContent(string docType)
        {
            string? filename = docType switch
            {
                "InvoiceResponse" => "Schematron-IR.xslt",
                "MessageLevelResponse" => "Schematron-MLR.xslt",
                _ => "Schematron.xslt",
            };
            return File.ReadAllText(Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "xslt", filename));
        }
    }
}
