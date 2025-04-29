# Yii2 DevOps Assessment Project

This repository contains a complete DevOps setup for deploying a Yii2 PHP application on AWS using Docker Swarm, with NGINX as a reverse proxy, automated with Ansible, and continuous deployment via GitHub Actions.

## Architecture Overview

- **Application**: Yii2 PHP application running in Docker containers
- **Container Orchestration**: Docker Swarm for high availability
- **Reverse Proxy**: NGINX running on the host machine
- **CI/CD**: GitHub Actions for automated building and deployment
- **Infrastructure Automation**: Ansible for server setup and configuration

## Prerequisites

- AWS account with EC2 permissions
- Ubuntu 20.04 or 22.04 EC2 instance (t2.micro or larger recommended)
- Domain name pointing to your EC2 instance (optional but recommended)
- GitHub account
- Docker Hub account

## Setup Instructions

### 1. Fork and Clone this Repository

```bash
git clone https://github.com/your-username/yii2-devops-assessment.git
cd yii2-devops-assessment
```

### 2. Configure GitHub Secrets

Add the following secrets to your GitHub repository:

- `DOCKER_USERNAME`: Your Docker Hub username
- `DOCKER_TOKEN`: Your Docker Hub access token
- `SERVER_IP`: Your EC2 instance IP address
- `SSH_USER`: SSH username (usually 'ubuntu' for AWS Ubuntu instances)
- `SSH_PRIVATE_KEY`: Your private SSH key for accessing the EC2 instance

### 3. Update Configuration Files

1. Edit `ansible/inventory` and update the EC2 instance IP and SSH key path
2. Modify `ansible/roles/nginx/templates/yii2-app.conf.j2` and update the domain name if needed

### 4. Run the Ansible Playbook

```bash
cd ansible
ansible-playbook -i inventory playbook.yml
```

This will:
- Install Docker, Docker Compose, and NGINX
- Initialize Docker Swarm
- Configure NGINX as a reverse proxy
- Deploy the application stack

### 5. Verify Deployment

The CI/CD pipeline will be triggered automatically when you push changes to the main branch. To manually verify the deployment:

1. Check if the Docker Swarm services are running:
   ```bash
   ssh ubuntu@your-ec2-ip "docker service ls"
   ```

2. Visit your domain or EC2 IP in a browser to see the Yii2 application

## Testing the Deployment

1. Make a change to the application code
2. Commit and push to the main branch
3. Watch the GitHub Actions workflow execute
4. Verify the changes on your deployed site

## Assumptions

- The EC2 instance has a publicly accessible IP
- Ubuntu 20.04/22.04 is used as the operating system
- Ports 22, 80, and 443 are open in the security group
- The server has at least 1GB of RAM and 1 CPU core

## Monitoring (Optional Bonus)

To set up basic monitoring with Prometheus and Node Exporter:

1. Deploy the monitoring stack:
   ```bash
   docker stack deploy -c monitoring/docker-compose.yml monitoring
   ```

2. Access Prometheus at http://your-domain:9090 or http://your-ec2-ip:9090

## Troubleshooting

### Common Issues

1. **Docker Swarm Initialization Failed**
   - Check the network configuration
   - Ensure Docker is properly installed

2. **NGINX Not Proxying to Application**
   - Check NGINX configuration
   - Verify that the application container is running

3. **GitHub Actions Deployment Failed**
   - Verify GitHub secrets are correctly set
   - Check SSH connectivity to the EC2 instance

For more detailed troubleshooting, check the logs:
```bash
# Docker service logs
docker service logs yii2-app_app

# NGINX logs
sudo tail -f /var/log/nginx/yii2-error.log
```