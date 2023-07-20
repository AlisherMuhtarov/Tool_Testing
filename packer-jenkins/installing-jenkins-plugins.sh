#! /bin/bash

# Jenkins Server Configuration
url=$ip:8080
user=admin
password=jenkins123!

# Get Jenkins Crumb and Cookie
cookie_jar="$(mktemp)"
full_crumb=$(curl -u "$user:$password" --cookie-jar "$cookie_jar" $url/crumbIssuer/api/xml?xpath=concat\(//crumbRequestField,%22:%22,//crumb\))
arr_crumb=(${full_crumb//:/ })
only_crumb=$(echo ${arr_crumb[1]})

# Make the request to create an admin user
curl -X POST -u "admin:$password" $url/setupWizard/createAdminUser \
        -H "Connection: keep-alive" \
        -H "Accept: application/json, text/javascript" \
        -H "X-Requested-With: XMLHttpRequest" \
        -H "$full_crumb" \
        -H "Content-Type: application/x-www-form-urlencoded" \
        --cookie $cookie_jar \
        --data-raw "username=admin&password1=jenkins123!&password2=jenkins123!&fullname=admin%20root&email=hello@world.com&Jenkins-Crumb=$only_crumb&json=%7B%22username%22%3A%20%22admin%22%2C%20%22password1%22%3A%20%22jenkins123%21%22%2C%20%22%24redact%22%3A%20%5B%22password1%22%2C%20%22password2%22%5D%2C%20%22password2%22%3A%20%22jenkins123%21%22%2C%20%22fullname%22%3A%20%22admin%20root%22%2C%20%22email%22%3A%20%22hello@world.com%22%2C%20%22Jenkins-Crumb%22%3A%20%22$only_crumb%22%7D&core%3Aapply=&Submit=Save&json=%7B%22username%22%3A%20%22admin%22%2C%20%22password1%22%3A%20%22jenkins123%21%22%2C%20%22%24redact%22%3A%20%5B%22password1%22%2C%20%22password2%22%5D%2C%20%22password2%22%3A%20%22jenkins123%21%22%2C%20%22fullname%22%3A%20%22admin%20root%22%2C%20%22email%22%3A%20%22hello@world.com%22%2C%20%22Jenkins-Crumb%22%3A%20%22$only_crumb%22%7D"

# Make the request to download and install required Jenkins plugins
curl -X POST -u "$user:$password" $url/pluginManager/installPlugins \
  -H 'Connection: keep-alive' \
  -H 'Accept: application/json, text/javascript, */*; q=0.01' \
  -H 'X-Requested-With: XMLHttpRequest' \
  -H "$full_crumb" \
  -H 'Content-Type: application/json' \
  -H 'Accept-Language: en,en-US;q=0.9,it;q=0.8' \
  --cookie $cookie_jar \
  --data-raw "{'dynamicLoad':true,'plugins':['cloudbees-folder','antisamy-markup-formatter','build-timeout','credentials-binding','timestamper','ws-cleanup','ant','gradle','workflow-aggregator','github-branch-source','pipeline-github-lib','pipeline-stage-view','git','ssh-slaves','matrix-auth','pam-auth','ldap','email-ext','mailer'],'Jenkins-Crumb':'$only_crumb'}"