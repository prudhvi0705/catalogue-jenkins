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
        stage('Test') {
            steps {
                script{
                    sh """
                    echo "This is the test stage"
                    echo $COURSE
                    """
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