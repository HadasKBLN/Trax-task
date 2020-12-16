module "us-east-1" {
  source = "./modules/multi-region"
  morse_src_ami = "ami-074f4cc8490e50b3c"
  az_a = "us-east-1a"
  az_b = "us-east-1b"
  elb_name = "morse-us-east-1"
  identifier = "service-US"
  location = "North-America" // North America (NA)
  location_id = "US"
  providers = {
    aws = "aws"
  }
}

module "eu-west-2" {
  source = "./modules/multi-region"
  morse_src_ami = "ami-0a5603a22735b5723"
  az_a = "eu-west-2a"
  az_b = "eu-west-2b"
  elb_name = "morse-eu-west-2"
  identifier = "service-EU"
  location = "Defualt" // getting from all the rest
  location_id = "EU"
  providers = {
    aws = "aws.eu-west-2"
  }
}

module "ap-southeast-1" {
  source = "./modules/multi-region"
  morse_src_ami = "ami-00c574b8ca7f388b9"
  az_a = "ap-southeast-1a"
  az_b = "ap-southeast-1b"
  elb_name = "morse-ap-southeast-1"
  identifier = "service-AP"
  location = "South-America" // South America (SA)
  location_id = "AP"
  providers = {
    aws = "aws.ap-southeast-1"
  }
}