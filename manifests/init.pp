# == Class: kms_win
#
# Manage the KMS client settings on a Windows machine.
#
# === Parameters
#
# [*key_management_service_name*]
#   The FQDN of the KMS server.
#
# [*key_management_service_port*]
#   The port of the KMS server. Defaults to '1688'.
#
# [*attempt_activation*]
#   Whether or not to run 'slmgr /ato' after setting either the KMS name or port.
#   Valid values are `true` and `false`. Defaults to `true`.
#
# === Examples
#
#  class { kms_win:
#    key_management_service_name = 'kmsserver.contoso.com',
#  }
#
# === Authors
#
# Joey Piccola <joey@joeypiccola.com>
#
# === Copyright
#
# Copyright (C) 2017 Joey Piccola.
#
class firewallprofile_win (

  $standard_profile     = 'enabled',
  $domain_profile       = 'enabled',
  $public_profile       = 'enabled',
  $service_status       = 'running',
  $service_startup_type = 'automatic',

){

  # parameter validation
  validate_re($standard_profile,['^(enabled|disabled)$'])
  validate_re($domain_profile,['^(enabled|disabled)$'])
  validate_re($public_profile,['^(enabled|disabled)$'])
  validate_re($service_status,['^(running|stopped)$'])
  validate_re($service_startup_type,['^(automatic|disabled)$'])

  if $service_startup_type == 'disabled'  {
    notice ( "service_startup_type is ${service_startup_type}, overriding service_status to ${service_status}" )
    $_service_status = 'stopped'
  } else {
    $_service_status = 'running'
  }

  case $standard_profile {
    'disabled': {
      $standard_profile_data = 0
  }
    default: {
      $standard_profile_data = 1
    }
  }

  case $domain_profile {
    'disabled': {
      $domain_profile_data = 0
  }
    default: {
      $domain_profile_data = 1
    }
  }

  case $public_profile {
    'disabled': {
      $public_profile_data = 0
  }
    default: {
      $public_profile_data = 1
    }
  }

  case $service_startup_type {
    'disabled': {
      $enabled = false
  }
    default: {
      $enabled = true
    }
  }

  registry_value { 'EnableFirewallDomainProfile':
    ensure => 'present',
    notify => Service['Windows_firewall'],
    path   => 'HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\DomainProfile\EnableFirewall',
    type   => 'dword',
    data   => $domain_profile_data,
  }
  registry_value { 'EnableFirewallPublicProfile':
    ensure => 'present',
    notify => Service['Windows_firewall'],
    path   => 'HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\PublicProfile\EnableFirewall',
    type   => 'dword',
    data   => $public_profile_data,
  }
  registry_value { 'EnableFirewallStandardProfile':
    ensure => 'present',
    notify => Service['Windows_firewall'],
    path   => 'HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\StandardProfile\EnableFirewall',
    type   => 'dword',
    data   => $standard_profile_data,
  }

  service { 'Windows_firewall':
    ensure => $_service_status,
    name   => 'MpsSvc',
    enable => $enabled
  }

}
