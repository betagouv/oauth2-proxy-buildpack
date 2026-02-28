# oauth2-proxy-buildpack

For usage example on scalingo, see https://github.com/betagouv/oauth2-deploy-demo

This is a fork of [splashlake/heroku-buildpack-oauth2-proxy](https://github.com/splashlake/heroku-buildpack-oauth2-proxy)

This buildpack adds authentication against an OAuth2 provider such as
GitHub or Google to your Scalingo application.

Authentication is provided by putting [oauth2-proxy](https://github.com/oauth2-proxy/oauth2-proxy)
in front of your application as a reverse proxy, allowing you to authenticate
users using OAuth2 without actually implementing OAuth2 in your applications
codebase.

One usecase is to ensure only users from your organization will be able to access static
files served with Heroku.

## Usage With Other Applications

For using this buildpack with your application, you need to do two things:

On the one hand, you need to set up the configuration for `oauth2-proxy`. The getting started section
describes this process for GitHub. For other providers, a look at the
[configuration Section](#configuration) and at the
[OAuth2 Provider Configuration documentation of oauth2-proxy](https://oauth2-proxy.github.io/oauth2-proxy).

On the other hand, you need to ensure that `oauth2-proxy` is run as a reverse proxy in front
of your actual application worker.

For that purpose, this buildpack installs a script `start_with_oauth2_proxy.sh`. This script
can be used as the `web` process and will pass any requests to the backend process specified as
its arguments.

For example, the `heroku-buildpack-static` has `/app/bin/boot` as entrypoint. Given that,
a usable `Procfile` to run it with the proxy looks as following:

```console
web: /app/bin/start_with_oauth2_proxy.sh /app/bin/boot
```

This will take care to start both `/app/bin/boot` and `oauth2-proxy` and to route any incoming
requests correctly.
