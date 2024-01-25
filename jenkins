node {
    def mavenHome=tool name: 'maven3.9.6'
    echo "job name is: ${env.JOB_NAME}"
    echo "node name is: ${env.NODE_NAME}"
    echo "jenkins home is: ${env.JENKINS_HOME}"
    echo "jenkins url is: ${env.JENKINS_URL}"
    properties([buildDiscarder(logRotator(artifactDaysToKeepStr: '', artifactNumToKeepStr: '5', daysToKeepStr: '', numToKeepStr: '5')), [$class: 'JobLocalConfiguration', changeReasonComment: ''], pipelineTriggers([pollSCM('* * * * *')])])
    try{
    stage('CheckOutCode'){
        slackNotification("STARTED")
        git branch: 'development', credentialsId: 'b305d05b-cea0-40b1-b11d-222dd32ff35a', url: 'https://github.com/digitalm2016/maven-web-application.git'
    }
    stage('build'){
        sh "${mavenHome}/bin/mvn clean package"
    }
    stage('ExcecuteSorarqubeReport'){
        sh "${mavenHome}/bin/mvn clean sonar:sonar"
    }
    stage('UploadArtifactIntoNexus'){
        sh "${mavenHome}/bin/mvn clean deploy"
    }
    stage('DeployAppIntoTomcatserver'){
        sshagent(['e78d991e-c76b-46c0-aa8b-9888ec3bb8b9']) {
   sh "scp -o StrictHostKeyChecking=no target/maven-web-application.war ec2-user@172.31.8.97:/opt/apache-tomcat-9.0.85/webapps/"
        }
    }
}
catch(e){
currentBuild.result="FAILURE"
throw e
}
finally{
slackNotification(currentBuild.result)
}
}
def slackNotification(String buildStatus = 'STARTED') {
  // build status of null means successful
  buildStatus =  buildStatus ?: 'SUCCESSFUL'

  // Default values
  def colorName = 'RED'
  def colorCode = '#FF0000'
  def subject = "${buildStatus}: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'"
  def summary = "${subject} (${env.BUILD_URL})"

  // Override default values based on build status
  if (buildStatus == 'STARTED') {
    color = 'YELLOW'
    colorCode = '#FFFF00'
  } else if (buildStatus == 'SUCCESSFUL') {
    color = 'GREEN'
    colorCode = '#00FF00'
  } else {
    color = 'RED'
    colorCode = '#FF0000'
  }

  // Send notifications
  slackSend (color: colorCode, message: summary)
}
