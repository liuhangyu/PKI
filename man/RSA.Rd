\name{RSA}
\alias{RSA}
\alias{PKI.genRSAkey}
\alias{PKI.load.key}
\alias{PKI.save.key}
\alias{PKI.mkRSApubkey}
\alias{PKI.load.OpenSSH.pubkey}
\title{
  PKI functions handling RSA keys 
}
\description{
  \code{PKI.load.key} loads an RSA key in PKCS#1 PEM or DER format.

  \code{PKI.save.key} creates a PEM or DER representation of a RSA key.
  
  \code{PKI.genRSAkey} generates RSA public/private key pair.

  \code{PKI.mkRSApubkey} creates a RSA public key with the supplied
  modulus and exponent.

  \code{PKI.load.OpenSSH.pubkey} loads public key in OpenSSH format
  (as used in \code{.ssh/authorized_keys} file)
}
\usage{
PKI.load.key(what, format = c("PEM", "DER"), private, file)
PKI.save.key(key, format = c("PEM", "DER"), private, target)
PKI.genRSAkey(bits = 2048L)
PKI.mkRSApubkey(modulus, exponent=65537L, format = c("DER", "PEM", "key"))
PKI.load.OpenSSH.pubkey(what, first=TRUE, format = c("DER", "PEM", "key"))
}
\arguments{
  \item{what}{string, raw vector or connection to load the key from}
  \item{key}{RSA key object}
  \item{format}{format - PEM is ASCII (essentially base64-encoded DER
    with header/footer), DER is binary and key means an acutal key object}
  \item{private}{logical, whether to use the private key (\code{TRUE}),
    public key (\code{FALSE}) or whichever is available (\code{NA} or missing).}
  \item{file}{filename to load the key from - \code{what} and
    \code{file} are mutually exclusive}
  \item{target}{optional connection or a file name to store the result
    in. If missing, the result is just returned form teh function as
    either a character vector (PEM) or a raw vector (DER).}
  \item{bits}{size of the generated key in bits. Must be \code{2 ^ n}
    with integer \code{n > 8}.}
  \item{modulus}{modulus either as a raw vector (see
    \code{\link{as.BIGNUMint}}) or \code{bigz} object (from \code{gmp}
    package) or an integer.}
  \item{exponent}{exponent either as a raw vector (see
    \code{\link{as.BIGNUMint}}) or \code{bigz} object (from \code{gmp}
    package) or an integer.}
  \item{first}{logical, if \code{TRUE} only the first key will be used,
    otherwise the result is a list of keys.}
}
%\details{
%}
\value{
  \code{PKI.load.key}: private or public key object

  \code{PKI.save.key}: raw vector (DER format) or character vector (PEM
  format).
  
  \code{PKI.genRSAkey}: private + public key object

  \code{PKI.mkRSApubkey}, \code{PKI.load.OpenSSH.pubkey}: raw vector
  (DER format) or character vector (PEM format) or a \code{"public.key"}
  object.
}
%\references{
%}
\author{
  Simon Urbanek
}
\note{
  The format for private keys in PEM is PKCS#1, but for public keys it
  is X.509 SubjectPublicKeyInfo (certificate public key). This is
  consistent with OpenSSL RSA command line tool which uses the same
  convention.

  The OpenSSH format is one line beginning with \code{"ssh-rsa "}.
  SSH2 PEM public keys (rfc4716) are supported in \code{PKI.load.key} and the
  binary payload is the same as the OpenSSH, only with different wrapping.
}
\seealso{\code{\link{PKI.encrypt}}, \code{\link{PKI.decrypt}}, \code{\link{PKI.pubkey}}}
\examples{
# generate 2048-bit RSA key
key <- PKI.genRSAkey(bits = 2048L)

# extract private and public parts as PEM
priv.pem <- PKI.save.key(key)
pub.pem <- PKI.save.key(key, private=FALSE)
# load back the public key separately
pub.k <- PKI.load.key(pub.pem)

# encrypt with the public key
x <- PKI.encrypt(charToRaw("Hello, world!"), pub.k)
# decrypt with private key
rawToChar(PKI.decrypt(x, key))

# compute SHA1 hash (fingerprint) of the public key
PKI.digest(PKI.save.key(key, "DER", private=FALSE))

# convert OpenSSH public key to PEM format
PKI.load.OpenSSH.pubkey("ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAIEAuvOXqfZ3pJeWeqyQOIXZwmgM1RBqPUmVx3XgntpA+YtOZjKfuoJSpg3LhBuI/wXx8L2QZXNFibvX4qX2qoYsbHvkz2uonA3F7HRhCR/BJURR5nT135znVqALZo328v86HDsVWYR2/JzY1X8GI2R2iKUMGXF0hVuRphdwLB735CU= foo@mycomputer", format="PEM")
}
\keyword{manip}
