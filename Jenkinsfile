pipeline {
    //This is pre-build section
    agent {
        node {
            label 'jenkins-agent'
        }
    }
    //This is env section
    environment{
        COURSE="Jenkins"
        appVersion = ""
        ACC_ID = "450558841952"
        PROJECT = "roboshop"
        COMPONENT = "catalogue"
    }
    options{
        timeout(time: 10, unit:'MINUTES')
        disableConcurrentBuilds()
    }
    //This is the build
    stages {
        stage('Read version') {
            steps {
                script{
                    def packageJSON = readJSON file: 'package.json'
                    appVersion = packageJSON.version
                    echo "app version is : ${appVersion}"
                }
            }
        }
        //This is the Test
        stage('Install dependencies') {
            steps {
                script{
                    sh """
                        npm install
                    """
                }
            }
        }

        stage('test dependencies') {
            steps {
                script{
                    sh """
                        npm test
                    """
                }
            }
        }
        stage("sonar scanner") {
            environment {
                def scannerHome = tool 'sonar-8.0'
            }
            steps {
                script{
                    withSonarQubeEnv('sonar-server') {
                    sh  "${scannerHome}/bin/sonar-scanner"  
                    }
              }
            }
          }
        
        stage('Quality Gate') {
            steps {
                timeout(time: 1, unit: 'HOURS') {
                    // Wait for the quality gate status
                    // abortPipeline: true will fail the Jenkins job if the quality gate is 'FAILED'
                    waitForQualityGate abortPipeline: true 
                }
            }
        }
        stage('Build image') {
            steps {
                script{
                    withAWS(region:'us-east-1',credentials:'aws-creds') {
                    sh """                        
                        aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin ${ACC_ID}.dkr.ecr.us-east-1.amazonaws.com
                        
                        docker build -t ${ACC_ID}.dkr.ecr.us-east-1.amazonaws.com/${PROJECT}/${COMPONENT}:${appVersion} .
                        docker images
                        docker push ${ACC_ID}.dkr.ecr.us-east-1.amazonaws.com/${PROJECT}/${COMPONENT}:${appVersion}
                    """
                }
            }
        }
    }
        //This is deploy
        stage('Deploy') {
            // input {
            //     message "Should we continue?"
            //     ok "Yes, we should."
            //     submitter "alice,bob"
            //     parameters {
            //         string(name: 'PERSON', defaultValue: 'Mr Jenkins', description: 'Who should I say hello to?')
            //     }
            // }
            when {
                expression { "$params.DEPLOY" == "true" }
            }
            steps {
                script{
                    sh """
                    echo "This is the Deploy stage"
                    echo $COURSE
                    """
                }
            }
        }
    }
    //Auto-trigger

    post{
        always{
            echo "I Will run irrespective of result"
            cleanWs()
        }
        success{
            echo "This is success section"
        }

        failure{
            echo "This is failure section"
        }
        aborted{
            echo "This is aborted"
        }
    }
}