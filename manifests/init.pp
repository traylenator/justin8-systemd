#
class systemd (
  $unit_path = $systemd::params::unit_path,
) inherits systemd::params {


  if ( str2bool($::systemd_available) ) {
    exec { 'systemd-daemon-reload':
      path        => '/bin:/usr/bin:/sbin:/usr/sbin',
      command     => 'systemctl daemon-reload',
      refreshonly => true
    }

    # refresh systemd before every service
    Exec['systemd-daemon-reload'] -> Service<| |>
  }

}
