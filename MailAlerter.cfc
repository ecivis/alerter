component singleton {

    /**
    * @config All the configuration settings of the ColdBox Module
    */
    public MailAlerter function init(required struct config) {
        variables.config = arguments.config;

        return this;
    }

    /**
    * @exception A standard CFML exception structure
    * @template Optionally, specify a template name from configuration settings. If not provided, the default template will be used.
    * @extras Any additional data for rendering (perhaps the current user or some event information) can be passed to the template.
    * @throws alerter.UnknownTemplateException, alerter.TemplateNotFoundException
    */
    public void function exceptionAlert(required struct exception, string template="default", struct extras={}) {
        var file = "";
        var data = {};
        var templateProcessor = "null";
        var mailerService = "null";

        if (!variables.config.mail.templates.keyExists(arguments.template)) {
            throw(type="alerter.UnknownTemplateException", message="A template named '#arguments.template#' was not found in Alerter configuration settings.");
        }

        file = variables.config.mail.templates[arguments.template];
        if (!fileExists(file)) {
            throw(type="alerter.TemplateNotFoundException", message="A template file was not found at '#file#'.");
        }

        data["exception"] = arguments.exception;
        data.append(arguments.extras);
        templateProcessor = new TemplateProcessor(data);

        mailerService = new Mail(from=variables.config.mail.from, to=variables.config.mail.to, subject=variables.config.mail.subject, type="text/html");
        if (variables.config.mail.keyExists("server")) {
            if (variables.config.mail.server.keyExists("host") && variables.config.mail.server.host.len()) {
                mailerService.setServer(variables.config.mail.server.host);
            }
            if (variables.config.mail.server.keyExists("port") && val(variables.config.mail.server.port) != 0) {
                mailerService.setPort(variables.config.mail.server.port);
            }
        }
        mailerService.setBody(templateProcessor.process(file));
        mailerService.send();
    }

}