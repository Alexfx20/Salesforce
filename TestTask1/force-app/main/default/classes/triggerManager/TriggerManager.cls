public with sharing class TriggerManager {
    public static Boolean stopAllTriggers = false;

    private Map<System.TriggerOperation, TriggerHandler> triggerHandlerByTypeMap = new Map<System.TriggerOperation, TriggerHandler>();

    public void manage() {
        if(this.shouldRunTrigger()) {
            TriggerHandler handler = this.triggerHandlerByTypeMap.get(Trigger.operationType);
            if(handler == null) {
                throw new TriggerHandler.TriggerHandlerException('Register trigger handler for the following operationType: ' + Trigger.operationType);
            }
            handler.handleTrigger();
        }
    }

    public TriggerManager registerTriggerHandler(System.TriggerOperation operationType, TriggerHandler handler) {
        this.triggerHandlerByTypeMap.put(operationType, handler);
        return this;
    }

    private Boolean shouldRunTrigger() {
        //In Addition Custom settings prop can be added to stop triggers from UI
        return !TriggerManager.stopAllTriggers;
    }

}