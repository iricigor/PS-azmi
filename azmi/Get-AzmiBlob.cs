using System;
using Azure.Identity;
using System.Management.Automation;
using Azure.Storage.Blobs;


namespace azmi
{

    //
    // Get-AzmiBlob
    //
    //   Downloads a blob from Azure storage account to local file using managed identity
    //

    [Cmdlet(VerbsCommon.Get, "AzmiBlob")]
    public class GetAzmiBlobCommand : Cmdlet
    {
        //
        // Arguments properties
        //

        private string identity;
        private string blob;
        private string file;

        ///
        /// Argument: Identity
        ///
        [Parameter]
        public string Identity
        {
            get { return identity; }
            set { identity = value; }
        }

        ///
        /// Argument: File
        ///
        [Parameter]
        public string Blob
        {
            get { return blob; }
            set { blob = value; }
        }

        ///
        /// Argument: Identity
        ///
        [Parameter]
        public string File
        {
            get { return file; }
            set { file = value; }
        }


        //
        //
        //  **** Cmdlet start ****
        //
        //


        protected override void ProcessRecord()
        {
            // Connection
            var cred = new ManagedIdentityCredential(identity);
            var blobClient = new BlobClient(new Uri(blob), cred);
            blobClient.DownloadTo(file);
        }
    }
}
