jiramigrate
===========

A tool to help in migrating JIRA cases from existing setup to new setup.

Jira installation provides way to import data using backup & restore. But in my case that was not possible.
CSV import was another option but there was no standard way to preserve comments & attachments.

This tool uses JIRA cli internally to export data into single CSV file, which then can be imported using CSV import.


Setup
==========

-> Make sure you have jira cli downloaded and added into PATH
-> Make sure you have ruby installed and added into PATH

Running
==========

Usage: jira_export.rb [options]
    -s, --server_url server_url      Server URL
    -u, --user user                  User Name
    -p, --password password          Password
    -f, --filter filterid            Filter Id to be used for export

$>ruby jira_export.rb -s <server_url> -u <user> -p <password> -f <filter id>

All jira information will be exported to standard output in csv format. 
You can redirect output to a file and later use the file to import issues on destination JIRA server. Follow CSV import flow on destination JIRA server.
