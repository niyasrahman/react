# Must have `sentry-cli` installed globally
# Following variable must be passed in
#SENTRY_AUTH_TOKEN=7346c016185943a5a3ae0ff2e057c963402bd302d33647c9862ab87112b5d3fc

SENTRY_ORG=testorg-az
SENTRY_PROJECT=will-frontend-react
VERSION=`sentry-cli releases propose-version`
PREFIX=static/js

#echo $(VERSION)

setup_release: create_release associate_commits upload_sourcemaps

create_release:
	sentry-cli releases -o $(SENTRY_ORG) new -p $(SENTRY_PROJECT) $(VERSION)

# makes Sentry look at commits sitting on Sentry, and associates them to this Release that's getting pushed up
# "unassociated commits"
# set a release range, , because might cover more than what's on the release branch.
associate_commits:
	sentry-cli releases -o $(SENTRY_ORG) -p $(SENTRY_PROJECT) set-commits --auto $(VERSION)

upload_sourcemaps:
	sentry-cli releases -o $(SENTRY_ORG) -p $(SENTRY_PROJECT) files $(VERSION) \
		upload-sourcemaps --url-prefix "~/$(PREFIX)" --validate build/$(PREFIX)
