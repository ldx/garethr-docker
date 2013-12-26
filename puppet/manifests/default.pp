class { 'hiera': }

class { 'docker': }

$vmware_tools_deps = [
  'gcc',
  'make',
  'kernel-ml-aufs-devel',
]

package { $vmware_tools_deps:
  ensure  => 'present',
  require => Class['docker'],
}
