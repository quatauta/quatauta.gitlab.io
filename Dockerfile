FROM ruby:2.7.2-slim

ENV \
BUNDLE_DEPLOYMENT="true" \
BUNDLE_DISABLE_PLATFORM_WARNINGS="true" \
BUNDLE_FROZEN="true" \
BUNDLE_JOBS=8 \
DEBIAN_FRONTEND="noninteractive" \
MAKEOPTS="-j8"

RUN \
apt-get update -qq ; \
apt-get install -qq -y apt-utils build-essential curl ; \
apt-get upgrade -qq -y ; \
curl -sL https://deb.nodesource.com/setup_15.x | bash - ; \
apt-get install -qq -y nodejs ; \
apt-get clean -qq ; \
gem update ; \
gem install bundler
