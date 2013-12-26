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

  Class['docker::install::redhat'] -> Class['docker::install']

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
    $updated_kernel_pkgs = ['kernel-ml-aufs','kernel-ml-aufs-headers']
    if (versioncmp($::kernelversion, '3.10.5') < 0) {
      exec { 'remove-conflicting-kernel-headers':
        path      => '/usr/sbin:/sbin:/usr/bin:/bin',
        command   => 'yum -y remove kernel-headers',
        onlyif    => 'rpm -q kernel-headers',
        logoutput => 'on_failure',
        before    => Package[$docker::install::redhat::updated_kernel_pkgs],
      }
    }

    package { $docker::install::redhat::updated_kernel_pkgs:
      ensure  => 'present',
      require => [Yumrepo['hop5']],
    }

    augeas { 'grub-kernel-ml-aufs':
      incl      => '/boot/grub/grub.conf',
      lens      => 'Grub.lns',
      changes   => 'set default 0',
      require   => Package['kernel-ml-aufs'],
      subscribe => Package['kernel-ml-aufs'],
    }
  }
} # Class:: docker::install::redhat
