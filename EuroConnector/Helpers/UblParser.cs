using com.sun.tools.doclets.@internal.toolkit.util;
using EuroConnector.Data.Models;
using System.Text;
using System.Xml;
using System.Xml.Linq;
using System.Xml.XPath;

namespace EuroConnector.API.Helpers
{
    public static class UblParser
    {
        public static void ToDocument(ref Document doc, string documentContent, DocType docType)
        {
            switch (docType) 
            {
                case DocType.Invoice:
                case DocType.CreditNote:
                    ParseInvoice(ref doc, documentContent, docType);
                    break;
                case DocType.InvoiceResponse:
                    throw new Exception("Current realese does not support InvoiceResponse document type");
                    //ParseInvResponse(ref doc, documentContent, docType);
                    //break;
                case DocType.MessageLevelResponse:
                    throw new Exception("Current realese does not support MessageLevelResponse document type");
                    //ParseMessageLevelResponse(ref doc, documentContent, docType);
                    //break;
                default:
                    throw new Exception("Unknown document type. Unable to parse document.");
            }
        }

        private static void ParseInvoice(ref Document doc, string documentContent, DocType docType)
        {
            var docString = new UTF8Encoding(false).GetString(Convert.FromBase64String(documentContent));
            XDocument xDoc = XDocument.Parse(docString);
            var rootTag = $"x:{xDoc.Root?.Name.LocalName}";
            XmlNamespaceManager xnm = new XmlNamespaceManager(new NameTable());
            xnm.AddNamespace("x", xDoc.Root!.Name.Namespace.ToString());
            xnm.AddNamespace("cac", "urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2");
            xnm.AddNamespace("cbc", "urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2");
            doc.DocumentType = docType;
            doc.DocumentNo = xDoc.XPathSelectElement($"./{rootTag}/cbc:ID", xnm)?.Value;

            var supplierParty = xDoc.XPathSelectElement($"./{rootTag}/cac:AccountingSupplierParty/cac:Party", xnm);
            doc.SenderEndpointId = 
                $"{supplierParty?.XPathSelectElement("cbc:EndpointID", xnm)?.Attribute("schemeID")?.Value}:" +
                $"{supplierParty?.XPathSelectElement("cbc:EndpointID", xnm)?.Value}";
            doc.SenderName = supplierParty?.XPathSelectElement("cac:PartyLegalEntity/cbc:RegistrationName", xnm)?.Value;
            doc.SenderEntityCode = supplierParty?.XPathSelectElement("cac:PartyLegalEntity/cbc:CompanyID", xnm)?.Value;
            var supplierTaxScheme = supplierParty?.XPathSelectElement("cac:PartyTaxScheme/cac:TaxScheme/cbc:ID", xnm)?.Value;
            if(supplierTaxScheme?.ToUpper() == "VAT")
            {
                doc.SenderVatNumber = supplierParty?.XPathSelectElement("cac:PartyTaxScheme/cbc:CompanyID", xnm)?.Value;
            }

            var customerParty = xDoc.XPathSelectElement($"./{rootTag}/cac:AccountingCustomerParty/cac:Party", xnm);
            doc.RecipientEndpointId =
                $"{customerParty?.XPathSelectElement("cbc:EndpointID", xnm)?.Attribute("schemeID")?.Value}:" +
                $"{customerParty?.XPathSelectElement("cbc:EndpointID", xnm)?.Value}";
            doc.RecipientName = customerParty?.XPathSelectElement("cac:PartyLegalEntity/cbc:RegistrationName", xnm)?.Value;
            doc.RecipientEntityCode = customerParty?.XPathSelectElement("cac:PartyLegalEntity/cbc:CompanyID", xnm)?.Value;
            var customerTaxScheme = customerParty?.XPathSelectElement("cac:PartyTaxScheme/cac:TaxScheme/cbc:ID", xnm)?.Value;
            if (customerTaxScheme?.ToUpper() == "VAT")
            {
                doc.RecipientVatNumber = customerParty?.XPathSelectElement("cac:PartyTaxScheme/cbc:CompanyID", xnm)?.Value;
            }

        }

        public static DocType IdentifyDocumentType(string document)
        {
            var xdoc = XDocument.Parse(document);
            //invoice case
            if(IsValidInvoiceType(xdoc)) return DocType.Invoice;
            if (IsValidCreditNoteType(xdoc)) return DocType.CreditNote;
            if (IsValidMsgLvlResponseType(xdoc)) return DocType.MessageLevelResponse;
            if (IsValidInvoiceResponseType(xdoc)) return DocType.InvoiceResponse;

            throw new Exception("Invalid document type.");
        }

        private static bool IsValidInvoiceResponseType(XDocument doc)
        {
            var rootElement = doc.XPathSelectElement("./*[local-name() = \"ApplicationResponse\"]");
            if (rootElement is null)
                return false;

            var customizationID = rootElement.XPathSelectElement($"./*[local-name() = \"CustomizationID\"]")?.Value;
            if (customizationID is null || customizationID != "urn:fdc:peppol.eu:poacc:trns:invoice_response:3")
                return false;

            var profileID = rootElement.XPathSelectElement($"./*[local-name() = \"ProfileID\"]")?.Value;
            if (profileID is null || profileID != "urn:fdc:peppol.eu:poacc:bis:invoice_response:3")
                return false;

            return true;
        }

        private static bool IsValidMsgLvlResponseType(XDocument doc)
        {
            var rootElement = doc.XPathSelectElement("./*[local-name() = \"ApplicationResponse\"]");
            if (rootElement is null)
                return false;

            var customizationID = rootElement.XPathSelectElement($"./*[local-name() = \"CustomizationID\"]")?.Value;
            if (customizationID is null || customizationID != "urn:fdc:peppol.eu:poacc:trns:mlr:3")
                return false;

            var profileID = rootElement.XPathSelectElement($"./*[local-name() = \"ProfileID\"]")?.Value;
            if (profileID is null || profileID != "urn:fdc:peppol.eu:poacc:bis:mlr:3")
                return false;

            return true;
        }

        private static bool IsValidCreditNoteType(XDocument doc)
        {
            var rootElement = doc.XPathSelectElement("./*[local-name() = \"CreditNote\"]");
            if (rootElement is null)
                return false;

            var customizationID = rootElement.XPathSelectElement($"./*[local-name() = \"CustomizationID\"]")?.Value;
            if (customizationID is null || customizationID != "urn:cen.eu:en16931:2017#compliant#urn:fdc:peppol.eu:2017:poacc:billing:3")
                return false;

            var profileID = rootElement.XPathSelectElement($"./*[local-name() = \"ProfileID\"]")?.Value;
            if (profileID is null || profileID != "urn:fdc:peppol.eu:2017:poacc:billing:01:1.0")
                return false;

            return true;
        }

        private static bool IsValidInvoiceType(XDocument doc)
        {
            var rootElement = doc.XPathSelectElement("./*[local-name() = \"Invoice\"]");
            if(rootElement is null) 
                return false;
            
            var customizationID = rootElement.XPathSelectElement($"./*[local-name() = \"CustomizationID\"]")?.Value;
            if (customizationID is null || customizationID != "urn:cen.eu:en16931:2017#compliant#urn:fdc:peppol.eu:2017:poacc:billing:3") 
                return false;

            var profileID = rootElement.XPathSelectElement($"./*[local-name() = \"ProfileID\"]")?.Value;
            if(profileID is null || profileID != "urn:fdc:peppol.eu:2017:poacc:billing:01:1.0") 
                return false;

            return true;
        }
    }
}
