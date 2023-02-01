trigger OpportunityTrigger on Opportunity (after update) {
    System.debug('Trigger cpu ' + Limits.getCPUTime());
    new OpportunityTriggerManager().manage();
    System.debug('Trigger cpu ' + Limits.getCPUTime());

}