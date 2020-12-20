using System;
using Azure.Identity;
using System.Management.Automation;
using Azure.Storage.Blobs;
using System.Linq;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace azmi
{

    //
    // Get-AzmiBlob
    //
    //   Downloads a blob from Azure storage account to local file using managed identity
    //

    [Cmdlet(VerbsCommon.Get, "AzmiBlobs")]
    public class GetAzmiBlobsCommand : Cmdlet
    {
        //
        // Arguments properties
        //

        private string identity;
        private string container;
        private string directory;

        //
        // Other internal properties
        //
        private BlobContainerClient containerClient;

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
        public string Container
        {
            get { return container; }
            set { container = value; }
        }

        ///
        /// Argument: Identity
        ///
        [Parameter]
        public string Directory
        {
            get { return directory; }
            set { directory = value; }
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
            containerClient = new BlobContainerClient(new Uri(container), cred);

            // get list of blobs
            List<string> blobListing = containerClient.GetBlobs().Select(i => i.Name).ToList();

            System.IO.Directory.CreateDirectory(directory);

            //Task.WhenAll(blobListing.Select(blob => DownloadAsync(blob)));

            Parallel.ForEach(blobListing, blobItem =>
            {
                BlobClient blobClient = containerClient.GetBlobClient(blobItem);
                string filePath = System.IO.Path.Combine(directory, blobItem);
                string absolutePath = System.IO.Path.GetFullPath(filePath);
                blobClient.DownloadTo(filePath);
            });

        }

        private async Task DownloadAsync(string blobItem)
        {
            BlobClient blobClient = containerClient.GetBlobClient(blobItem);
            string filePath = System.IO.Path.Combine(directory, blobItem);
            await blobClient.DownloadToAsync(filePath);

        }
    }
}
