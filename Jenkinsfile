pipeline{
    //Directives
    agent any
    tools {
        maven 'maven'
    }

    stages {
        // Specify various stages with in stages

        // stage 1. Build
        stage ('Build'){
            steps {
                sh 'mvn clean install package'
            }
        }

        // Stage2 : Testing
        stage ('Test'){
            steps {
                echo ' testing......'

            }
        }

        // Stage 3 : Publish the artifacts to nexus
        stage ('Publish to Nexus'){
            steps {
                nexusArtifactUploader artifacts: [[artifactId: 'MilkoDevOpsLab', classifier: '', file: 'target/MilkoDevOpsLab-0.0.4-SNAPSHOT.war', type: 'war']], credentialsId: '27a07191-eeea-46cb-897f-b5bba9a3332b', groupId: 'com.milkodevarona', nexusUrl: '54.226.98.229:8081', nexusVersion: 'nexus3', protocol: 'http', repository: 'milko-Snapshot', version: '0.0.4-SNAPSHOT'
            }
        }

        // Stage 4 : Publish the source code to Sonarqube
        stage ('Sonarqube Analysis'){
            steps {
                echo 'Source code published to Sonarqube for source code analysis'
                withSonarQubeEnv('sonarqube'){ // You can override the credential to be used
                     sh 'mvn sonar:sonar'
                }
            }
        }
    }
}