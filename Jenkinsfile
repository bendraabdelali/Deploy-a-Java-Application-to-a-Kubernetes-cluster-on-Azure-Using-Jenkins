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
                    sh 'cd Java-Maven-App '
                    sh 'ls '
                    sh 'mvn build-helper:parse-version versions:set \
                        -DnewVersion=\\\${parsedVersion.majorVersion}.\\\${parsedVersion.minorVersion}.\\\${parsedVersion.nextIncrementalVersion} \
                        versions:commit -f ./Java-Maven-App/pom.xml'
                    def matcher = readFile('pom.xml') =~ '<version>(.+)</version>'
                    def version = matcher[0][1]
                    env.IMAGE_NAME = "$version-$BUILD_NUMBER"
                }
            }
        }

        stage('build image') {
            steps {
                script {
                    echo "building the docker image..."
                    // withCredentials([usernamePassword(credentialsId: 'docker-hub-repo', passwordVariable: 'PASS', usernameVariable: 'USER')]) {
                    //     sh "docker build -t nanajanashia/demo-app:${IMAGE_NAME} ."
                    //     sh "echo $PASS | docker login -u $USER --password-stdin"
                    //     sh "docker push nanajanashia/demo-app:${IMAGE_NAME}"
                    // }
                }
            }
        }
        stage('deploy') {
                // environment {
                //     AWS_ACCESS_KEY_ID = credentials('jenkins_aws_access_key_id')
                //     AWS_SECRET_ACCESS_KEY = credentials('jenkins_aws_secret_access_key')
                //     APP_NAME = 'java-maven-app'
                // }
                steps {
                    script {
                        echo 'deploying docker image...'
                        // sh 'envsubst < kubernetes/deployment.yaml | kubectl apply -f -'
                        // sh 'envsubst < kubernetes/service.yaml | kubectl apply -f -'
                    }
                }
            }
        // # make sure to add ignore plugin to jenkins to overide jenkins commit trriger the pipeline 
        // stage('commit version update') {
        //     steps {
        //         script {
        //             withCredentials([usernamePassword(credentialsId: 'gitlab-credentials', passwordVariable: 'PASS', usernameVariable: 'USER')]) {
                       
        //                 // git config here for the first time run
        //                 sh 'git config --global user.email "jenkins@example.com"'
        //                 sh 'git config --global user.name "jenkins"'

        //                 sh "git remote set-url origin https://${USER}:${PASS}@github.com/bendraabdelali/Deploy-a-Maven-application-to-a-Kubernetes-cluster-on-Azure-Using-Jenkins"
        //                 sh 'git add .'
        //                 sh 'git commit -m "ci: version bump"'
        //                 sh 'git push origin HEAD:jenkins-jobs'

        //             }
        //         }
        //     }
        // }
    }
}
