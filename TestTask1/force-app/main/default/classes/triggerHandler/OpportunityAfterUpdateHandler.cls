public with sharing class OpportunityAfterUpdateHandler extends TriggerHandler {
    
    public override void handleTrigger() {
        Map<Id, Opportunity> oldOpportunityMap = (Map<Id, Opportunity>) Trigger.oldMap;
        List<Opportunity> opportunitiesForNotification = new List<Opportunity>();
        OpportunityNotificationService oppNotificationService = new OpportunityNotificationService();
        for(Opportunity opp : (List<Opportunity>) Trigger.new) {
            if(shouldNotifyManagers(oldOpportunityMap.get(opp.Id), opp)) {
                opportunitiesForNotification.add(opp);
                oppNotificationService.notifyDirectManager(opp);
            }
        }
        
        if(!opportunitiesForNotification.isEmpty()) {
            oppNotificationService.notifyManagersByRole(opportunitiesForNotification);
        }
        
    }

    private Boolean shouldNotifyManagers(Opportunity oldOpp, Opportunity newOpp) {
        if(newOpp.Amount <= OpportunityNotificationConfig.getCriticalAmount()) { 
            return false;
        }

        if(newOpp.StageName != OpportunityNotificationConfig.getCriticalStage()) {
            return false;
        }

        return newOpp.StageName != oldOpp.StageName;
    }

}