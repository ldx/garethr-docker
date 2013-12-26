# Class:: docker::install::debian
#
#
class docker::install::debian (
  $apt_source_location,
  $ensure,
  $manage_kernel,
  $use_upstream_apt_source,
  $version,
) {

  if ($docker::install::debian::use_upstream_apt_source) {
    include apt
    apt::source { 'docker':
      location          => $docker::install::debian::apt_source_location,
      release           => 'docker',
      repos             => 'main',
      required_packages => 'debian-keyring debian-archive-keyring',
      key               => 'A88D21E9',
      key_source        => 'http://get.docker.io/gpg',
      pin               => '10',
      include_src       => false,
    }

    Apt::Source['docker'] -> Package['lxc-docker']
  }

  case $::operatingsystemrelease {
    # On Ubuntu 12.04 (precise) install the backported 13.04 (raring) kernel
    '12.04': { $kernelpackage = [
                                  'linux-image-generic-lts-raring',
                                  'linux-headers-generic-lts-raring'
                                ]
    }
    # determine the package name for 'linux-image-extra-$(uname -r)' based on
    # the $::kernelrelease fact
    default: { $kernelpackage = "linux-image-extra-${::kernelrelease}" }
  }

  if $docker::install::debian::manage_kernel {
    package { $docker::install::debian::kernelpackage:
      ensure => present,
      before => Package['lxc-docker'],
    }
  }

  if $docker::install::debian::version {
    $dockerpackage = "lxc-docker-${docker::install::debian::version}"
  } else {
    $dockerpackage = 'lxc-docker'
  }

  package { 'lxc-docker':
    ensure => $docker::install::debian::ensure,
    name   => $docker::install::debian::dockerpackage,
  }
} # Class:: docker::install::debian
