/** description: This class is used as a default config storege to define opportunity stage and amount which trigger notification and sharings
        all method should be rewriten to use custom settings values which should contain the following fields: amount, StageName, User Role
        All hardcoded notification/email parts which are exposed to the UI should be replaced with Custom Labels.
    */

public with sharing class OpportunityNotificationConfig {
    private static final Integer DEFAULT_CRITICAL_AMOUNT = 10000;
    private static final String DEFAULT_STAGENAME = 'Needs Analysis';
    private static final String DEFAULT_USER_ROLE = 'Chief Manager';
    private static final String DEFAULT_NOTIFICATION_TYPE_NAME = 'Opportunity_Needs_Analisys';
    private static final String DEFAULT_NOTIFICATION_MESSAGE = 'Opportunity: {0} with amount more than {1} moved to {2} Stage';
    private static final String DEFAULT_EMAIL_MESSAGE = 'Following Opportunities with amount more than {0} moved to {1} Stage';
    private static final String DEFAULT_EMAIL_SUBJECT = 'Opportybities need analisys';
    private static CustomNotificationType notificationType;
    private static Id defaultUserRoleId;
    
    public static Integer getCriticalAmount() {
        return DEFAULT_CRITICAL_AMOUNT;
    }

    public static String getCriticalStage() {
        return DEFAULT_STAGENAME;
    }

    public static String getUserRole() {
        return DEFAULT_USER_ROLE;
    }

    public static Id getUserRoleIdToNotify() {
        if(defaultUserRoleId == null) {
            List<UserRole> roles = [SELECT Id FROM UserRole WHERE Name =: DEFAULT_USER_ROLE];
            if(!roles.isEmpty()) {
                defaultUserRoleId = roles.get(0).Id;
            } 
        }
        return defaultUserRoleId;
    }

    public static CustomNotificationType getNotificationType() {
        if(notificationType == null) {
            notificationType = [SELECT Id, MasterLabel, Description, DeveloperName FROM CustomNotificationType WHERE DeveloperName=:DEFAULT_NOTIFICATION_TYPE_NAME];
        }
        return notificationType;

    }

    public static String getCustomNotificationBody(Opportunity opp) {
        String criticalAmount = String.valueOf(getCriticalAmount());
        return String.format(DEFAULT_NOTIFICATION_MESSAGE, new List<String>{opp.Name, criticalAmount, getCriticalStage()}); 
    }

    public static String getEmailBody(String bodyAppnedix) {
        String criticalAmount = String.valueOf(getCriticalAmount());
        String emailBody = String.format(DEFAULT_EMAIL_MESSAGE, new List<String>{criticalAmount, getCriticalStage()});
        return emailBody + '<br> Opportynities List: <br>' + bodyAppnedix;
    }

    public static String getEmailSubject() {
        return DEFAULT_EMAIL_SUBJECT;
    }
}