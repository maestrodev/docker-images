class maestro::agent::package::windows(
  $repo = $maestro::agent::repo,
  $version = $maestro::agent::agent_version,
  $downloaddir = 'C:\Windows\Temp',
) {

  $base_version = snapshotbaseversion($version)

  # TODO: allow configuration to be separated from installation
  $installdir = $maestro::params::agent_user_home
  # TODO: should be derived from the above
  $installparentdir = "C:\\"

  $repo_url = $repo['url']
  $repo_username = $repo['username']
  $repo_password = $repo['password']

  # TODO: doesn't deal with erasing old one. Better to build an MSI instead and
  # replace this with a package { ... } though
  exec { "download-maestro-agent":
    command => "
\$webClient = New-Object System.Net.WebClient
\$passwd = ConvertTo-SecureString '${repo_password}' -AsPlainText -Force;
\$webClient.Credentials = New-Object System.Management.Automation.PSCredential('${repo_username}', \$passwd);
\$webClient.DownloadFile('${repo_url}/com/maestrodev/lucee/agent/${base_version}/agent-${version}-bin.zip', '${downloaddir}\\maestro-agent-${version}.zip')",
  provider => powershell,
  creates  => "${downloaddir}/maestro-agent-${version}.zip",
  } ->
  exec { "unpack-maestro-agent":
    command  => "
\$shellApplication = New-Object -com shell.application
\$zipFile = \$shellApplication.NameSpace('${downloaddir}\\maestro-agent-${version}.zip')
\$destFolder = \$shellApplication.NameSpace('${installparentdir}')
\$destFolder.CopyHere(\$zipFile.Items())",
    provider => powershell,
    creates  => $installdir,
    notify   => Exec['install-windows-agent-service'],
  }
}

