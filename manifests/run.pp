# == Define: docker:run
#
# A define which manages an upstart managed docker container
#
define docker::run(
  $image,
  $command,
  $memory_limit = '0',
  $ports = [],
  $volumes = [],
  $links = [],
  $use_name = false,
  $running = true,
  $volumes_from = false,
  $username = false,
  $hostname = false,
  $env = [],
  $dns = [],
  $restart_service = true,
) {

  validate_re($image, '^[\S]*$')
  validate_re($title, '^[\S]*$')
  validate_re($memory_limit, '^[\d]*$')
  validate_string($command)
  if $username {
    validate_string($username)
  }
  if $hostname {
    validate_string($hostname)
  }
  validate_bool($running)

  $ports_array = any2array($ports)
  $volumes_array = any2array($volumes)
  $env_array = any2array($env)
  $dns_array = any2array($dns)
  $links_array = any2array($links)

  case $::osfamily {
    'Debian': {
      file { "/etc/init/docker-${title}.conf":
        ensure  => present,
        content => template('docker/etc/init/docker-run.conf.erb')
      }

      service { "docker-${title}":
        ensure     => $running,
        enable     => true,
        hasstatus  => true,
        hasrestart => true,
        provider   => upstart;
      }

      $initscript = "/etc/init/docker-${title}.conf"
    }
    'RedHat': {
      file { "/etc/init.d/docker-${title}":
        ensure  => present,
        content => template('docker/etc/init.d/docker-run.erb')
      }->
      service { "docker-${title}":
        ensure     => $running,
        enable     => true,
      }

      $initscript = "/etc/init/docker-${title}.conf"
    }
    default: {
      fail('Docker needs a RedHat or Debian based system.')
    }
  }

  if str2bool($restart_service) {
    File["/etc/init/docker-${title}.conf"] ~> Service["docker-${title}"]
  }
  else {
    File["/etc/init/docker-${title}.conf"] -> Service["docker-${title}"]
  }
}

