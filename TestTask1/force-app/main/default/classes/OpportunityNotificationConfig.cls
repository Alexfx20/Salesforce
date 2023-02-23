/** description: This class is used as a default config storege to define opportunity stage and amount which trigger notification and sharings
    */

public with sharing class OpportunityNotificationConfig {
    private static final Integer DEFAULT_CRITICAL_AMOUNT = 10000;
    private static final String DEFAULT_STAGENAME = 'Needs Analysis';
    private static final String DEFAULT_USER_ROLE = 'Chief Manager';
    private static final String DEFAULT_NOTIFICATION_TYPE_NAME = 'Opportunity_Needs_Analisys';
    private static Opportunity_Notification__c notificationCustomSettings = Opportunity_Notification__c.getOrgDefaults();
    private static CustomNotificationType notificationType;
    private static Id defaultUserRoleId;

    public static Integer getCriticalAmount() {
        if (notificationCustomSettings.Critical_Amount__c == null) {
            return DEFAULT_CRITICAL_AMOUNT;
        }
        return Integer.ValueOf(notificationCustomSettings.Critical_Amount__c);
    }

    public static String getCriticalStage() {
        if (notificationCustomSettings.Opportunity_StageName__c == null) {
            return DEFAULT_STAGENAME;
        }
        return notificationCustomSettings.Opportunity_StageName__c;
    }

    public static String getUserRole() {
        if (notificationCustomSettings.User_Role_for_email_notification__c == null) {
            return DEFAULT_USER_ROLE;
        }
        return notificationCustomSettings.User_Role_for_email_notification__c;
    }

    public static Id getUserRoleIdToNotify() {
        if(defaultUserRoleId == null) {
            List<UserRole> roles = [SELECT Id FROM UserRole WHERE Name = :DEFAULT_USER_ROLE];
            if(!roles.isEmpty()) {
                defaultUserRoleId = roles.get(0).Id;
            } 
        }
        return defaultUserRoleId;
    }

    public static CustomNotificationType getNotificationType() {
        if(notificationType == null) {
            notificationType = [SELECT Id, MasterLabel, Description, DeveloperName FROM CustomNotificationType WHERE DeveloperName = :DEFAULT_NOTIFICATION_TYPE_NAME];
        }
        return notificationType;
    }

}