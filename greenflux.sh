#!/bin/bash
# Passed validation in Cloud Shell 02/03/2022

# <FullScript>
# Create vNets for Greenflux Conatiner Instance & VMs

# Variable block
let "randomIdentifier=$RANDOM*$RANDOM"
location="East US"
resourceGroup="greenflux-virtual-network-rg-$randomIdentifier"
tag="greenflux-assignment"
vNet1="solar-impulse-test"
vNet2="solar-impulse-acc"
addressPrefixVNet1="10.1.0.0/16"
addressPrefixVNet2="10.2.0.0/16"
subnetTest="solar-impulse-test-subnet-$randomIdentifier"
subnetPrefixTest="10.1.1.0/24"
nsgTest="solar-impulse-test-nsg"
subnetAcc="solar-impulse-acc-subnet-$randomIdentifier"
subnetPrefixAcc="10.2.1.0/24"
nsgAcc="solar-impulse-acc-nsg"
VMName="SolarVM"
image="UbuntuLTS"
login="azureuser"
vmUser="ubuntu"
vmPass="msdocs-vm-sql$randomIdentifier"
ContainerName="solardnsmasq"
dnslabel="greenflux-assignment"
dnsimage="accts324/greenflux_dnsmasq:1.0"

echo "Using resource group $resourceGroup"

# Create a resource group
echo "Creating $resourceGroup in $location..."
az group create --name $resourceGroup --location "$location" --tags $tag

# Create a virtual network and a subnet for test.
echo "Creating $vNet1 and $subnetTest"
az network vnet create --resource-group $resourceGroup --name $vNet1 --address-prefix $addressPrefixVNet1  --location "$location" --subnet-name $subnetTest --subnet-prefix $subnetPrefixTest

# Create a virtual network and a subnet for Acc.
echo "Creating $vNet2 and $subnetAcc"
az network vnet create --resource-group $resourceGroup --name $vNet2 --address-prefix $addressPrefixVNet2  --location "$location" --subnet-name $subnetAcc --subnet-prefix $subnetPrefixAcc

# Create a TEST subnet.
echo "Creating $subnetTest"
az network vnet subnet create --address-prefix $subnetPrefixTest--name $subnetTest --resource-group $resourceGroup --vnet-name $vNet1

# Create a ACC subnet.
echo "Creating $subnetAcc"
az network vnet subnet create --address-prefix $subnetPrefixAcc --name $subnetAcc --resource-group $resourceGroup --vnet-name $vNet2

# Create a network security group (NSG) for the TEST subnet.
echo "Creating $nsgTest for $subnetTest"
az network nsg create --resource-group $resourceGroup --name $nsgTest--location "$location"

# Create a network security group (NSG) for the ACC subnet.
echo "Creating $nsgAcc for $subnetAcc"
az network nsg create --resource-group $resourceGroup --name $nsgAcc--location "$location"


# Create an NSG rule to allow traffic from the 195.169.110.175 to the ACC subnet.
echo "Creating NSG rule in $nsgAcc to allow MySQL traffic from 195.169.110.175"
az network nsg rule create --resource-group $resourceGroup --nsg-name $nsgAcc --name Allow-IP --priority 100 --source-address-prefixes 195.169.110.175/32 --source-port-ranges "*" --destination-address-prefixes '*' --destination-port-ranges 22 --access allow --protocol Tcp --description "Allow from specific IP address ranges on 22."

# Associate the backend NSG to the backend subnet.
echo "Associate $nsgAcc to $subnetAcc"
az network vnet subnet update --vnet-name $vNet2 --name $subnetAcc --resource-group $resourceGroup --network-security-group $nsgAcc

# Create a container instance on Test Subnet 
az container create --resource-group $resourceGroup --name $ContainerName --image $dnsimage --dns-name-label $dnslabel --ports 80

# Create a VM on the ACC subnet 
az vm create --name $VMName --resource-group $resourceGroup --image $image --admin-username $vmUser --admin-password $vmPass --vnet $vNet2 --subnet $subnetAcc


# </FullScript>

# echo "Deleting all resources"
# az group delete --name $resourceGroup -y