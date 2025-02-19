#prefix                           = "recordcm-record"
#azure_devops_organisation_target = "recordcm"
#azure_devops_project_target = "record"

resource_group_name = "record-stg-stg-uat"

container_apps_no_ingress = {

  staging-outboxmon = {
    name          = "stg-outboxmon-00"
    revision_mode = "Single"

    template = {
      containers = [
        {
          name   = "stg-outboxmon"
          memory = "0.5Gi"
          cpu    = 0.25
          image  = "acrrecord.azurecr.io/trading-stg-outboxmonitor:latest"
          #mage = "acrrecord.azurecr.io/counting-service:0.0.2"
          env = [
            {
              name  = "ConnectionStrings__AppConfig"
              value = "https://stg-uat-record-appconf-00.azconfig.io"
            },
            {
              name  = "ConnectionStrings__AppConfigCommon"
              value = "https://uat-record-appconf-common-00.azconfig.io"
            },
            {
              name  = "DOTNET_ENVIRONMENT"
              value = "UAT"
            }

          ]
        },
      ]
      min_replicas = 1
      max_replicas = 1
    }

    identity = {
      type = "SystemAssigned, UserAssigned"
    }

    registry = [
      {
        server = "acrrecord.azurecr.io"
      }
    ]

  },

  staging-orderrec = {
    name          = "stg-orderrec-00"
    revision_mode = "Single"

    template = {
      containers = [
        {
          name   = "stg-orderrec"
          memory = "0.5Gi"
          cpu    = 0.25
          image  = "acrrecord.azurecr.io/trading-stg-orderreciever:latest"
          #image = "acrrecord.azurecr.io/counting-service:0.0.2"
          env = [
            {
              name  = "ConnectionStrings__AppConfig"
              value = "https://stg-uat-record-appconf-00.azconfig.io"
            },
            {
              name  = "ConnectionStrings__AppConfigCommon"
              value = "https://uat-record-appconf-common-00.azconfig.io"
            },
            {
              name  = "DOTNET_ENVIRONMENT"
              value = "UAT"
            }

          ]
        },
      ]
      min_replicas = 1
      max_replicas = 1
    }

    identity = {
      type = "SystemAssigned, UserAssigned"
    }

    registry = [
      {
        server = "acrrecord.azurecr.io"
      }
    ]

  },

}

container_apps_ingress = {

  staging-api = {
    name          = "staging-api-00"
    revision_mode = "Single"

    template = {
      containers = [
        {
          name   = "staging-api"
          memory = "0.5Gi"
          cpu    = 0.25
          image  = "acrrecord.azurecr.io/trading-stg-api:latest"
          #image = "acrrecord.azurecr.io/counting-service:0.0.2"
          env = [

            {
              name  = "ConnectionStrings__AppConfig"
              value = "https://stg-uat-record-appconf-00.azconfig.io"
            },
            {
              name  = "ConnectionStrings__AppConfigCommon"
              value = "https://uat-record-appconf-common-00.azconfig.io"
            },
            {
              name  = "DOTNET_ENVIRONMENT"
              value = "UAT"
            }

          ]

        },
      ]
      min_replicas = 1
      max_replicas = 1
    }

    identity = {
      type = "SystemAssigned, UserAssigned"
    }

    registry = [
      {
        server = "acrrecord.azurecr.io"
      }
    ]

    ingress = {
      allow_insecure_connections = true
      external_enabled           = true
      target_port                = 80
      traffic_weight = {
        latest_revision = true
        percentage      = 100
      }
      /*
      ip_security_restrictions = [
        {
          "name" : "Russ",
          "description" : "SE10 Home",
          "ip_address_range" : "2.122.154.36",
          "action" : "Allow"
        },
        {
          name             = "GPS"
          description      = "London Office"
          ip_address_range = "80.169.29.134"
          action           = "Allow"
        }
      ]
      */
      ip_security_restrictions = []
    }
  },

}
