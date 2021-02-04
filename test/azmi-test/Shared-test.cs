using System;
using Xunit;
using azmi;

namespace azmi_test
{
    public class Shared_Test
    {
        [Fact]
        public void DummyTest()
        {
            Assert.True(true);
        }

        [Fact]
        public void StandardSecretIsOK()
        {
            // Arrange
            string certUrl = "https://myvault.vault.azure.net/certificates/myCert";
            // Act
            (var kv, var cert, var version) = Shared.ParseUrl(certUrl, "certificates");
            // Assert
            Assert.Equal("myCert", cert);
            Assert.Null(version);

        }
    }
}
