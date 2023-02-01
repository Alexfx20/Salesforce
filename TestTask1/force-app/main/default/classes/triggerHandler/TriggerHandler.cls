public with sharing abstract class TriggerHandler {

    public abstract void handleTrigger();
    
    public class TriggerHandlerException extends Exception {}
    
}