component {

    this.title  = "Alerter";
    this.author = "Joseph Lamoree";
    this.webURL = "https://github.com/ecivis/alerter";
    this.description = "A ColdBox Module for alerting on exception.";
    this.version = "0.0.1";
    this.dependencies = [];
    this.autoMapModels = false;
    this.cfmapping = "alerter";

    /**
    * Configure
    */
    public void function configure() {
        variables.settings = {
            "mail": {
                "from": "app@localhost",
                "to": "you@localhost",
                "subject": "[app.localhost] Exception Alert"
            }
        };
        variables.alerters = [];
    }

    /**
    * Fired when the module is registered and activated.
    */
    public void function onLoad() {
        var property = "";

        if (variables.settings.keyExists("mail")) {
            for (property in ["from", "to", "subject"]) {
                if (!variables.settings.mail.keyExists(property)) {
                    throw(type="alerter.InvalidConfigurationException", message="The mail settings in the Alerter configuration must contain the '#property#' property.");
                }
            }
            if (!variables.settings.mail.keyExists("templates")) {
                variables.settings.mail["templates"] = { "default": "/alerter/templates/exception.cfm" };
            } else if (!variables.settings.mail.templates.keyExists("default")) {
                throw(type="alerter.InvalidConfigurationException", message="The templates property in mail settings must contain one template named 'default'.");
            }

            variables.binder.map("mailAlerter@alerter")
                .to("alerter.MailAlerter")
                .initArg(name="config", value=variables.settings);

            variables.alerters.append("MailAlerter");
        }

        if (variables.alerters.len() == 0) {
            // I'm on the fence about whether this should prevent application startup. I guess it's better to fail early than fail late.
            throw(type="alerter.InvalidConfigurationException", message="It was not possible to configure any alerters.");
        }
    }

    /**
    * Fired when the module is unregistered and unloaded
    */
    public void function onUnload() {
    }

}