#prefix                           = "recordcm-record"
#azure_devops_organisation_target = "recordcm"
#azure_devops_project_target = "record"

resource_group_name = "record-stg-stg-dev"

container_apps_no_ingress = {

  mktdata-bloomberg-pub = {
    name          = "mktdata-bloomberg-pub-00"
    revision_mode = "Single"

    template = {
      containers = [
        {
          name   = "mktdata-bloomberg-pub"
          memory = "0.5Gi"
          cpu    = 0.25
          image  = "acrrecord.azurecr.io/mktdata-bloomberg-pub:latest"
          env = [
            {
              name  = "ConnectionStrings__AppConfig"
              value = "https://md-dev-record-appconf-00.azconfig.io"
            },
            {
              name  = "ConnectionStrings__AppConfigCommon"
              value = "https://dev-record-appconf-common-00.azconfig.io"
            },
            {
              name  = "DOTNET_ENVIRONMENT"
              value = "Development"
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

  refinitiv-publisher = {
    name          = "mktdata-refinitiv-pub-00"
    revision_mode = "Single"

    template = {
      containers = [
        {
          name   = "mktdata-refinitiv-publisher"
          memory = "0.5Gi"
          cpu    = 0.25
          image  = "acrrecord.azurecr.io/mktdata-refinitiv-pub:latest"

          env = [
            {
              name  = "ConnectionStrings__AppConfig"
              value = "https://md-dev-record-appconf-00.azconfig.io"
            },
            {
              name  = "ConnectionStrings__AppConfigCommon"
              value = "https://dev-record-appconf-common-00.azconfig.io"
            },
            {
              name  = "DOTNET_ENVIRONMENT"
              value = "Development"
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

  marketdata-static-receiver = {
    name          = "mktdata-statrec-00"
    revision_mode = "Single"

    template = {
      containers = [
        {
          name   = "marketdata-statrec"
          memory = "0.5Gi"
          cpu    = 0.25
          image  = "acrrecord.azurecr.io/mktdata-static-receiver:latest"

          env = [
            {
              name  = "ConnectionStrings__AppConfig"
              value = "https://md-dev-record-appconf-00.azconfig.io"
            },
            {
              name  = "ConnectionStrings__AppConfigCommon"
              value = "https://dev-record-appconf-common-00.azconfig.io"
            },
            {
              name  = "DOTNET_ENVIRONMENT"
              value = "Development"
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
  
  marketdata-monitor = {
    name          = "mktdata-monitor-00"
    revision_mode = "Single"

    template = {
      containers = [
        {
          name   = "marketdata-monitor"
          memory = "0.5Gi"
          cpu    = 0.25
          image  = "acrrecord.azurecr.io/counting-service:0.0.2"

          env = [
            {
              name  = "ConnectionStrings__AppConfig"
              value = "https://md-dev-record-appconf-00.azconfig.io"
            },
            {
              name  = "ConnectionStrings__AppConfigCommon"
              value = "https://dev-record-appconf-common-00.azconfig.io"
            },
            {
              name  = "DOTNET_ENVIRONMENT"
              value = "Development"
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

  marketdata-api = {
    name          = "mktdata-api-00"
    revision_mode = "Single"

    template = {
      containers = [
        {
          name   = "marketdata-api"
          memory = "0.5Gi"
          cpu    = 0.25
          image  = "acrrecord.azurecr.io/mktdata-api:latest"
          #image = "acrrecord.azurecr.io/counting-service:0.0.2"
          env = [
            {
              name  = "PORT"
              value = "80"
            },
            {
              name  = "ConnectionStrings__AppConfig"
              value = "https://md-dev-record-appconf-00.azconfig.io"
            },
            {
              name  = "ConnectionStrings__AppConfigCommon"
              value = "https://dev-record-appconf-common-00.azconfig.io"
            },
            {
              name  = "DOTNET_ENVIRONMENT"
              value = "Development"
            },
            {
              name  = "ServiceBusConnection__fullyQualifiedNamespace"
              value = "sb-record.servicebus.windows.net"
            },
            {
              name  = "SubscriptionMarketPricing"
              value = "pricing"
            },
            {
              name  = "TopicMarketPricing"
              value = "dev-fx-market"
            },
            {
              name  = "AZURE_FUNCTIONS_ENVIRONMENT"
              value = "DEVELOPMENT"
            },
            {
              name  = "AzureWebJobsStorage__accountname"
              value = "recordcmmktdatafunctions"
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

  marketdata-ui = {
    name          = "mktdata-ui-00"
    revision_mode = "Single"

    template = {
      containers = [
        {
          name   = "mktdata-ui"
          memory = "0.5Gi"
          cpu    = 0.25
          image  = "acrrecord.azurecr.io/marketdataui:latest"
          #image = "acrrecord.azurecr.io/counting-service:0.0.2"
          env = [
            {
              name  = "PORT"
              value = "80"
            },
            {
              name  = "ConnectionStrings__AppConfig"
              value = "https://md-dev-record-appconf-00.azconfig.io"
            },
            {
              name  = "ConnectionStrings__AppConfigCommon"
              value = "https://dev-record-appconf-common-00.azconfig.io"
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
