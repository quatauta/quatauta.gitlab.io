# Static Site Editor Template for GitLab Pages

## How to publish the website

1. Edit the [data/config.yml](/data/config.yml) file and update the repository URL by replacing `<username>` with your GitLab username and `<project-name>` with the name of the project you've created. Example: `http://gitlab.com/john/blog`.
1. Commit and push the change to the repository.
1. In GitLab, visit the CI / CD -> Pipelines page for your project (accessible from the left-hand menu).
1. Click on the `Run pipeline` button, if there are no active pipelines running after pushing up your change.
1. Once the the pipeline has successfully finished, open the following URL in your browser: `https://<username>.gitlab.io/<project-name>`. Note that it might take 10-15 minutes before the website becomes available after the first successful pipeline has finished.


## How to use the Static Site Editor feature

1. Open `https://<username>.gitlab.io/<project-name>` link in your browser.
1. Click on `Edit this page` button on the bottom of the website.
1. Use the Static Site Editor to make changes to the content and save the changes by creating a merge request.
1. Merge your merge request to main branch.
1. GitLab CI will automatically apply changes to your website.

## Local development

1. Clone this project.
1. Download dependencies: `bundle install`. If you see an error that bundler is missing, then try to run `gem install bundler`.
1. Run the project: `bundle exec middleman`.
1. Open http://localhost:4567 in your browser.


## Useful information

[GitLab Pages default domain names](https://docs.gitlab.com/ee/user/project/pages/getting_started_part_one.html#gitlab-pages-default-domain-names)


## Learning Middleman

* Visit [Middleman website](https://middlemanapp.com)
* Take a look at [the documentation](https://middlemanapp.com/basics/install)
* Explore [the source code](https://github.com/middleman/middleman)
