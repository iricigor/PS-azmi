using System;
using System.IO;
using Azure.Identity;
using System.Management.Automation;
using Azure.Storage.Blobs;
using System.Linq;
using System.Collections.Generic;
using System.Threading.Tasks;
using System.Text.RegularExpressions;


namespace azmi
{

    //
    // Get-AzmiBlobContent
    //
    //   Downloads blob/blobs from Azure storage account to local file/directory using managed identity
    //

    [Cmdlet(VerbsCommon.Get, "AzmiBlobContent")]
    [OutputType(typeof(void))]
    public class GetBlobContent : PSCmdlet
    {
        //
        // Arguments private properties
        //

        //private string identity;
        //private bool deleteAfterCopy;
        //private string blob;
        //private string file;
        //private string container;
        //private string directory;

        //
        // Arguments Definitions
        //

        // All Parameter Sets
        [Parameter(Mandatory = false)]
        public string Identity { get; set; }

        [Parameter(Mandatory = false)]
        public SwitchParameter DeleteAfterCopy {get; set; }


        // Single Blob & File Parameter Set
        [Parameter(Position = 0, Mandatory = true, ParameterSetName = "Single")]
        public string Blob { get; set; }

        [Parameter(Position = 1, Mandatory = false, ParameterSetName = "Single")]
        public string File { get; set; }

        //
        // Multiple Blobs & Files (Container & Directory) Parameter Set
        //
        [Parameter(Mandatory = true, ParameterSetName = "Multi")]
        public string Container { get; set; }

        [Parameter(Mandatory = false, ParameterSetName = "Multi")]
        public string Directory { get; set; }

        [Parameter(ParameterSetName = "Multi")]
        public string Exclude { get; set; }


        //
        //
        //  **** Cmdlet start ****
        //
        //


        protected override void ProcessRecord()
        {
            switch (ParameterSetName) {
                case "Single": ProcessSingle(); break;
                case "Multi" : ProcessMulti();  break;
            }
        }

        private void ProcessSingle()
        {
            WriteVerbose("Starting to process a single blob");
            // Connection
            var cred = new ManagedIdentityCredential(Identity);
            var blobClient = new BlobClient(new Uri(Blob), cred);
            // Fix path
            File ??= Blob.Split('/').Last();
            File = Path.GetFullPath(File, SessionState.Path.CurrentLocation.Path);
            WriteVerbose($"Using destination: '{File}'");
            // Download
            blobClient.DownloadTo(File);
            if (DeleteAfterCopy) {blobClient.Delete();}
            WriteVerbose("Download completed");
        }

        private void ProcessMulti()
        {
            WriteVerbose($"Starting to process a container {Container}");
            // Connection
            var cred = new ManagedIdentityCredential(Identity);
            var containerClient = new BlobContainerClient(new Uri(Container), cred);

            // get list of blobs
            WriteVerbose("Obtaining list of blobs...");
            List<string> blobListing = containerClient.GetBlobs().Select(i => i.Name).ToList();
            WriteVerbose($"Obtained {blobListing.Count} blobs");

            // apply -Exclude regular expression
            if (!String.IsNullOrEmpty(Exclude))
            {
                WriteVerbose("Filtering list of blobs...");
                Regex excludeRegEx = new Regex(Exclude);
                blobListing = blobListing.Where(blob => !excludeRegEx.IsMatch(blob)).ToList();
                WriteVerbose($"Filtered to {blobListing.Count} blobs");
            }

            // fix path
            Directory ??= Container.Split('/').Last();
            Directory = Path.GetFullPath(Directory, SessionState.Path.CurrentLocation.Path);
            WriteVerbose($"Using destination: '{Directory}'");
            System.IO.Directory.CreateDirectory(Directory);

            //Task.WhenAll(blobListing.Select(async blob => {
            //    BlobClient blobClient = containerClient.GetBlobClient(blob);
            //    string filePath = Path.Combine(directory, blob);
            //    await blobClient.DownloadToAsync(filePath);
            //}));

            Parallel.ForEach(blobListing, blobItem =>
            {
                BlobClient blobClient = containerClient.GetBlobClient(blobItem);
                string filePath = Path.Combine(Directory, blobItem);
                string absolutePath = Path.GetFullPath(filePath);
                System.IO.Directory.CreateDirectory(Path.GetDirectoryName(filePath)); // required for missing sub-directories
                blobClient.DownloadTo(filePath);
                if (DeleteAfterCopy) {blobClient.Delete();}
            });
            WriteVerbose("Download completed");
        }
    }
}
