#!/bin/bash


me="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"

display_usage() { 
        echo "Example of usage:" 
        echo -e "bash $me  -o plan" 
        echo -e "bash $me  -o apply"
        echo -e "bash $me  -o destroy"
        } 

while getopts o: option
do
case "${option}"
in

o) OPERATION=${OPTARG};;

esac
done


if [ -z "$OPERATION" ]
then
      echo "OPERATION is empty"
          display_usage
          exit 1
else
      echo "OPERATION is NOT empty: $OPERATION"
fi



set -u
set -e

echo "terraform show setup"

terraform version
terraform providers

echo "terraform init"
terraform init --upgrade

#az account clear
#az login 

# get the current default subscription using show
az account show --output table


# set dafault  subscription 
az account set --subscription "MSDN 7 Platforms" 


# get the current default subscription using list
az account list --query "[?isDefault]"

# store the default subscription  in a variable
subscriptionId="$(az account list --query "[?isDefault].id" -o tsv)"
echo "subscriptionId : $subscriptionId"





echo "terraform validate"

echo terraform validate

echo "terraform fmt"

echo terraform fmt


echo "terraform plan for apply"
terraform plan  -var subscription_id=$subscriptionId -out main.tfplan 

terraform show -json main.tfplan  > plan.json

echo "terraform plan for destroy"
terraform plan --destroy -var subscription_id=$subscriptionId -out destroy.tfplan 

terraform show -json destroy.tfplan  > destroy.json

#echo "terraform graph"
#terraform graph -type=plan | dot -Tpng -o graph.png

if [ "$OPERATION" = "apply" ] ;
then

  
    
    export SP=$(az ad sp create-for-rbac --output json)
    export SP_ID=$(echo $SP | jq -r .appId)
    export SP_PASSWORD=$(echo $SP | jq -r .password)

    echo "Applying terraform ...";


    echo "terraform apply" 
    terraform apply -var subscription_id=${subscriptionId}  -var appId=${SP_ID} -var password=${SP_PASSWORD}

    terraform output -raw tls_private_key > id_rsa

    #Run terraform output to get the virtual machine public IP address.

    terraform output public_ip_address

    #Use SSH to connect to the virtual machine.

    #ssh -i id_rsa azureuser@<public_ip_address>

fi # of apply

if [ "$OPERATION" = "destroy" ] ;
then

    echo "Applying terraform ...";


    echo "terraform destroy" 
    terraform destroy -var subscription_id=$subscriptionId  



fi # of destroy




