#
define systemd::service (
    $execstart        = undef,
    $servicename      = $name,
    $description      = undef,
    $execstartpost    = undef,
    $execstop         = undef,
    $execreload       = undef,
    $execstartpre     = undef,
    $execstoppost     = undef,
    $workingdir       = undef,
    $restart          = undef,
    $restartsec       = undef,
    $remainafterexit  = false,
    $syslogidentified = undef,
    $user             = undef,
    $group            = undef,
    $type             = undef,
    $defaultdeps      = true,
    $requires         = [],
    $conflicts        = [],
    $wants            = [],
    $after            = [],
    $wantedby         = undef,
    $unit_path        = $systemd::unit_path,
) {

    if $restart {
      validate_re($restart, ['^always$', '^no$', '^on-(success|failure|abnormal|abort|watchdog)$'], "Not a supported restart type: ${restart}")
    }
    validate_bool($remainafterexit)
    if $type {
      validate_re($type, ['^simple$', '^forking$', '^oneshot$', '^dbus$', '^notify$', '^idle$'], "Not a supported type: ${type}")
    }
    validate_bool($defaultdeps)
    validate_array($requires)
    validate_array($conflicts)
    validate_array($wants)
    validate_array($after)
    if $wantedby {
      validate_array($wantedby)
    }

    if ( str2bool($::systemd_available) ) {
      $_servicenotify = Exec['systemd-daemon-reload']
    } else {
      $_servicenotify = undef
    }
    file { "${unit_path}/${servicename}.service":
        ensure  => 'present',
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => template("${module_name}/service.erb"),
        notify  => $_servicenotify,
    }
}
