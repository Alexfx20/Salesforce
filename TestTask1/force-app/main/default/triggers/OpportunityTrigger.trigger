trigger OpportunityTrigger on Opportunity (after update) {
    new TriggerManager().
        registerTriggerHandler(TriggerOperation.AFTER_UPDATE, new OpportunityAfterUpdateHandler()).
        manage();
}