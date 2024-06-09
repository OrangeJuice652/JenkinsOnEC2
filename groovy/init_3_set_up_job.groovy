import jenkins.model.*

def instance  = Jenkins.getInstance()

def jobName = "FulutterBuildPipline"
def configXml = new File("~jenkins/FlutterBuildPipline.xml").text
def xmlStream = new ByteArrayInputStream( configXml.getBytes() )
instance.createProjectFromXML(jobName, xmlStream)