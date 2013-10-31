class nginx(
    $apps = {
        "my-app" => {
            type => "symfony"
          , dir => "/var/www/my-app/web"
          , domain => "my-app.localdomain"
        }
    }
) {

  $app_keys = keys($apps)
  
  define config_files($apps) {
    $app = $apps[$title]

    file { "nginx_available_${title}":
        ensure => file
      , path => "/etc/nginx/sites-available/${title}"
      , content => template("${module_name}/${app['type']}.erb")
      , owner => "root"
      , group => "root"
    }
    
    file { "nginx_enabled_${title}":
        ensure => link
      , path => "/etc/nginx/sites-enabled/${title}"
      , target => "/etc/nginx/sites-available/${title}"
      , owner => "root"
      , group => "root"
    }
  }
  
  package { "ssl-cert":
      ensure => installed
  }
  
  package { "nginx":
      ensure => installed
    , require => Package['ssl-cert']
  }

  package { "php5-cli":
      ensure => installed
  }

  package { "php5-fpm":
      ensure => installed
  }
  
  file { "nginx_enabled_default":
      path => "/etc/nginx/sites-enabled/default"
    , ensure => absent
    , require => Package['nginx', 'php5-cli', 'php5-fpm']
  }
  
  config_files { $app_keys:
      apps => $apps
    , require => [ Package['nginx'], File['nginx_enabled_default'] ]
    , notify => Service['nginx']
  }

  service { "nginx":
      ensure => running
    , require => Package['nginx']
  }
}