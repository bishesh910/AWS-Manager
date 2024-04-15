#!/bin/bash

# Check if AWS CLI is configured
aws configure list >/dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "AWS CLI is not properly configured. Please run 'aws configure' first."
    exit 1
fi

# Function to display menu
display_menu() {
    echo "Select an action:"
    echo "1. Create an Instance"
    echo "2. List running EC2 instances"
    echo "3. List security groups"
    echo "4. List key pairs"
    echo "5. Terminate running EC2 instances"
    echo "6. Delete security group"
    echo "7. Delete key pair"
    echo "8. Exit"
}

# Function to execute selected action
execute_action() {
    case $1 in
        1)  # Create an Instance
            echo "Creating an instance..."
            # Ask for key pair name
            read -p "Enter name for the key pair: " KEY_PAIR_NAME

            # Create a new EC2 key pair
            aws ec2 create-key-pair --key-name $KEY_PAIR_NAME --query 'KeyMaterial' --output text > $KEY_PAIR_NAME.pem
            chmod 400 $KEY_PAIR_NAME.pem

            # Ask for security group name and description
            read -p "Enter name for the security group: " SECURITY_GROUP_NAME
            read -p "Enter description for the security group: " SECURITY_GROUP_DESC

            # Create a new security group
            SECURITY_GROUP_ID=$(aws ec2 create-security-group --group-name $SECURITY_GROUP_NAME --description "$SECURITY_GROUP_DESC" --output text --query 'GroupId')

            # Get public IP
            MY_PUBLIC_IP=$(curl -s https://checkip.amazonaws.com)

            # Allow SSH access in the security group
            aws ec2 authorize-security-group-ingress \
                --group-id $SECURITY_GROUP_ID \
                --protocol tcp \
                --port 22 \
                --cidr $MY_PUBLIC_IP/32

            # Ask for AMI image ID
            read -p "Enter AMI image ID: " AMI_ID

            # Ask for instance name
            read -p "Enter name for the instance: " INSTANCE_NAME

            # Launch a t2.micro instance in the default VPC, with the created key pair, security group, and instance name tag
            aws ec2 run-instances \
                --image-id $AMI_ID \
                --instance-type t2.micro \
                --key-name $KEY_PAIR_NAME \
                --security-group-ids $SECURITY_GROUP_ID \
                --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$INSTANCE_NAME}]" \
                --associate-public-ip-address \
                --region us-east-1

            echo "Instance created successfully."
            ;;
        2)  # List running EC2 instances
            echo "Listing running EC2 instances:"
            aws ec2 describe-instances --filters Name=instance-state-name,Values=running --query "Reservations[*].Instances[*].{ID:InstanceId,Name:Tags[?Key=='Name'].Value|[0]}" --output table
            ;;
        3)  # List security groups
            echo "Listing security groups:"
            aws ec2 describe-security-groups --output table
            ;;
        4)  # List key pairs
            echo "Listing key pairs:"
            aws ec2 describe-key-pairs --output table
            ;;
        5)  # Terminate running EC2 instances
            echo "Terminating running EC2 instances..."
            echo "Enter instance IDs separated by space:"
            read -r instances
            aws ec2 terminate-instances --instance-ids $instances
            ;;
        6)  # Delete security group
            echo "Deleting security group..."
            echo "Enter security group ID:"
            read -r security_group_id
            aws ec2 delete-security-group --group-id $security_group_id
            ;;
        7)  # Delete key pair
            echo "Deleting key pair..."
            echo "Enter key pair name:"
            read -r key_pair_name
            aws ec2 delete-key-pair --key-name $key_pair_name
            ;;
        8)  # Exit
            exit 0
            ;;
        *)  # Invalid option
            echo "Invalid option!"
            ;;
    esac
}

# Main script
while true; do
    display_menu
    echo "Enter your choice:"
    read -r choice
    execute_action "$choice"
done
