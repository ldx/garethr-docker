class { 'hiera': }

class { 'docker': }

package { 'kernel-ml-aufs-devel':
  ensure  => 'present',
  require => Class['docker'],
}
