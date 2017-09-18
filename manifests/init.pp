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

  $standard_profile = true,
  $domain_profile   = true,
  $public_profile   = true,

){

  # parameter validation
  validate_bool($standard_profile)
  validate_bool($domain_profile)
  validate_bool($public_profile)

  if $standard_profile {
    $standard_profile_value = 0
  } else {
    $standard_profile_value = 1
  }

  if $domain_profile {
    $domain_profile_value = 0
  } else {
    $domain_profile_value = 1
  }

  if $public_profile {
    $public_profile_value = 0
  } else {
    $public_profile_value = 1
  }

  registry_value { 'HLMM\CurrentControl\SetServices\SharedAccess\Parameters\FirewallPolicy\StandardProfile\EnableFirewall':
    ensure => present,
    type   => string,
    data   => $standard_profile_value,
  }
  
  registry_value { 'HLMM\CurrentControl\SetServices\SharedAccess\Parameters\FirewallPolicy\DomainProfile\EnableFirewall':
    ensure => present,
    type   => string,
    data   => $domain_profile_value,
  }

  registry_value { 'HLMM\CurrentControl\SetServices\SharedAccess\Parameters\FirewallPolicy\PublicProfile\EnableFirewall':
    ensure => present,
    type   => string,
    data   => $public_profile_value,
  }

}