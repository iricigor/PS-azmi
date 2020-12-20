using System;
using System.IO;
using Azure.Identity;
using System.Management.Automation;
using Azure.Storage.Blobs;
using System.Linq;
using System.Collections.Generic;
using System.Threading.Tasks;


namespace azmi
{

    //
    // Get-AzmiBlobContent
    //
    //   Downloads blob/blobs from Azure storage account to local file/directory using managed identity
    //

    [Cmdlet(VerbsCommon.Get, "AzmiBlobContent")]
    public class GetAzmiBlobContent : PSCmdlet
    {
        //
        // Arguments private properties
        //

        private string identity;
        private string blob;
        private string file;
        private string container;
        private string directory;

        //
        // Arguments Definitions
        //

        [Parameter(Mandatory = false)]
        public string Identity {get { return identity; } set { identity = value; }}

        [Parameter(Position = 0, Mandatory = true, ParameterSetName = "Single")]
        public string Blob { get { return blob; } set { blob = value; } }

        [Parameter(Position = 1, Mandatory = false, ParameterSetName = "Single")]
        public string File { get { return file; } set { file = value; } }

        [Parameter(Mandatory = true, ParameterSetName = "Multi")]
        public string Container { get { return container; } set { container = value; } }

        [Parameter(Mandatory = false, ParameterSetName = "Multi")]
        public string Directory { get { return directory; } set { directory = value; } }


        //
        //
        //  **** Cmdlet start ****
        //
        //


        protected override void ProcessRecord()
        {

            if (ParameterSetName == "Single") {
                ProcessSingle();
            } else if (ParameterSetName == "Multi") {
                ProcessMulti();
            } else {
                throw new ArgumentException("Bad ParameterSet Name");
            }
        }

        private void ProcessSingle()
        {
            WriteVerbose("Starting to process a single blob");
            // Connection
            var cred = new ManagedIdentityCredential(identity);
            var blobClient = new BlobClient(new Uri(blob), cred);
            // Fix path
            file ??= blob.Split('/').Last();
            file = Path.GetFullPath(file, SessionState.Path.CurrentLocation.Path);
            WriteVerbose($"Using destination: '{file}'");
            // Download
            blobClient.DownloadTo(file);
            WriteVerbose("Download completed");
        }

        private void ProcessMulti()
        {
            WriteVerbose("Starting to process a container");
            // Connection
            var cred = new ManagedIdentityCredential(identity);
            var containerClient = new BlobContainerClient(new Uri(container), cred);

            // get list of blobs
            WriteVerbose("Obtaining list of blobs...");
            List<string> blobListing = containerClient.GetBlobs().Select(i => i.Name).ToList();
            WriteVerbose($"Obtained {blobListing.Count} blobs");

            directory ??= container.Split('/').Last();
            directory = Path.GetFullPath(directory, SessionState.Path.CurrentLocation.Path);
            WriteVerbose($"Using destination: '{directory}'");
            System.IO.Directory.CreateDirectory(directory);

            //Task.WhenAll(blobListing.Select(async blob => {
            //    BlobClient blobClient = containerClient.GetBlobClient(blob);
            //    string filePath = Path.Combine(directory, blob);
            //    await blobClient.DownloadToAsync(filePath);
            //}));

            Parallel.ForEach(blobListing, blobItem =>
            {
                BlobClient blobClient = containerClient.GetBlobClient(blobItem);
                string filePath = Path.Combine(directory, blobItem);
                string absolutePath = Path.GetFullPath(filePath);
                blobClient.DownloadTo(filePath);
            });
            WriteVerbose("Download completed");
        }
    }
}
