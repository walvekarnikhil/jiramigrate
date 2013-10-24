jiramigrate
===========

A tool to help in migrating JIRA cases from existing setup to new setup.

Jira installation provides way to import data using backup & restore. But in my case that was not possible.
CSV import was another option but there was no standard way to preserve comments & attachments.

This tool uses JIRA cli internally to export data into single CSV file, which then can be imported using CSV import.
