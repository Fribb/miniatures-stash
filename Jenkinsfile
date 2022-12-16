pipeline {
    agent {
        node {
            label 'Jenkins-Agent-VM'
        }
    }

    options {
        // This is required if you want to clean before build
        skipDefaultCheckout(true)
    }

    stages {

        stage('clean Workspace') {
            steps {
                cleanWs()
            }
        }

        stage('checkout') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: '*/develop']], extensions: [], userRemoteConfigs: [[credentialsId: 'Github', url: 'https://github.com/Fribb/miniatures-stash.git']]])
            }
        }

		stage('install') {
            steps {
                dir('./backend') {
                    nodejs('NodeJS 18.12.1') {
                        sh "npm install"
                    }
                }
                dir('./frontend-angular') {
                    nodejs('NodeJS 18.12.1') {
                        sh "npm install"
                    }
                }
            }
		}

        stage('frontend tests') {
            steps {
                dir('./frontend-angular') {
                    nodejs('NodeJS 18.12.1') {
                        sh "./node_modules/.bin/ng test"
                    }
                }
            }
        }

        stage('backend tests') {
            steps {
                dir('./backend') {
                    // create .env file
                    writeFile file: '.env', text: '''NODE_ENV=test
                        FRONTEND=http://localhost:4200'''

                    // run test
                    nodejs('NodeJS 18.12.1') {
                        sh "npm test"
                    }
                }
            }
        }

        stage('sonarqube analysis') {
            steps {
                dir('./frontend-angular') {
                    withSonarQubeEnv(credentialsId: "SonarQube", installationName: "SonarQube") {
                        nodejs('NodeJS 18.12.1') {
                            script {
                                def scanner = tool name: 'SonarQube Scanner 4.7', type: 'hudson.plugins.sonar.SonarRunnerInstallation'

                                sh "${scanner}/bin/sonar-scanner -D\"sonar.projectKey=Miniatures-Stash_frontend-angular_${env.BRANCH_NAME}\""
                            }
                        }
                    }
                }
                dir('./backend') {
                    withSonarQubeEnv(credentialsId: "SonarQube", installationName: "SonarQube") {
                        nodejs('NodeJS 18.12.1') {
                            script {
                                def scanner = tool name: 'SonarQube Scanner 4.7', type: 'hudson.plugins.sonar.SonarRunnerInstallation'

                                sh "${scanner}/bin/sonar-scanner -D\"sonar.projectKey=Miniatures-Stash_backend_${env.BRANCH_NAME}\""
                            }
                        }
                    }
                }
            }
        }
    }
}
