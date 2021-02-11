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
    [OutputType(typeof(String))]
    public class GetCertificate : PSCmdlet
    {
        //
        // Arguments private properties
        //
        //private string identity;
        //private string certificate;

        //
        // Arguments Definitions
        //

        [Parameter(Mandatory = false)]
        public string Identity { get; set; }

        [Parameter(Position = 0, Mandatory = true)]
        public string Certificate { get; set; }

        [Parameter(Mandatory = false)]
        public string File { get; set; }

        //
        //
        //  **** Cmdlet start ****
        //
        //


        protected override void ProcessRecord()
        {
            var cred = new ManagedIdentityCredential(Identity);

            WriteVerbose($"Parsing certificate... '{Certificate}'");
            (Uri keyVault, string certName, string certVersion) = Shared.ParseUrl(Certificate);

            WriteVerbose($"Obtaining certificate client for '{keyVault}' using '{Identity}'...");
            var certificateClient = new CertificateClient(keyVault, cred);

            KeyVaultCertificate certObj;
            WriteVerbose($"Obtaining certificate Id {certName}...");
            if (String.IsNullOrEmpty(certVersion)) {
                certObj = certificateClient.GetCertificate(certName);
            } else
            {
                certObj = certificateClient.GetCertificateVersion(certName, certVersion);
            }
            var secretId = certObj.SecretId.ToString();

            WriteVerbose($"Obtaining certificate from {secretId}...");
            var gs = new GetSecret() { Secret = secretId, Identity = Identity };
            var cert = (string)gs.Invoke();

            // return value
            if (String.IsNullOrEmpty(File))
            {
                WriteObject(cert);
            } else
            {
                WriteVerbose($"Saving secret to file {File}...");
                System.IO.File.WriteAllText(File, cert);
                // TODO: Add test for file in current dir
                // TODO: Candidate for async
            }

        }
    }
}
