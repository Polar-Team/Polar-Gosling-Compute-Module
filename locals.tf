locals {

  labels = merge({
    created_at = formatdate("DD-MM-YYYY-hh-mm", timestamp()),
    owner      = var.owner
    group      = var.group
    },
  var.additional_labels)

  yc_create_sum   = (var.yc_vm_create || var.yc_serverless_create)
  vm_creation_sum = (var.yc_vm_create || var.aws_vm_create)

  ami = try(coalesce(var.ami, try(nonsensitive(data.aws_ssm_parameter.this[0].value), null)), null)

  metadata = merge({
    "vault-token" : var.vault-token,
    "user-data" : var.cloud-init
  })

  container_definitions_json = jsonencode([
    merge(
      {
        name              = var.container_name != null ? var.container_name : "app-container"
        image             = var.container_image != null ? var.container_image : "nginx:latest"
        cpu               = var.container_cpu != null ? var.container_cpu : 256
        memory            = var.container_memory != null ? var.container_memory : 512
        essential         = var.container_essential != null ? var.container_essential : true
        memoryReservation = var.container_memory_reservation != null ? var.container_memory_reservation : 256
      },
      var.container_portmappings != null ? {
        portMappings = [
          for pm in var.container_portmappings :
          merge(
            {
              containerPort = pm.container_port
              protocol      = pm.protocol != null ? pm.protocol : "tcp"
            },
            pm.host_port != null ? { hostPort = pm.host_port } : {},
            pm.name != null ? { name = pm.name } : {},
            pm.app_protocol != null ? { appProtocol = pm.app_protocol } : {}
          )
        ]
      } : {},
      var.container_environment != null ? {
        environment = [
          for env in var.container_environment :
          {
            name  = env.name
            value = env.value
          }
        ]
      } : {},
      var.container_environment_files != null ? {
        environmentFiles = [
          for ef in var.container_environment_files :
          {
            value = ef.value
            type  = ef.type
          }
        ]
      } : {},
      var.container_secrets != null ? {
        secrets = [
          for secret in var.container_secrets :
          {
            name      = secret.name
            valueFrom = secret.valueFrom
          }
        ]
      } : {},
      var.container_depends_on != null ? {
        dependsOn = [
          for dep in var.container_depends_on :
          {
            containerName = dep.containerName
            condition     = dep.condition
          }
        ]
      } : {},
      var.container_links != null ? { links = var.container_links } : {},
      var.container_volumes_from != null ? {
        volumesFrom = [
          for vf in var.container_volumes_from :
          merge(
            { sourceContainer = vf.sourceContainer },
            vf.readOnly != null ? { readOnly = vf.readOnly } : {}
          )
        ]
      } : {},
      var.container_mount_points != null ? {
        mountPoints = [
          for mp in var.container_mount_points :
          merge(
            {
              sourceVolume  = mp.sourceVolume
              containerPath = mp.containerPath
            },
            mp.readOnly != null ? { readOnly = mp.readOnly } : {}
          )
        ]
      } : {},
      var.container_linux_parameters != null ? {
        linuxParameters = merge(
          {},
          var.container_linux_parameters.capabilities != null ? {
            capabilities = merge(
              {},
              var.container_linux_parameters.capabilities.add != null ? { add = var.container_linux_parameters.capabilities.add } : {},
              var.container_linux_parameters.capabilities.drop != null ? { drop = var.container_linux_parameters.capabilities.drop } : {}
            )
          } : {},
          var.container_linux_parameters.devices != null ? {
            devices = [
              for device in var.container_linux_parameters.devices :
              merge(
                { hostPath = device.hostPath },
                device.containerPath != null ? { containerPath = device.containerPath } : {},
                device.permissions != null ? { permissions = device.permissions } : {}
              )
            ]
          } : {},
          var.container_linux_parameters.initProcessEnabled != null ? { initProcessEnabled = var.container_linux_parameters.initProcessEnabled } : {},
          var.container_linux_parameters.sharedMemorySize != null ? { sharedMemorySize = var.container_linux_parameters.sharedMemorySize } : {},
          var.container_linux_parameters.tmpfs != null ? {
            tmpfs = [
              for tmp in var.container_linux_parameters.tmpfs :
              merge(
                {
                  containerPath = tmp.containerPath
                  size          = tmp.size
                },
                tmp.mountOptions != null ? { mountOptions = tmp.mountOptions } : {}
              )
            ]
          } : {},
          var.container_linux_parameters.maxSwap != null ? { maxSwap = var.container_linux_parameters.maxSwap } : {},
          var.container_linux_parameters.swappiness != null ? { swappiness = var.container_linux_parameters.swappiness } : {}
        )
      } : {},
      var.container_hostname != null ? { hostname = var.container_hostname } : {},
      var.container_user != null ? { user = var.container_user } : {},
      var.container_working_directory != null ? { workingDirectory = var.container_working_directory } : {},
      var.container_disable_networking != null ? { disableNetworking = var.container_disable_networking } : {},
      var.container_privileged != null ? { privileged = var.container_privileged } : {},
      var.container_readonly_root_filesystem != null ? { readonlyRootFilesystem = var.container_readonly_root_filesystem } : {},
      var.container_dns_servers != null ? { dnsServers = var.container_dns_servers } : {},
      var.container_dns_search_domains != null ? { dnsSearchDomains = var.container_dns_search_domains } : {},
      var.container_extra_hosts != null ? {
        extraHosts = [
          for host in var.container_extra_hosts :
          {
            hostname  = host.hostname
            ipAddress = host.ipAddress
          }
        ]
      } : {},
      var.container_docker_security_options != null ? { dockerSecurityOptions = var.container_docker_security_options } : {},
      var.container_docker_labels != null ? { dockerLabels = var.container_docker_labels } : {},
      var.container_ulimits != null ? {
        ulimits = [
          for ulimit in var.container_ulimits :
          {
            name      = ulimit.name
            softLimit = ulimit.softLimit
            hardLimit = ulimit.hardLimit
          }
        ]
      } : {},
      var.container_command != null ? { command = var.container_command } : {},
      var.container_entry_point != null ? { entryPoint = var.container_entry_point } : {},
      var.container_health_check != null ? {
        healthCheck = merge(
          { command = var.container_health_check.command },
          var.container_health_check.interval != null ? { interval = var.container_health_check.interval } : {},
          var.container_health_check.timeout != null ? { timeout = var.container_health_check.timeout } : {},
          var.container_health_check.retries != null ? { retries = var.container_health_check.retries } : {},
          var.container_health_check.startPeriod != null ? { startPeriod = var.container_health_check.startPeriod } : {}
        )
      } : {},
      var.container_start_timeout != null ? { startTimeout = var.container_start_timeout } : {},
      var.container_stop_timeout != null ? { stopTimeout = var.container_stop_timeout } : {},
      var.container_system_controls != null ? {
        systemControls = [
          for sc in var.container_system_controls :
          {
            namespace = sc.namespace
            value     = sc.value
          }
        ]
      } : {},
      var.container_resource_requirements != null ? {
        resourceRequirements = [
          for rr in var.container_resource_requirements :
          {
            type  = rr.type
            value = rr.value
          }
        ]
      } : {},
      var.container_firelens_configuration != null ? {
        firelensConfiguration = merge(
          { type = var.container_firelens_configuration.type },
          var.container_firelens_configuration.options != null ? { options = var.container_firelens_configuration.options } : {}
        )
      } : {},
      var.container_interactive != null ? { interactive = var.container_interactive } : {},
      var.container_pseudo_terminal != null ? { pseudoTerminal = var.container_pseudo_terminal } : {},
      {
        logConfiguration = {
          logDriver = "awslogs"
          options = {
            "awslogs-group" : var.awslogs_group,
            "awslogs-region" : var.aws_region,
            "awslogs-stream-prefix" : var.awslogs_stream_prefix
          }
        }
      }
    )
  ])
  ######## Generating Outputs #########

  hostname = (local.vm_creation_sum ?
    (var.yc_vm_create ? [
      for s in yandex_compute_instance.this : s.hostname
      ][0] :
      [
        for s in aws_instance.this : s.private_dns
    ][0]) :
    (var.yc_serverless_create ? [
      for s in yandex_serverless_container.this : s.name
      ][0] :
      [
        for s in aws_ecs_task_definition.this : lookup(s.tags, "Name", "noname")
    ][0])
  )

  public_ip = (local.vm_creation_sum ? (var.yc_vm_create ? [
    for s in yandex_compute_instance.this : s.network_interface[*].nat_ip_address
    ][0] :
    [
      for s in aws_instance.this : s.public_ip
    ]) : ["serverless"]
  )

  private_ip = (local.vm_creation_sum ? (var.yc_vm_create ? [
    for s in yandex_compute_instance.this : s.network_interface[*].ip_address
    ][0] :
    [
      for s in aws_instance.this : s.private_ip
    ]) : ["serverless"]
  )

  id = (local.vm_creation_sum ? (var.yc_vm_create ? [
    for s in yandex_compute_instance.this : s.id
    ][0] :
    [
      for s in aws_instance.this : s.id
    ][0]) :
    (var.yc_serverless_create ? [
      for s in yandex_serverless_container.this : s.id
      ][0] :
      [
        for s in aws_ecs_task_definition.this : s.id
    ][0])
  )

}
