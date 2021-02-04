using System.Management.Automation;
using System.Text.RegularExpressions;
using Azure.Identity;
using Azure.Security.KeyVault.Secrets;
using System;
using System.Collections.Generic;

namespace azmi {

    public class Shared {

    static public (Uri, string, string) ParseUrl(string urlText, string validation = null) {
            // Example of expected URL
            // https://{vault-name}.vault.azure.net/{object-type}/{object-name}/{object-version}
            //           - - - - - p[0] - - - - -     - p[1] -      - p[2] -      - p[3] -

            // return values are:
            //   uri of the Azure Key Vault
            //   string identifying secret or certificate name
            //   string identifying version or null if missing

            // split
            var u = new Uri(urlText);
            var kv = u.Scheme + Uri.SchemeDelimiter + u.Host;
            var p = u.AbsolutePath.Split('/');  // it should return 3 or 4 elements

            // validate length
            if ((p.Length < 3) || (p.Length > 4)) {
                throw new ArgumentException($"Invalid url does not contain 3 or 4 parts: {urlText}");
            }
            bool hasVersionInfo = (p.Length == 4);

            // check if validation string is present
            if (!String.IsNullOrEmpty(validation)  && (p[1]) != validation) {
                throw new ArgumentException($"Invalid url does not contain {validation} at second position: {urlText}");
            }

            // validate complete string
            if (!String.IsNullOrEmpty(validation)) {
                string newString = $"{kv.ToString()}/{validation}/{p[2]}";
                if (hasVersionInfo) {newString += $"/{p[3]}";};
                if (newString != urlText) {
                    var msg = $"Input url does not match expected url:\n{urlText}\n{newString}";
                    throw new ArgumentException(msg);
                }
            }

            // return values
            return (new Uri(kv), p[2], hasVersionInfo ? p[3] : null);
        }

    }
}