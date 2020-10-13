# terraform-ht
It's home task tests with terraform and AWS.
Initial task description located in files inside folder ProjectHT/ht_files .
Read file - Home task stages.txt.

Not finished:
10. Optional!!! Register domain name in Route53.
13. Create AMI image for “Read” node;
15. Create AutoScaling Group with 2 instances by using “Read” node AMI 

Pre-requisites:

    You must have Terraform installed on your computer.
    You must have an Amazon Web Services (AWS) account.

Please note that this code was written for Terraform 0.13.x.

Quick start.

Please note that this example will deploy real resources into your AWS account. 
I have made every effort to ensure all the resources qualify for the AWS Free Tier, but some charges for RDS and S3 may incur.

Configure your AWS access keys as environment variables:

export AWS_ACCESS_KEY_ID=(your access key id)
export AWS_SECRET_ACCESS_KEY=(your secret access key)

Insert ssh public key to ProjectHT/Test/variables.tf :

variable "public_key" {
  #insert your pub key here for access to EC2 servers
  default = "ssh-rsa ...."
}

Deploy the code:

cd ProjectHT/Test/

terraform init
terraform plan
terraform apply

Clean up when you're done:

terraform destroy



