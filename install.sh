#!/bin/bash
set -e

# Function to print messages in green
print_success() {
    echo -e "\033[0;32m$1\033[0m"
}

# Function to print messages in red
print_error() {
    echo -e "\033[0;31m$1\033[0m"
}

# Function to print messages in yellow
print_warning() {
    echo -e "\033[1;33m$1\033[0m"
}

# Function to print messages in blue
print_message() {
    echo -e "\033[1;34m$1\033[0m"  # Blue color for general messages
}

# Check if --check flag is passed
check_mode=""
for arg in "$@"; do
    if [[ "$arg" == "--check" ]]; then
        check_mode="--check"
        print_warning "Running in dry-run mode (--check enabled)."
    fi
done

# Confirmation prompt
print_message "This script requires privileged access to install necessary packages and perform configuration tasks."
read -p "Do you want to continue? This will require sudo privileges. (y/N) " response

# Prompt for sudo password
print_message "Please enter your sudo password to continue:"
read -s sudo_password

# Check the user's response
if [[ ! "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    print_message "Operation aborted by the user."
    exit 1
fi

# Check if Homebrew is installed
if ! command -v brew >/dev/null 2>&1; then
    print_warning "Homebrew is not installed. Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
    print_success "Homebrew installation completed."
else
    print_success "Homebrew is already installed."
fi

# Update Homebrew
print_warning "Updating Homebrew..."
brew update
print_success "Homebrew updated."

# Install Ansible
print_warning "Installing Ansible..."
brew install ansible

# Verify Ansible installation
if command -v ansible >/dev/null 2>&1; then
    print_success "Ansible successfully installed."
    ansible --version
else
    print_error "Failed to install Ansible."
    exit 1
fi

# Run Ansible Playbook
print_warning "Running Ansible playbook..."
ansible-playbook playbook.yml -v -e "ansible_sudo_pass=$sudo_password" $check_mode

# Check if the playbook execution was successful
if [ $? -eq 0 ]; then
    print_success "Ansible playbook executed successfully."
else
    print_error "Ansible playbook execution failed."
    exit 1
fi
