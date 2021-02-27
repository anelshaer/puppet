class profile::docker_nodes {
  include docker
  docker::run {'osquery01.puppet.vm':
    
  }
  docker::run {'fleet.puppet.vm':
    
  }
}
