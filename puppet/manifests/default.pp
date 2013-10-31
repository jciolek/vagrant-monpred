Exec {
    path => '/usr/bin:/bin:/usr/local/bin'
}

$apps = {
    "my-app" => {
        dir => "/var/www/my-app/web"
      , env => "development"
      , domain => "my-app.localdomain"
      , type => "symfony"
    }
}

class ppa {
  exec { 'apt-get update':
      command => 'apt-get update'
  }

  package { 'python-software-properties':
      ensure => installed
    , require => Exec['apt-get update']
  }
}

class { 'redis':
    version => '2.6.14'
}

class { 'apt': }

class { 'ppa': }

class { 'php5': }

class { 'nginx':
    apps => $apps
  , require => Class['ppa', 'php5']
}
