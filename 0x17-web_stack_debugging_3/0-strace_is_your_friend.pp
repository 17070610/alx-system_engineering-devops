# Automated Puppet fix for Apache 500 error on WordPress site

exec { 'Fix WordPress site':
  command  => 'sudo sed -i "s/.phpp/.php/g" /var/www/html/wp-settings.php',
  provider => shell,
}

exec { 'Restart Apache':
  command  => 'sudo systemctl restart apache2',
  provider => shell,
  require  => Exec['Fix WordPress site'],
}
