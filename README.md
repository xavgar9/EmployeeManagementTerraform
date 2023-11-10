# Employee Management Application Migration to Google Cloud Platform

## Overview

This project involves the migration of a simple three-layer web application for employee management to Google Cloud Platform (GCP). The application consists of a frontend (React), a backend (Go), and a MySQL database. [Go here](https://github.com/xavgar9/EmployeeManagement) for more info.

The migration strategy employed for this project aligns with Gartner's recommended approach:

- **Rehost:** Involves redeploying applications to a different hardware environment while making changes to the application's infrastructure configuration without making significant changes to its architecture.

## Original Software architecture

The original software was built using API REST in a Layered Architecture.

<img src="https://user-images.githubusercontent.com/22827757/113381784-79c65680-9345-11eb-817a-4a336e877064.png" alt="drawing" width="320"/>

## Cloud Software architecture
The infrastructure for this application is deployed on Google Cloud Platform using Terraform. It includes a Compute Engine (VM) instance running three docker containers with necessary firewall rules to allow traffic on ports 3000 and 8080.

![arquitectura proyecto final](https://github.com/xavgar9/EmployeeManagementTerraform/assets/95549282/a64747ac-f883-4077-b8e5-969279ea35f0)

## Cloud Deployment
The Terraform configuration for the GCP resources can be found in the main.tf file. Extra variables can be found on variables.tf.

## Docker and Docker Compose
The application is containerized using Docker, and Docker Compose is used to manage the containers. The Docker images are pulled from the Docker Hub repository:

- Backend Image: [xavgar9/employee-management-backend:latest](https://hub.docker.com/repository/docker/xavgar9/employee-management-frontend)
- Frontend Image: [xavgar9/employee-management-frontend:latest](https://hub.docker.com/repository/docker/xavgar9/employee-management-backend)

