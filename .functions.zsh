# =============================================================================
# Functions
# =============================================================================

function setup-certs() {
  local cert_path="$HOME/.certs/all.pem"
  local cert_dir=$(dirname "${cert_path}")
  [[ -d "${cert_dir}" ]] || mkdir -p "${cert_dir}"
  security find-certificate -a -p /System/Library/Keychains/SystemRootCertificates.keychain > "${cert_path}"
  security find-certificate -a -p /Library/Keychains/System.keychain >> "${cert_path}"
  export GIT_SSL_CAINFO="${cert_path}"
  export AWS_CA_BUNDLE="${cert_path}"
  export NODE_EXTRA_CA_CERTS="${cert_path}"
  npm config set -g cafile "${cert_path}"
  npm config set -g strict-ssl true
}
