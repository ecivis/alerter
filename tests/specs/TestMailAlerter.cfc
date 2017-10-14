component extends="testbox.system.BaseSpec" {

    public function run() {

        describe("The MailAlerter", function () {

            it("should send a test exception alert", function () {
                var config = {
                    mail: {
                        from: "testbox@localhost",
                        to: "recipient@localhost",
                        subject: "[test] Exception Alert from Test Spec",
                        server: {
                            host: "127.0.0.1",
                            port: 10025
                        },
                        templates: {
                            default: "/alerter/templates/exception.cfm"
                        }
                    }
                };
                var extras = {
                    app: {
                        name: "Alerter Test Suite"
                    },
                    user: {
                        userId: "73fb5329-d82c-49bc-abc5-c6186a0458eb",
                        username: "testuser"
                    }
                };
                var mailAlerter = new alerter.MailAlerter(config);
                var exception = "null";

                try {
                    throw(type="alerter.TestException", message="A fake error occurred.");
                } catch (alerter.TestException e) {
                    exception = e;
                }

                mailAlerter.exceptionAlert(exception=exception, extras=extras);
            });
        });
    }

}