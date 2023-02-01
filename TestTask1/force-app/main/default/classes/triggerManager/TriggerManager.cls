public with sharing abstract class TriggerManager {
    public static Boolean stopAllTriggers = false;

    protected abstract TriggerHandler getHandler();

    public void manage() {
        if(this.shouldRunTrigger()) {
            TriggerHandler handler = this.getHandler();
            if(handler == null) {
                throw new TriggerHandler.TriggerHandlerException('Register trigger handler for the following operationType: ' + Trigger.operationType);
            }
            handler.handleTrigger();
        }
    }

    private Boolean shouldRunTrigger() {
        //In Addition Custom settings prop can be added to stop triggers from UI
        return !TriggerManager.stopAllTriggers;
    }

}