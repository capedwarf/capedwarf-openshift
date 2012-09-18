# Running CapeDwarf on OpenShift

Quickstart CapeDwarf application for OpenShift.

Follow this instructions to run Google AppEngine applications on OpenShift PaaS, using [CapeDwarf](http://www.jboss.org/capedwarf).

<!-- available soon 
TODO: check URL
The easiest way to install this application is to use the [OpenShift Instant Application](https://openshift.redhat.com/app/console/application_types/capedwarf).
If you'd like to install it manually, follow [these directions](#manual-installation).
-->
## Manual Installation ##

1. [Register](https://openshift.redhat.com/app/account/new) for OpenShift
1. Follow the [instructions](https://openshift.redhat.com/app/getting_started) to install client tools (step one)
1. Create a domain (step two on the link above)

1. Create JBoss AS applications:

        rhc app create -t jbossas-7 -a MyGaeApp

1. Remove JBossAS default sample application

        cd MyGaeApp
        rm -r src/main/webapp/*
        git add -A
        git commit -m"Sample app removed."
    
1. Use files from this github repo to add CapeDwarf modules to JBoss AS.  
Avoiding conflicts specify git options to prefer this repo content. 

        git remote add upstream https://github.com/openshift/capedwarf-example.git
        git pull -s recursive -X theirs upstream master


1. Push everything to OpenShift:

        git push origin master
        
   Operation takes a while to complete, OpenShift node is pulling in CapeDwarf.

1. Open your sample app in a web browser at MyGaeApp-\<your domain name\>.rhcloud.com, first time it takes about a minute to load all dependent modules.