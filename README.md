# firewallprofile_win

Manage Windows firewall profiles and service.

## Parameters

 * ```standard_profile```     - [Optional] Enable or disable the standard profile. Defaults to 'enabled'.
 * ```domain_profile```       - [Optional] Enable or disable the domain profile. Defaults to 'enabled'.
 * ```public_profile```       - [Optional] Enable or disable the public profile. Defaults to 'enabled'.
 * ```service_status```       - [Optional] Set the status for the firewall service. Defaults to 'running'.
 * ```service_startup_type``` - [Optional] Set the startup type for the firewall service. Defaults to 'automatic'.

## Usage


## Examples
Enable all profiles and ensure the firewall service is started and running.
```ruby
class { 'firewallprofile_win':
}
```

Disable the domain firewall profile.
```ruby
class { 'firewallprofile_win':
  domain_profile => 'disabled',
}
```

Stop the firewall service.
```ruby
class { 'firewallprofile_win':
  service_status => 'stopped',
}
```

In this example we see a conflicting set of options. This service is set to running and disabled. In this scenario the `service_status` parameter value will be overwritten with `stopped`. On a related note, disabling the serivce or setting it to stopped will cuase the profile settings to not have an effect.
```ruby
class { 'firewallprofile_win':
  standard_profile     => 'enabled',
  public_profile       => 'enabled',
  domain_profile       => 'enabled',
  service_status       => 'running',
  service_startup_type => 'disabled',
}
```