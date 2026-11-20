import jenkins.model.*
import hudson.security.*
import jenkins.infra.*

// Pula o setup wizard
System.setProperty("jenkins.install.runSetupWizard", "false")

// Configura o security realm com o usuário admin/admin
def instance = Jenkins.getInstance()
def hudsonRealm = new HudsonPrivateSecurityRealm(false)
hudsonRealm.createAccount("admin", "admin")
instance.setSecurityRealm(hudsonRealm)

// Define a estratégia de autorização (qualquer usuário autenticado pode fazer tudo)
def strategy = new FullControlOnceLoggedInAuthorizationStrategy()
instance.setAuthorizationStrategy(strategy)
instance.save()
