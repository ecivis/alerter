component {

    /**
    * The purpose of the TemplateProcessor is simply to prevent the included template from tampering with the caller's scope.
    */
    public TemplateProcessor function init(struct data) {
        variables.clear();
        if (arguments.keyExists("data")) {
            variables.append(arguments.data);
        }
        return this;
    }

    public string function process(required string template) {
        var content = "";

        savecontent variable="content" {
            include arguments.template;
        }

        return content;
    }

}