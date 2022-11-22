module "aws-organization" {
  source = "../"

  aws_service_access_principals = ["sso.amazonaws.com"]
  organizational_units = [
        {
          name     = "dev",
          children = []
        },
        {
          name     = "shared",
          children = []
        },
      
  ]
  accounts = [
    {
      name                              = "root"
      email                             = "example@example.com"
      organizational_unit               = "Root" #this is Root organizational unit which is created by default
    },
    {
      name                              = "dev"
      email                             = "example+dev@example.com"
      organizational_unit               = "dev"
    },
    {
      name                              = "shared"
      email                             = "example+exampprodle@example.com"
      organizational_unit               = "prod"
    }
  ]
}