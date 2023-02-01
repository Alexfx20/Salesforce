public with sharing class UserService {

   private static Map<Id, User> userWithManagerIdMap = new Map<Id, User>();
    
    public static Id getManagerId(Id userId) {
        User userObj = userWithManagerIdMap.get(userId);
        if(userObj == null) {
            userObj = [select id, ManagerId FROM User WHERE Id =:userId];
            userWithManagerIdMap.put(userObj.Id, userObj);
        }
         
        if(userObj.ManagerId == null) {
            handleManagerAbsence(userId);
        }
        return userObj.ManagerId;
    }

    public static List<Id> getUsersByRoles(Id roleId) {
        if(roleId == null) {
            handleRoleAbsence();
            return new List<Id>();
        }
        Map<Id, User> userMap = new Map<Id, User>([SELECT Id, UserRoleId FROM User WHERE UserRoleId =: roleId]);
        return new List<Id>(userMap.keySet());
    }

    private static void handleManagerAbsence(Id userId) {
        //TODO implement logging or other actions according requireents
        System.debug(LoggingLevel.INFO, 'user initiated opportunity update doesn\'t have managers. [user]:' + userId);
    }

    private static void handleRoleAbsence() {
        //TODO implement logging or other actions according requireents
        System.debug(LoggingLevel.INFO, 'user role note specified');
    }

}