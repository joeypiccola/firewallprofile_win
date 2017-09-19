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

  $standard_profile = 'enabled',
  $domain_profile   = 'enabled',
  $public_profile   = 'enabled',
  $service_state    = 'running'

){

  # parameter validation
  validate_re($standard_profile,['^(enabled|disabled)$'])
  validate_re($domain_profile,['^(enabled|disabled)$'])
  validate_re($public_profile,['^(enabled|disabled)$'])
  validate_re($service_state,['^(running|stopped)$'])

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
  
  /*
  case $service_state {
    'stopped': {
      $enabled = false
	}
	default: {
      $enabled = true
	}
  }
  */

  registry_value { 'HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\StandardProfile\EnableFirewall':
    ensure => present,
    type   => dword,
    data   => $standard_profile_value,
  }
  
  registry_value { 'HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\DomainProfile\EnableFirewall':
    ensure => present,
    type   => dword,
    data   => $domain_profile_value,
  }

  registry_value { 'HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\PublicProfile\EnableFirewall':
    ensure => present,
    type   => dword,
    data   => $public_profile_value,
  }

  service { 'Windows_firewall':
    ensure => $service_state,
    name   => 'MpsSvc',
  }

}