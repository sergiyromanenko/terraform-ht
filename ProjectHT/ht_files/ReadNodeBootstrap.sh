#!/bin/bash

yum update -y
aws s3 sync --delete s3://{Name of S3 WordpPress code} /var/www/html