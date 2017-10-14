# Alerter

[![Master Branch Build Status](https://img.shields.io/travis/ecivis/alerter/master.svg?style=flat-square&label=master)](https://travis-ci.org/ecivis/alerter)

This is a ColdBox Module that makes receiving exception information (especially during development) pretty easy. It's handy when the application is an API, and putting full error information into the response isn't appropriate (or helpful).

Currently, the only supported alerting mechanism is email. This works well to communicate a lot of nicely formatted error information when connected to a development tool like [MailDev](https://www.npmjs.com/package/maildev). Perhaps in the future, other mechanisms will be implemented, such as [Loggly](https://www.loggly.com) and [Papertrail](https://papertrailapp.com/).

Be alert. The world needs more lerts.

## Requirements
- Lucee 5.2+
- ColdBox 4.3+
- Java 8+

## Installation

Install using [CommandBox](https://www.ortussolutions.com/products/commandbox):
`box install alerter --save`

## Usage

### MailAlerter

For a CFML engine that already has mail settings defined, just add the following to your `moduleSettings` in `Coldbox.cfc`:
```
alerter = {
    mail = {
        from = "app@localhost",
        to = "you@localhost",
        subject = "[app.localhost] Exception Alert"
    }
}
```

If you'd like to override existing mail settings (or if your CFML engine has no configured settings), specify the SMTP server information:
```
alerter = {
    mail = {
        from = "app@localhost",
        to = "you@localhost",
        subject = "[app.localhost] Exception Alert",
        server = {
            host = "127.0.0.1",
            port = 10025
        }
    }
}
```

If you'd like to use custom templates for generating the email message body, define them like so:
```
alerter = {
    mail = {
        from = "app@localhost",
        to = "you@localhost",
        subject = "[app.localhost] Exception Alert",
        templates = {
            default = "/MailStuff/ExceptionTemplate.cfm",
            special = "/MailStuff/ExceptionWithSpecialSauce.cfm"
        }
    }
}
```

Note that one of the templates must have the property name of 'default'.

Once the Alerter module is configured, get an instance of MailAlerter and use its `exceptionAlert()` method:
```
    property name="mailAlerter" inject="mailAlerter@alerter";

...

    try {
        thingService.riskyCall("foo");
    } catch(any e) {
        variables.mailAlerter.exceptionAlert(e);
    }
```

If you have a custom template and want to pass extra information for the email, call the `exceptionAlert()` method like so:
```
        variables.mailAlerter.exceptionAlert(
            exception=e,
            template="special",
            extras={"sauce":"Szechuan Chicken McNugget Sauce"});
```

In your custom template, `sauce` will be available in the variables scope.

## Tests

The package is configured such that tests can be executed within CommandBox using `testbox run`. The test specs expect an SMTP service at 127.0.0.1:10025. If you're using [MailDev](https://www.npmjs.com/package/maildev), start it for use with Alerter:
```
maildev --ip 127.0.0.1 --smtp 10025 --web 10080 --verbose
```

Mail received during the test execution will be visible using http://127.0.0.1:10080/

## License

See the [LICENSE](LICENSE.txt) file for license rights and limitations (MIT).
