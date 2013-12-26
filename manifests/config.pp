# == Class: docker::config
#
class docker::config {
  case $::osfamily {
    'RedHat': {
      mount { 'docker-cgroup':
        ensure  => 'present',
        name    => '/sys/fs/cgroup',
        device  => 'none',
        fstype  => 'cgroup',
        options => 'defaults',
        dump    => 0,
        pass    => 0,
      }
    }
    default: {
    }
  }
}
