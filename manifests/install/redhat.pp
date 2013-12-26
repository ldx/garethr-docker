# Class:: docker::install::redhat
#
#
class docker::install::redhat (
  $ensure,
  $manage_kernel,
) {
  if (versioncmp($::operatingsystemrelease, '6.0') < 0) {
    fail("RHEL versions earlier than 6.0 are not supported; this system appears to be '${::operatingsystemversion}'.")
  }

  class { 'epel': }

  yumrepo { 'hop5':
    descr    => 'www.hop5.in CentOS Repository',
    baseurl  => 'http://www.hop5.in/yum/el6/',
    gpgcheck => 0,
    enabled  => 1,
    require  => Class['epel'],
  }

  package { 'docker-io':
    ensure  => $docker::install::redhat::ensure,
    require => Yumrepo['hop5'],
  }

  if $docker::install::redhat::manage_kernel {
    package { 'kernel-headers':
      ensure   => 'absent',
      before   => Package['kernel-ml-aufs-headers'],
      provider => 'yum',
    }

    package { ['kernel-ml-aufs','kernel-ml-aufs-headers']:
      ensure   => 'present',
      require  => [Yumrepo['hop5'],Package['kernel-headers']],
    }

    augeas { 'grub-kernel-ml-aufs':
      incl => '/boot/grub/grub.conf',
      lens => 'Grub.lns',
      changes => 'set default 0',
      require => Package['kernel-ml-aufs'],
      subscribe => Package['kernel-ml-aufs'],
    }
  }
} # Class:: docker::install::redhat
