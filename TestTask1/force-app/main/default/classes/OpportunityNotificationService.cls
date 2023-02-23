public with sharing class OpportunityNotificationService {

    public void notifyDirectManager(Opportunity opp, Set<String> managerIdSet, CustomNotificationType notificationType) {
        if (managerIdSet != null && !managerIdSet.isEmpty()) {
            this.sendCustomNotification(managerIdSet, opp.Id, notificationType, this.getCustomNotificationBody(opp));
        }
    }

    public void notifyManagersByRole(List<Opportunity> opportunities) {  
        Id roleId = OpportunityNotificationConfig.getUserRoleIdToNotify();
        List<Id> chiefManagerList = UserService.getUsersByRoles(roleId);
        if (chiefManagerList.isEmpty()) {
            this.handleRoleAbsence();
            return;
        }

        String opportunityListInfo = '';
        OpportunitySharingService sharingService = new OpportunitySharingService();
        for (Opportunity opp : opportunities) {
            sharingService.prepareForSharingWithUsers(opp, chiefManagerList, OpportunitySharingService.READ_ACCESS);
            opportunityListInfo += this.addToOpportunityListInfo(opp);
        }

        sharingService.shareRecords();
        String criticalAmount = String.valueOf(OpportunityNotificationConfig.getCriticalAmount());
        String emailBody = String.format(System.Label.Opportunity_Email_Body, new List<String>{criticalAmount, OpportunityNotificationConfig.getCriticalStage(), opportunityListInfo});
        this.sendEmail(chiefManagerList, System.Label.Opportunity_Email_Subject, emailBody);
    }
    
    private void sendCustomNotification(Set<String> userIds, Id objId, CustomNotificationType notificationType, String body) {
        Messaging.CustomNotification notification = new Messaging.CustomNotification();
        notification.setTitle(notificationType.MasterLabel);
        notification.setBody(body);
        notification.setNotificationTypeId(notificationType.Id);
        notification.setTargetId(objId);
        
        try {
            notification.send(userIds);
        }
        catch (Exception e) {
            System.debug(LoggingLevel.ERROR, 'Fail to Send Notification ' + e.getMessage());
            //TODO decide if record should be saved in case if failed to send notification
        }
    }

    private String getCustomNotificationBody(Opportunity opp) {
        String criticalAmount = String.valueOf(OpportunityNotificationConfig.getCriticalAmount());
        return String.format(System.Label.Bell_Notification_For_Opportunity, new List<String>{opp.Name, criticalAmount, OpportunityNotificationConfig.getCriticalStage()}); 
    }

    private void sendEmail(List<Id> userIds, String subject, String messageBody) {
        if (userIds.isEmpty() || String.isBlank(messageBody)) {
            return;
        }
        
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        for (Id userId : userIds) {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setTargetObjectId(userId);
            mail.setSubject(subject);
            mail.setHtmlBody(messageBody);
            mail.setSaveAsActivity(false);
            mails.add(mail);
        }
        
        Messaging.sendEmail(mails);
    }

    private String addToOpportunityListInfo(Opportunity opp) {
        return 'Id: ' + opp.Id + ' Name: ' + opp.Name + '<br>';
    }

    private void handleRoleAbsence() {
        //TODO implement logging or other actions according requireents
        System.debug(LoggingLevel.INFO, 'users with specified role not found [user role]: ' + OpportunityNotificationConfig.getUserRole());
    }

}