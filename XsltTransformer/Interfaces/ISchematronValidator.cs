using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace XsltTransformer.Interfaces
{
    public interface ISchematronValidator
    {
        IEnumerable<ValidationError> Validate(string documentContent, string docType);
    }
}
