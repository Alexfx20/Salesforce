OpportunityNotificationConfig file determines opportunity amount and stage, which trigger notifications and sharing.
- All logic runs from the trigger synchronouslly. In case if any error occurs when sending custom notifications, it handles in try/catch and doesn't stop transaction while any error occured in send email logic isn't handled and results in transaction errors. This should be re-writen in the consistent manner - allow or stop transaction if any error occurs. 
- In case if user doesn't have direct manager, or chief manager role isn't exist, logic continues execution based on configured params, if any manager exist(direct or chief) they receive notifications.
- Sharing service is based on partial success dlm and doesn't have any logic preventing re-write of existing manual sharings (e.g. updating record with Edit mode to Read only mode may take place). Such logic should be added. Any errors e.g. inserting permissions which narrow org defaults not handled properly, such errors implicitly hiden by partiall success dmls. This should be changed to prevent known exceptions or at least error handling must be implimented to show explicitly errors during partial dml
- trigger may be stopped by changing static variable: stopAllTriggers in Trigger manager class. The method shouldRunTrigger should be modified to check specific value from custom settings to enable turning off all triggers from UI.
- Limit considerations: the following limits might be hit: daily custom notification limits, limit of inserted records - 10000. So, one opportunity record might be shared max with 10000 users, or 10000 records may be shared with single user.
- in case if the logic is a part of more complex app, domain and selector layers should be added
- code doesn't contain any test methods  

 
