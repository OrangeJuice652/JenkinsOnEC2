import jenkins.model.*

def instance  = Jenkins.getInstance()
def plugins   = [
    "ant",
    "antisamy-markup-formatter",
    "apache-httpcomponents-client-4-api",
    "asm-api",
    "aws-device-farm",
    "bootstrap5-api",
    "bouncycastle-api",
    "branch-api",
    "build-timeout",
    "caffeine-api",
    "checks-api",
    "cloudbees-folder",
    "commons-lang3-api",
    "commons-text-api",
    "credentials",
    "credentials-binding",
    "dark-theme",
    "display-url-api",
    "durable-task",
    "echarts-api",
    "email-ext",
    "font-awesome-api",
    "git",
    "git-client",
    "github",
    "github-api",
    "github-branch-source",
    "gradle",
    "gson-api",
    "instance-identity",
    "ionicons-api",
    "jackson2-api",
    "jakarta-activation-api",
    "jakarta-mail-api",
    "javax-activation-api",
    "javax-mail-api",
    "jaxb",
    "jjwt-api",
    "joda-time-api",
    "jquery3-api",
    "json-api",
    "json-path-api",
    "junit",
    "ldap",
    "mailer",
    "matrix-auth",
    "matrix-project",
    "mina-sshd-api-common",
    "mina-sshd-api-core",
    "okhttp-api",
    "pam-auth",
    "pipeline-build-step",
    "pipeline-github-lib",
    "pipeline-graph-analysis",
    "pipeline-groovy-lib",
    "pipeline-input-step",
    "pipeline-milestone-step",
    "pipeline-model-api",
    "pipeline-model-definition",
    "pipeline-model-extensions",
    "pipeline-rest-api",
    "pipeline-stage-step",
    "pipeline-stage-tags-metadata",
    "pipeline-stage-view",
    "plain-credentials",
    "plugin-util-api",
    "resource-disposer",
    "scm-api",
    "script-security",
    "snakeyaml-api",
    "ssh-credentials",
    "ssh-slaves",
    "sshd",
    "structs",
    "theme-manager",
    "timestamper",
    "token-macro",
    "trilead-api",
    "variant",
    "workflow-aggregator",
    "workflow-api",
    "workflow-basic-steps",
    "workflow-cps",
    "workflow-durable-task-step",
    "workflow-job",
    "workflow-multibranch",
    "workflow-scm-step",
    "workflow-step-api",
    "workflow-support",
    "ws-cleanup"
]

pm = instance.getPluginManager()
uc = instance.getUpdateCenter()

uc.updateAllSites()

def enablePlugin(pluginName) {
  if (! pm.getPlugin(pluginName)) {
    deployment = uc.getPlugin(pluginName).deploy(true)
    deployment.get()
  }

  def plugin = pm.getPlugin(pluginName)
  if (! plugin.isEnabled()) {
    plugin.enable()
  }

  plugin.getDependencies().each {
    enablePlugin(it.shortName)
  }
}

plugins.each {
  def plugin = pm.getPlugin(it)
  enablePlugin(it)
}
