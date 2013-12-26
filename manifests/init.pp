# == Class: docker
#
# Module to install an up-to-date version of Docker from the appropriate
# upstream package repository, thus this module works only on Debian and Redhat
# based distributions.
#
# === Parameters
# [*version*]
#   The package version to install, passed to ensure.
#   Defaults to present
#
# [*tcp_bind*]
#   The tcp socket to bind to in the format
#   tcp://127.0.0.1:4243
#   Defaults to undefined
#
# [*socket_bind*]
#   The unix socket to bind to. Defaults to
#   unix:///var/run/docker.sock.
#
# [*use_upstream_repo*]
#   Whether or not to use the upstream package repository.
#   If you run your own package mirror, you may set this
#   to false.
# [*apt_source_location*]
#   If you're using an upstream apt source, what is its location. Defaults to
#   https://get.docker.io/ubuntu for Debian systems and the hop5 repository for
#   RedHat systems.
# [*manage_kernel*]
#   Attempt to install the correct Kernel required by docker
#   Defaults to true
#
class docker(
  $version             = $docker::params::version,
  $ensure              = $docker::params::ensure,
  $tcp_bind            = $docker::params::tcp_bind,
  $socket_bind         = $docker::params::socket_bind,
  $use_upstream_repo   = $docker::params::use_upstream_repo,
  $apt_source_location = $docker::params::apt_source_location,
  $service_state       = $docker::params::service_state,
  $root_dir            = $docker::params::root_dir,
  $manage_kernel       = $docker::params::manage_kernel,
) inherits docker::params {

  validate_string($docker::version)
  validate_bool($docker::manage_kernel)

  class { 'docker::install':
    ensure              => $docker::ensure,
    apt_source_location => $docker::apt_source_location,
    manage_kernel       => $docker::manage_kernel,
    use_upstream_repo   => $docker::use_upstream_repo,
    version             => $docker::version,
  } ->
  class { 'docker::config': } ~>
  class { 'docker::service': } ->
  Class['docker']
}
