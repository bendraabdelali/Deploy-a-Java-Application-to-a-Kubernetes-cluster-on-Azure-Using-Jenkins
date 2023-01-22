#!/usr/bin/env groovy
pipeline {
    agent any
    tools {
        maven 'Maven'
    }
    stages {
        stage('increment version') {
            steps {
                script {
                    echo 'incrementing app version...'
                    
                    sh 'mvn build-helper:parse-version versions:set \
                        -DnewVersion=\\\${parsedVersion.majorVersion}.\\\${parsedVersion.minorVersion}.\\\${parsedVersion.nextIncrementalVersion} \
                        versions:commit -f Java-Maven-App/pom.xml'
                    def matcher = readFile('Java-Maven-App/pom.xml') =~ '<version>(.+)</version>'
                    def version = matcher[0][1]
                    env.IMAGE_TAG = "$version-$BUILD_NUMBER"
                }
            }
        }

<<<<<<< HEAD
        stage('test and build app') {
=======
        stage('test, build app') {
>>>>>>> 97293cdfc671f44b7a30518b13079e2760405816
            steps {
                script {
                    echo "building the application..."
                    sh 'mvn clean package -f Java-Maven-App/pom.xml'
                }
            }
        }

<<<<<<< HEAD
        stage('build and Push image ') {
=======
        stage('build, and Push image ') {
>>>>>>> 97293cdfc671f44b7a30518b13079e2760405816
            steps {
                script {
                    echo "building the docker image..."

                     withDockerRegistry([ credentialsId: "docker-hub", url: "" ]) {
                       sh "docker build  -t abdbndr/maven-app:${IMAGE_TAG} ./Java-Maven-App/"
                        sh "docker push abdbndr/maven-app:${IMAGE_TAG}"
        
                    }
                }
            }
        }
        
        stage('deploy') {
                environment {
                    APP_NAME = 'myapp'
                    DOCKER_REPO='abdbndr/maven-app'
                }
                steps {
                    script {
                        echo 'deploying docker image...'
                        sh 'envsubst < KubernetsApp/deployment.yml | kubectl apply -f -'
                        sh 'envsubst < KubernetsApp/service.yml | kubectl apply -f -'
                    }
                }
            }
        // # make sure to add ignore plugin to jenkins to overide jenkins commit trriger the pipeline 
        stage('commit version update') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'github', passwordVariable: 'PASS', usernameVariable: 'USER')]) {
                       
                        // git config here for the first time run
                        sh 'git config --global user.email "jenkins@jenkins.com"'
                        sh 'git config --global user.name "jenkins"'

                        sh "git remote set-url origin https://${USER}:${PASS}@github.com/bendraabdelali/Deploy-a-Java-Application-to-a-Kubernetes-cluster-on-Azure-Using-Jenkins"
                        sh 'git add .'
                        sh 'git commit -m "ci: version bump"'
                        sh 'git push origin HEAD:main'

                    }
                }
            }
        }
    }
}


