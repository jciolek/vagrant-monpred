vagrant-monpred
===============

monpred stands for:
- mongodb
- nginx
- php (fpm)
- redis

In a nutshell, the aim of this project is to provide enough config to provision a vagrant box with the stack as mentioned above, ready to serve your development.

One thing worth mentioning - in order to keep greater degree of control over the environment, this project compiles redis from source. The reason being: There are some difficulties getting the latest version of the stack on Ubuntu 12.04 for example, and the ppa repo does not always allow you to choose the version you want. In my experience, redis ppa had quite poor selection of versions.

# Installation
Dead easy. You need to be aware however, that this project uses git submodules, so you need to fetch them, too. It's simple enough, covered in the installation steps below.

## Requirements
Of course you are going to need Vagrant and VirtualBox. If you are using Ubuntu 12.04 on your machine (like myself) my suggestion is do not go for the repo version of the packages, but rather get them from the vendor:
- https://www.virtualbox.org/wiki/Linux_Downloads
- http://downloads.vagrantup.com/tags/v1.3.3

## The final steps
```bash
git clone https://github.com/jciolek/vagrant-monpred
cd vagrant-monpred
git submodule init
git submodule update
vagrant box add precise64 http://files.vagrantup.com/precise64.box
vagrant up
```
And there you go. Your vagrant box is up and running, with nginx, php and redis, waiting for your app to change the world.

The sample app should be instantly accessbile at http://10.0.0.3/ and reacting to any change you make to it. Check it out!

# The environment

## Guest system (Ubuntu 12.04 64 bit)
I have built and tested this project against Ubuntu 12.04 64 bit. If you need 32 it's easy to change.
- add precise32 instead of the 64 version during installation (see below)
- go to Vagrantfile, find the directive config.vm.box = "precise64" and change its value to "precise32"
- enjoy


## Building blocks
The box provisioned will have the following installed and ready to rock and roll:

- redis: v2.4.14 (compiled from source, listening on port 6379)
- nginx: as a web server for php, serving over http and https
- php-cli: you shall need that for compozer
- php-fpm: as fast as it gets in PHP world :)


## Networking
### IP address
The network interface address of the guest is statically assigned as 10.0.0.3, the host will have 10.0.0.1. It makes things easier to access the vagrant box from your local machine - simply put an entry to your hosts file and you are done.

If you use this range in your local network or you do not like that for whatever other reason you have two friens to help you out with it: the Vagrantfile and the URL: http://docs.vagrantup.com/v2/networking/

## How about your app?
The whole purpose of this project is to create dev environment instantly. Ideally, serving your app from the get-go. I have some good news for you here - it works like that!

Initially, the directory ./php from this project gets mounted on the VM under /var/www. You can change this setting or add other directories to be mounted in the Vagrantfile. The sample application (my-app) which you can find in ./php/my-app is already set up in nginx and you can access it going to 

http://10.0.0.3/

As I usually tend to work on a few projects at the same time, limiting myself to one app in this setup would be silly. Therefore nginx takes their configuration from the $apps hash in ./puppet/manifests/default.pp. You can specify as many apps as you want, following the example given. Puppet will create configuration files for them which should keep them running.


# Future considerations
As I find DigitalOcean really nice, I have an idea of using their awesome API to control the full provisioning process from puppet. That including provisioning a new box of course.

# Give the credit where it's due
My project uses / is inspired by a few open source puppet modules. Here they are:
- https://github.com/puppetlabs/puppetlabs-apt
- https://github.com/puppetlabs/puppetlabs-stdlib
- https://github.com/logicalparadox/puppet-nodejs
- https://github.com/logicalparadox/puppet-redis


