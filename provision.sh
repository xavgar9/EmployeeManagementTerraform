##########################################
# Install basic packages
##########################################
sudo apt update
sudo apt install -y build-essential
sudo apt install -y git


##########################################
# Install Docker
##########################################
# Install packages to allow apt to use a repository over HTTPS
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

# Add Docker’s official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - 

# The following command is to set up the stable repository
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu `lsb_release -cs` stable" 

# Update the apt package index, and install the latest version of Docker Engine and containerd, or go to the next step to install a specific version
sudo apt update 
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin


##########################################
# Clone and run the project
##########################################
echo "Cloning repo..."
git clone https://github.com/xavgar9/EmployeeManagement
cd EmployeeManagement

# Build the backend image
echo "Building backend image..."
docker pull xavgar9/employee-management-backend:latest

# Build the frontend image
echo "Building frontend image..."
pwd
docker pull xavgar9/employee-management-frontend:latest

# Run docker-compose
echo "Starting containers with docker-compose..."
docker-compose up -d


##########################################
# Run the migrations
##########################################
@echo "Running migration..."
sudo -u root docker exec -i db mysql -uroot -proot -e "CREATE DATABASE IF NOT EXISTS employeemanagement;"
sudo -u root docker exec -i db mysql -uroot -proot employeemanagement < ./Backend/scripts/CreateDB.sql
sudo -u root docker exec -i db mysql -uroot -proot employeemanagement < ./Backend/scripts/FunctionsProcedures.sql
sudo -u root docker exec -i db mysql -uroot -proot employeemanagement < ./Backend/scripts/ResetDB.sql