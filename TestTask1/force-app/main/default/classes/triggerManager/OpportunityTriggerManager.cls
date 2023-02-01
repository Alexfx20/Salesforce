public with sharing class OpportunityTriggerManager extends TriggerManager {

    protected override TriggerHandler getHandler() {
        TriggerHandler handler;
        if(Trigger.operationType == TriggerOperation.AFTER_UPDATE) {
            handler = new OpportunityAfterUpdateHandler();
        }
        return handler;
    } 
    
}