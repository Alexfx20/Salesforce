public with sharing class OpportunityNotificationService {

    public void notifyDirectManager(Opportunity opp) {
        Id managerId = UserService.getManagerId(opp.LastModifiedById);
        CustomNotificationType notificationType = OpportunityNotificationConfig.getNotificationType();
        if(managerId != null) {
            this.sendCustomNotification(new Set<String> {managerId}, opp.Id, notificationType, OpportunityNotificationConfig.getCustomNotificationBody(opp));
        }
    }

    public void notifyManagersByRole(List<Opportunity> opportunities) {  
        Id roleId = OpportunityNotificationConfig.getUserRoleIdToNotify();
        List<Id> chiefManagerList = UserService.getUsersByRoles(roleId);
        if(chiefManagerList.isEmpty()) {
            this.handleRoleAbsence();
            return;
        }
        String opportunityListInfo = '';

        OpportunitySharingService sharingService = new OpportunitySharingService();
        for(Opportunity opp : opportunities) {
            sharingService.prepareForSharingWithUsers(opp, chiefManagerList, OpportunitySharingService.READ_ACCESS);
            opportunityListInfo += this.addToOpportunityListInfo(opp);
        }

        sharingService.shareRecords();
        this.sendEmail(chiefManagerList, OpportunityNotificationConfig.getEmailSubject(), OpportunityNotificationConfig.getEmailBody(opportunityListInfo));
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

    private void sendEmail(List<Id> userIds, String subject, String messageBody) {
        if(userIds.isEmpty() || String.isBlank(messageBody)) {
            return;
        }
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        for(Id userId : userIds) {
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