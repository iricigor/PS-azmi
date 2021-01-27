using System.Management.Automation;
using Azure.Identity;
using System;
using Azure.Security.KeyVault.Certificates;


namespace azmi
{
    //
    // Get-AzmiCertificate
    //
    //   Get certificate content from Azure Key Vault using managed identity
    //

    [Cmdlet(VerbsCommon.Get, "AzmiCertificate")]
    public class GetCertificate : PSCmdlet
    {
        //
        // Arguments private properties
        //
        private string identity;
        private string certificate;
        private string file;

        //
        // Arguments Definitions
        //

        [Parameter(Mandatory = false)]
        public string Identity { get { return identity; } set { identity = value; } }

        [Parameter(Position = 0, Mandatory = true)]
        public string Certificate { get { return certificate; } set { certificate = value; } }

        [Parameter(Mandatory = true)]
        public string File { get { return file; } set { file = value; } }

        //
        //
        //  **** Cmdlet start ****
        //
        //


        protected override void ProcessRecord()
        {
            var cred = new ManagedIdentityCredential(identity);

            WriteVerbose($"Parsing secret... '{certificate}'");
            (Uri keyVault, string certName, string certVersion) = Shared.ParseUrl(certificate);

            WriteVerbose($"Obtaining certificate client for '{keyVault}' using '{identity}'...");
            // var secretClient = new SecretClient(keyVault, cred);
            var certificateClient = new CertificateClient(keyVault, cred);
            Uri secretIdentifier;

             WriteVerbose($"Obtaining certificate {certName}...");
            if (String.IsNullOrEmpty(certVersion)) {
            var certObj = certificateClient.GetCertificate(certName);
                secretIdentifier = certObj.Value.SecretId;
            } else
            {
                var certObj = certificateClient.GetCertificateVersion(certName, certVersion);
                secretIdentifier = certObj.Value.SecretId;
            }


            // WriteObject(secretClient.GetSecret(secretName, secretVersion).Value.Value);

            WriteObject(1);
        }
    }
}
