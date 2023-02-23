public with sharing class OpportunityAfterUpdateHandler extends TriggerHandler {
    
    public override void handleTrigger() {
        Map<Id, Opportunity> oldOpportunityMap = (Map<Id, Opportunity>) Trigger.oldMap;
        List<Opportunity> opportunitiesForNotification = new List<Opportunity>();
        OpportunityNotificationService oppNotificationService = new OpportunityNotificationService();
        Set<String> directManagerIdSet;
        Id directManagerId = UserService.getManagerId(UserInfo.getUserId());
        if (directManagerId != null) {
            directManagerIdSet = new Set<String> {directManagerId};
        }
        CustomNotificationType notificationType = OpportunityNotificationConfig.getNotificationType();
        for (Opportunity opp : (List<Opportunity>) Trigger.new) {
            if (shouldNotifyManagers(oldOpportunityMap.get(opp.Id), opp)) {
                opportunitiesForNotification.add(opp);
                oppNotificationService.notifyDirectManager(opp, directManagerIdSet, notificationType);
            }
        }
        
        if (!opportunitiesForNotification.isEmpty()) {
            oppNotificationService.notifyManagersByRole(opportunitiesForNotification);
        }
    }

    private Boolean shouldNotifyManagers(Opportunity oldOpp, Opportunity newOpp) {
        if (newOpp.Amount <= OpportunityNotificationConfig.getCriticalAmount()) { 
            return false;
        }

        if (newOpp.StageName != OpportunityNotificationConfig.getCriticalStage()) {
            return false;
        }

        return newOpp.StageName != oldOpp.StageName || newOpp.Amount != oldOpp.Amount;
    }

}