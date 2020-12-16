provider "aws" {
  region = "us-east-1" 
}

provider "aws" {
  alias  = "eu-west-2"
  region = "eu-west-2"
}

provider "aws" {
  alias  = "ap-southeast-1"
  region = "ap-southeast-1"
}