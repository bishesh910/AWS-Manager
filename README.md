# AWS Automation Script

This script automates common tasks related to Amazon Web Services (AWS) using the AWS Command Line Interface (CLI). It provides a menu-driven interface for users to perform actions such as creating EC2 instances, listing running EC2 instances, listing security groups, listing key pairs, terminating running EC2 instances, deleting security groups, and deleting key pairs.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Usage](#usage)
- [Features](#features)
- [Contributing](#contributing)
- [License](#license)

## Prerequisites

- **AWS CLI**: Ensure that the AWS CLI is installed and configured on your system. You can install it using the instructions provided [here](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html).
- **AWS Credentials**: Make sure you have valid AWS credentials configured with appropriate permissions to perform the desired actions.

## Usage

1. Clone the repository to your local machine:

    ```bash
    git clone <repository-url>
    ```

2. Navigate to the directory containing the script:

    ```bash
    cd aws-automation-script
    ```

3. Make the script executable:

    ```bash
    chmod +x aws_automation.sh
    ```

4. Run the script:

    ```bash
    ./aws_automation.sh
    ```

5. Follow the on-screen menu to select the action you want to perform and provide any necessary inputs when prompted.

## Features

- **Create an Instance**: Launches a new EC2 instance with user-specified parameters, including key pair, security group, and AMI image ID.
- **List Running EC2 Instances**: Displays a list of running EC2 instances along with their instance IDs and names (if available).
- **List Security Groups**: Lists all security groups in your AWS account.
- **List Key Pairs**: Lists all key pairs available in your AWS account.
- **Terminate Running EC2 Instances**: Allows you to terminate one or more running EC2 instances. You will be prompted to enter the instance IDs.
- **Delete Security Group**: Enables you to delete a specific security group by providing its ID.
- **Delete Key Pair**: Allows you to delete a key pair by providing its name.

## Contributing

I will be improving this code over time.
Contributions are welcome! If you have any suggestions, improvements, or new features to propose, feel free to open an issue or submit a pull request.

