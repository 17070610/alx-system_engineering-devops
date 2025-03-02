# automated puppet fix (to find out why Apache is returning a 500 error)

class fix_apache_500 {
    package { 'apache2':
        ensure => installed,
    }

    service { 'apache2':
        ensure  => running,
        enable  => true,
        require => Package['apache2'],
    }

    file { '/var/www/html':
        ensure  => directory,
        owner   => 'www-data',
        group   => 'www-data',
        mode    => '0755',
        recurse => true,
    }

    exec { 'Fix wordpress site':
        command  => 'sed -i "s/.phpp/.php/" /var/www/html/wp-settings.php',
        path     => ['/bin', '/usr/bin'],
        onlyif   => 'grep ".phpp" /var/www/html/wp-settings.php',
        provider => shell,
    }

    exec { 'restart_apache':
        command     => 'systemctl restart apache2',
        path        => ['/bin', '/usr/bin', '/usr/sbin'],
        subscribe   => [File['/var/www/html'], Exec['Fix wordpress site']],
        refreshonly => true,
    }
}

include fix_apache_500
