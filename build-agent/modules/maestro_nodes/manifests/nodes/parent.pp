# Node that can be imported in your site.pp

# Common configuration for Maestro Master and Agent nodes

node 'parent' {

  # Node that can be imported on your site.pp

  filebucket { main: server => 'puppet' }

  File { owner => 0, group => 0, mode => 0644, backup => main }
  Exec { path => "/usr/bin:/usr/sbin:/bin:/sbin:/usr/local/bin" }

  Firewall {
    before  => Anchor['firewall-post'],
    require => Anchor['firewall-pre'],
  }

  Yumrepo <| |> -> Package <| |>
  Package['npm'] -> Package <| provider == npm |>

  class { 'maestro_nodes::parent': }

}
