pipeline {
  agent any
 
  tools {nodejs "node"}
  
  stages {
    
    stage('Build') {
      steps {
        sh '''
          echo "Building App..."
          echo "Build complete!"
        '''
      }
    }
    stage('SonarQube') {
      steps {
        sh '''
          echo "Performing Linting...."
          echo "Quality gate passed!"
        '''
      }
    }
    stage('Build Test'){
      steps {
        sh '''
          echo "Performing App Tests..."
          echo "App Testing complete!"
        '''
      }
    }
    stage('Archive') {
      steps {
        fileOperations (
          [
            fileZipOperation('src')
          ]
        )
        rtUpload (
          serverId: "Artifactory Demo Server",
          spec:
            """{
              "files": [
                  {
                    "pattern": "src.zip",
                    "target": "generic-local/demo/json-server/1.0.${env.BUILD_NUMBER}/"
                  }
                ]
            }""",
          failNoOp: true
        )
      }
    }
    stage('Fetch'){
      steps {
        rtDownload (
          serverId: "Artifactory Demo Server",
          spec:
            """{
              "files": [
                {
                  "pattern": "generic-local/demo/json-server/1.0.${env.BUILD_NUMBER}/src.zip",
                  "target": "/",
                  "flat": "false"
                }
              ]
            }"""
        )
      }
    }
    stage('Deploy'){
      steps {
        sshPublisher (
          publishers: [
            sshPublisherDesc (
              configName: 'DemoAipPais',
              transfers: [
                sshTransfer (
                  cleanRemote: false,
                  excludes: '',
                  execCommand: '/home/jenkins/demo/json-server/start.sh',
                  execTimeout: 120000,
                  flatten: false,
                  makeEmptyDirs: false,
                  noDefaultExcludes: false,
                  patternSeparator: '[, ]+',
                  remoteDirectory: 'json-server',
                  remoteDirectorySDF: false,
                  removePrefix: '',
                  sourceFiles: 'src.zip, db.json, start.sh'
                )
              ],
              usePromotionTimestamp: false,
              useWorkspaceInPromotion: false,
              verbose: false
            )
          ]
        )
      }
    }
    stage('System Test'){
      steps {
        sh '''
          echo "Performing System Tests..."
          echo "System Tests passed!"
        '''
      }
    }
  }
}
