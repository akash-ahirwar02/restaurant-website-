# Restaurant Website — End-to-End DevOps CI/CD Pipeline

> A complete DevOps project demonstrating automated CI/CD pipeline using Jenkins, SonarQube, Docker, and GitHub — deployed on AWS EC2.

---

## Architecture Overview

<img width="688" height="440" alt="image" src="https://github.com/user-attachments/assets/3166ab16-b9d6-48ac-8b89-c35d0269477c" />


---

## Tech Stack

| Tool | Purpose | Server |
|------|---------|--------|
| **GitHub** | Source Code Management | Cloud |
| **Jenkins** | CI/CD Automation | AWS EC2 - Server 1 |
| **SonarQube** | Code Quality & Security Analysis | AWS EC2 - Server 2 |
| **Docker** | Containerization | AWS EC2 - Server 3 |
| **Docker Hub** | Container Image Registry | Cloud |
| **Nginx** | Web Server (inside container) | AWS EC2 - Server 3 |
| **AWS EC2** | Cloud Infrastructure | AWS |

---

## CI/CD Pipeline Flow

```
Step 1: Developer pushes code to GitHub
            ↓
Step 2: GitHub Webhook triggers Jenkins automatically
            ↓
Step 3: Jenkins pulls latest code from GitHub
            ↓
Step 4: SonarQube scans code for:
        • Bugs
        • Vulnerabilities
        • Code Smells
        • Security Hotspots
            ↓
Step 5: Quality Gate check
        • PASSED → Continue pipeline
        • FAILED → Pipeline stops, notify developer
            ↓
Step 6: Jenkins builds Docker image
        docker build -t erakash2000/restaurant-website:latest
            ↓
Step 7: Image pushed to Docker Hub
        docker push erakash2000/restaurant-website:latest
            ↓
Step 8: Jenkins SSH into Docker Server
            ↓
Step 9: Old container stopped & removed
            ↓
Step 10: New container started with latest image
         Website is LIVE!
```

---

## Infrastructure Setup

### Server 1 — Jenkins (CI/CD)
- **OS:** Ubuntu 22.04 LTS
- **Cloud:** AWS EC2
- **Installed:** Jenkins, Java 17, Docker, SonarScanner
- **Port:** 8080

### Server 2 — SonarQube (Code Quality)
- **OS:** Ubuntu 22.04 LTS
- **Cloud:** AWS EC2
- **Installed:** Docker, SonarQube (Docker container)
- **Port:** 9000

### Server 3 — Docker (Production)
- **OS:** Ubuntu 22.04 LTS
- **Cloud:** AWS EC2
- **Installed:** Docker
- **Port:** 80

---

## Project Structure

```
restaurant-website/
│
├── index.html          # Main HTML file
├── style.css           # Stylesheet
├── index.js            # JavaScript
├── img/                # Images
├── Dockerfile          # Docker configuration
└── README.md           # Project documentation
```

---

## Dockerfile

```dockerfile
FROM nginx:alpine

RUN addgroup -S appgroup && adduser -S appuser -G appgroup

COPY . /usr/share/nginx/html

RUN chown -R appuser:appgroup /usr/share/nginx/html

EXPOSE 80

USER appuser

CMD ["nginx", "-g", "daemon off;"]
```

---

## Jenkins Pipeline Script

```bash
# Variables
DOCKERHUB_USER="erakash2000"
IMAGE="$DOCKERHUB_USER/restaurant-website"

# Docker Hub Login
docker login -u $DOCKERHUB_USER -p $(cat /var/lib/jenkins/dockerhub_pass)

# Build Image
docker build -t $IMAGE:latest /var/lib/jenkins/workspace/restaurant\ web/

# Push to Docker Hub
docker push $IMAGE:latest

# Deploy on Docker Server
ssh -o StrictHostKeyChecking=no ubuntu@<DOCKER-SERVER-IP> "
  docker pull $IMAGE:latest &&
  docker stop restaurant-container || true &&
  docker rm restaurant-container || true &&
  docker run -d \
    --name restaurant-container \
    -p 80:80 \
    --restart always \
    $IMAGE:latest
"
```

---

## Screenshots

### Jenkins — Build Success
<img width="1336" height="566" alt="Screenshot_11" src="https://github.com/user-attachments/assets/d248a292-b422-4bed-8d6c-8aaccdfe10ea" />

### SonarQube — Code Quality Passed
<img width="1363" height="500" alt="Screenshot_1" src="https://github.com/user-attachments/assets/c2a22de9-2063-42aa-95d5-e479e43cae42" />

### Docker Hub — Image Pushed
<img width="1339" height="484" alt="Screenshot_3" src="https://github.com/user-attachments/assets/762c32f5-c897-4a90-ab05-e08dbe7efcfe" />

### Website Live on Browser
<img width="1352" height="670" alt="Screenshot_2" src="https://github.com/user-attachments/assets/22f1e5d0-5fe2-4ab9-b837-2d65119ab7e8" />


---

## SonarQube Analysis Results

| Metric | Result |
|--------|--------|
| **Bugs** | 0 |
| **Vulnerabilities** | 0 |
| **Code Smells** | 0 |
| **Security Rating** | A |
| **Reliability Rating** | A |
| **Lines of Code** | 577 |

---

## How to Run Locally

```bash
# Clone the repo
git clone https://github.com/erakash2000/restaurant-website.git

# Go to project directory
cd restaurant-website

# Build Docker image
docker build -t restaurant-website .

# Run container
docker run -d --name restaurant-website -p 80:80 restaurant-website

# Open browser
http://localhost
```

---

## Key Learnings

- Setting up Jenkins on AWS EC2
- Integrating GitHub Webhook with Jenkins for auto-trigger
- SonarQube code quality analysis and Quality Gate configuration
- Dockerizing a web application with Nginx
- Pushing Docker images to Docker Hub
- SSH-based remote deployment from Jenkins to Docker server
- End-to-end automated CI/CD pipeline

---

## Author

**Akash** — DevOps Engineer  

---

**If you found this helpful, please star this repository!**
