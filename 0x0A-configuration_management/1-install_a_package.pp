# Install flask of version 2.1.0
package { 'flask':
  ensure   => '2.1.0',
  provider => 'pip3'
}
package { 'werkzeug':
  ensure   => '2.0.3',
  provider => 'pip3',
}
