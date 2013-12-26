# == Class: docker::paramrs
#
# Defaut parameter values for the docker module
#
class docker::params {
  $version             = undef
  $ensure              = present
  $manage_kernel       = true
  $tcp_bind            = undef
  $socket_bind         = 'unix:///var/run/docker.sock'
  $use_upstream_repo   = true
  $service_state       = running
  $root_dir            = undef
  $apt_source_location = 'https://get.docker.io/ubuntu'
}
