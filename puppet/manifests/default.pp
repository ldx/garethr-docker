class { 'hiera': }

class { 'docker':
  manage_kernel => false,
}

# $vmware_tools_deps = [
#   'gcc',
#   'make',
#   'kernel-ml-aufs-devel',
# ]
#
# package { $vmware_tools_deps:
#   ensure  => 'present',
#   require => Class['docker'],
# }
