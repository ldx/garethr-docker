# == Class: docker
#
# Module to install an up-to-date version of Docker from the
# official Apt repository. The use of this repository means, this module works
# only on Debian based distributions.
#
class docker::install (
  $ensure,
  $apt_source_location,
  $manage_kernel,
  $use_upstream_repo,
  $version,
) {
  validate_string($docker::install::version)
  validate_string($::kernelrelease)
  validate_bool($docker::install::use_upstream_repo)

  case $::osfamily {
    'Debian': {
      class { 'docker::install::debian':
        ensure                  => $docker::install::ensure,
        apt_source_location     => $docker::install::apt_source_location,
        manage_kernel           => $docker::install::manage_kernel,
        use_upstream_apt_source => $docker::install::use_upstream_repo,
        version                 => $docker::install::version,
      }
    }
    'RedHat': {
      class { 'docker::install::redhat':
        ensure                => $docker::install::ensure,
        manage_kernel         => $docker::install::manage_kernel,
      }
    }
    default: {
      fail('This module supports only certain Debian and RedHat systems.')
    }
  }
}
