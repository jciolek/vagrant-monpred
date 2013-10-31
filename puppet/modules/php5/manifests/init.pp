class php5 {
  package { 'php5-cli':
      ensure => installed
  }

  package { 'php5-fpm':
      ensure => installed
  }
}