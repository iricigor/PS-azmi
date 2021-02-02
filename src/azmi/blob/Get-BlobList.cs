using System;
using System.Collections.Generic;
using System.Linq;
using Azure.Identity;
using System.Management.Automation;
using Azure.Storage.Blobs;

namespace azmi
{
    //
    // Get-AzmiBlobList
    //
    //   Lists blobs from Azure storage account container using managed identity
    //

    [Cmdlet(VerbsCommon.Get, "AzmiBlobList")]
    [OutputType(typeof(String))]
    public class GetBlobList : Cmdlet
    {

        //
        // Arguments private properties
        //

        //private string identity;
        //private string container;

        //
        // Arguments Definitions
        //


        [Parameter(Mandatory = false)]
        //public string Identity { get { return identity; } set { identity = value; } }
        public string Identity { get ; set ; }

        [Parameter(Mandatory = true, Position = 0)]
        //public string Container { get { return container; } set { container = value; } }
        public string Container { get ; set ; }


        //
        //
        //  **** Cmdlet start ****
        //
        //


        protected override void ProcessRecord()
        {
            //var cred = new ManagedIdentityCredential(identity);
            //var containerClient = new BlobContainerClient(new Uri(container), cred);
            var cred = new ManagedIdentityCredential(Identity);
            var containerClient = new BlobContainerClient(new Uri(Container), cred);
            if (containerClient.Exists()) {
                WriteVerbose("Trying to read container...");
                List<string> blobsListing = containerClient.GetBlobs().Select(i => i.Name).ToList();
                WriteVerbose($"Obtained {blobsListing.Count} blobs");
                blobsListing.ForEach(b => WriteObject(b));
            } else {
                //WriteVerbose($"Container {container} does not exist or cannot be accessed.");
                WriteVerbose($"Container {Container} does not exist or cannot be accessed.");
                // switch to error
                // https://docs.microsoft.com/en-us/powershell/scripting/developer/cmdlet/adding-non-terminating-error-reporting-to-your-cmdlet?view=powershell-7.1#reporting-nonterminating-errors
            }
        }
    }
}
