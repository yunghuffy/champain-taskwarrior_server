# Class: taskwarrior_server
# ===========================
#
# Full description of class taskwarrior_server here.
#
# Parameters
# ----------
#
# Document parameters here.
#
# * `sample parameter`
# Explanation of what this parameter affects and what it defaults to.
# e.g. "Specify one or more upstream ntp servers as an array."
#
# Variables
# ----------
#
# Here you should define a list of variables that this module would require.
#
# * `sample variable`
#  Explanation of how this variable affects the function of this class and if
#  it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#  External Node Classifier as a comma separated list of hostnames." (Note,
#  global variables should be avoided in favor of class parameters as
#  of Puppet 2.6.)
#
# Examples
# --------
#
# @example
#    class { 'taskwarrior_server':
#      servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#    }
#
# Authors
# -------
#
# Author Name <jacobcastello@gmail.com>
#
# Copyright
# ---------
#
# Copyright 2017 Jacob Castello, unless otherwise noted.
#
class taskwarrior_server ( 
  String $task_git_source = 'https://git.tasktools.org/TM/taskd.git',
  String $task_git_revision = 'master',
  String $build_packages = []
) {

  $_build_packages = [
    'git',
    'libuuid',
    'libuuid-devel',
    'gnutls',
    'gnutls-c++',
    'gnutls-devel',
    'make',
    'cmake',
    'gcc',
    'gcc-c++',
  ]

  package { $build_packages:
    ensure =>  present,
  }

  vcsrepo { '/opt/source':
    ensure   => present,
    provider => git,
    source   => $task_git_source,
    revision => $task_git_revision,
  }

  file { '/var/taskd':
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  file { '/var/taskd/config':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('taskwarrior_server/config.erb'),
  }


}