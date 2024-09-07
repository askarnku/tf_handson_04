#!/bin/bash

terraform init

terraform validate

terraform format

terraform apply --auto-approve

terraform output > infrastructure.txt