# Salesforce
The repo contains Salesforce code samples
----------------------------------------------------------------

Each TestTask folder represents the implimentation of individual task, solving particular buisness issue
Most of the Tasks aren't tested properly and may contain bugs.
Short description of buissness logic for each TestTask presented in this ReadMe file while 
specifics and defects of tech implementation is described in local ReadMe files of each folder

TestTask1 description:
When opportunity record is moved to 'Needs analisys' Stage and opportunity amount
is greater then 10000 custom notification is sent to the direct menager of the user initiated updated.
Opportunity record is shared with users who have the role of 'Cheaf Manager'. The email notification is send to the users of that Role.
