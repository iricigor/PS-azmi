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
        public void StandardCertificateIsOK_WithValidation()
        {
            // Arrange
            string certUrl = "https://myvault.vault.azure.net/certificates/myCert";
            // Act
            (var kv, var cert, var version) = Shared.ParseUrl(certUrl, "certificates");
            // Assert
            Assert.Equal("myCert", cert);
            Assert.Null(version);
        }

        [Fact]
        public void StandardSecretIsOK_WithValidation()
        {
            // Arrange
            string secretUrl = "https://myvault.vault.azure.net/secrets/mySecret";
            // Act
            (var kv, var secret, var version) = Shared.ParseUrl(secretUrl, "secrets");
            // Assert
            Assert.Equal("mySecret", secret);
            Assert.Null(version);
        }

        [Fact]
        public void StandardCertificateIsOK_WithoutValidation()
        {
            // Arrange
            string certUrl = "https://myvault.vault.azure.net/certificates/myCert";
            // Act
            (var kv, var cert, var version) = Shared.ParseUrl(certUrl);
            // Assert
            Assert.Equal("myCert", cert);
            Assert.Null(version);
        }

        [Fact]
        public void StandardSecretIsOK_WithoutValidation()
        {
            // Arrange
            string secretUrl = "https://myvault.vault.azure.net/secrets/mySecret";
            // Act
            (var kv, var secret, var version) = Shared.ParseUrl(secretUrl);
            // Assert
            Assert.Equal("mySecret", secret);
            Assert.Null(version);
        }

        [Fact]
        public void StandardCertificateIsOK_WithVersion()
        {
            // Arrange
            string certUrl = "https://myvault.vault.azure.net/certificates/myCert/bdc9f1d96d9e49cab1c8499086421556";
            // Act
            (var kv, var cert, var version) = Shared.ParseUrl(certUrl, "certificates");
            // Assert
            Assert.Equal("myCert", cert);
            Assert.NotNull(version);
        }

        [Fact]
        public void StandardSecretIsOK_WithVersion()
        {
            // Arrange
            string secretUrl = "https://myvault.vault.azure.net/secrets/mySecret/dafe878cf1c54fa8a14087171d819f48";
            // Act
            (var kv, var secret, var version) = Shared.ParseUrl(secretUrl, "secrets");
            // Assert
            Assert.Equal("mySecret", secret);
            Assert.NotNull(version);
        }


        [Fact]
        public void ItFailsIfNoSecretName()
        {
            // Arrange
            string secretUrl = "https://myvault.vault.azure.net/secrets";
            // Act & Assert
            Assert.Throws<ArgumentException>(() => Shared.ParseUrl(secretUrl));
        }

        [Fact]
        public void ItFailsWithOnlyKVGiven()
        {
            // Arrange
            string secretUrl = "https://myvault.vault.azure.net";
            // Act & Assert
            Assert.Throws<ArgumentException>(() => Shared.ParseUrl(secretUrl));
        }


        [Fact]
        public void ItFailsWithTooManyFields()
        {
            // Arrange
            string secretUrl = "https://myvault.vault.azure.net/secrets/mySecret/version1/additionalfield";
            // Act & Assert
            Assert.Throws<ArgumentException>(() => Shared.ParseUrl(secretUrl));
        }

        [Fact]
        public void ItFailsOnTypeValidation()
        {
            // Arrange
            string secretUrl = "https://myvault.vault.azure.net/secrets/mySecret";
            // Act & Assert
            Assert.Throws<ArgumentException>(() => Shared.ParseUrl(secretUrl, "certificates"));
        }

        [Fact]
        public void ItFailsForWrongUrl()
        {
            // Arrange
            string secretUrl = "somerandomstring";
            // Act & Assert
            Assert.Throws<UriFormatException>(() => Shared.ParseUrl(secretUrl));
        }

        [Fact]
        public void ItFailsIfNoProtocol()
        {
            // Arrange
            string secretUrl = "myvault.vault.azure.net/secrets/mySecret";
            // Act & Assert
            Assert.Throws<UriFormatException>(() => Shared.ParseUrl(secretUrl));
        }

        [Fact]
        public void ItFailsIfPortSpecified()
        {
            // Arrange
            string secretUrl = "https://myvault.vault.azure.net:80/secrets/mySecret";
            // Act & Assert
            Assert.Throws<ArgumentException>(() => Shared.ParseUrl(secretUrl, "secrets"));
        }



    }
}
