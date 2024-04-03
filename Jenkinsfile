pipeline {
    agent any
    
    environment {
        TF_VERSION = "1.0.0" // Specify your desired Terraform version
        GCP_CREDENTIALS = credentials('googlekey')
    }
    
    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/Saifzero7/Portfolio.git' // Replace with your Git repository URL
            }
        }
        
        stage('Terraform Init') {
            steps {
                script {
                    sh "wget -O terraform.zip https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip"
                    sh 'unzip terraform.zip -d /usr/local/bin'
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                script {
                    withCredentials([string(credentialsId: 'googlekey', variable: 'GOOGLE_APPLICATION_CREDENTIALS')]) {
                        sh 'terraform plan -out=tfplan'
                    }
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                script {
                    withCredentials([string(credentialsId: 'googlekey', variable: 'GOOGLE_APPLICATION_CREDENTIALS')]) {
                        sh 'terraform apply -auto-approve tfplan'
                    }
                }
            }
        }
    }
}
