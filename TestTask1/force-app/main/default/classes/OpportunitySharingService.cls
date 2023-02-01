public with sharing class OpportunitySharingService {
    Map<String, List<OpportunityShare>> oppShareByAceessLevelMap = new Map<String, List<OpportunityShare>>();
    public static final String READ_ACCESS = 'Read';
    public static final String EDIT_ACCESS = 'Edit';


    public void prepareForSharingWithUsers(Opportunity opp, List<Id> sharedUserIds, String accessRecordLevel) {
        if(opp == null || sharedUserIds == null || sharedUserIds.isEmpty() || this.isNotValidLevel(accessRecordLevel)) {
            throw new OpportunitySharingServiceException(
                'one of the params not specified: opportunity ' + opp + ' sharedUserIds ' + sharedUserIds + ' accessRecordLevel ' + accessRecordLevel
            );        
        }
        List<OpportunityShare> opportunityShareList = new List<OpportunityShare>();
        for(Id userId : sharedUserIds) {
            OpportunityShare opportunityShare = new OpportunityShare(
                OpportunityId = opp.Id, 
                UserOrGroupId = userId, 
                OpportunityAccessLevel = accessRecordLevel,
                RowCause = 'Manual'
            );
            opportunityShareList.add(opportunityShare);
        }
        
        if(oppShareByAceessLevelMap.containsKey(accessRecordLevel)) {
            List<OpportunityShare> sharedRecords  = oppShareByAceessLevelMap.get(accessRecordLevel);
            sharedRecords.addAll(opportunityShareList);
        } else {
            oppShareByAceessLevelMap.put(accessRecordLevel, opportunityShareList);
        } 
    }

    public void shareRecords() {
        if(oppShareByAceessLevelMap.size() > 0) {
            List<OpportunityShare> allRecords = new List<OpportunityShare>();
            for(List<OpportunityShare> sharedListByAccess : oppShareByAceessLevelMap.values()) {
                allRecords.addAll(sharedListByAccess);
            }
            Database.insert(allRecords, false); 
            //TODO process handle errors if any
        }
    }

    private Boolean isNotValidLevel(String accessRecordLevel) {
        return accessRecordLevel != READ_ACCESS && accessRecordLevel != EDIT_ACCESS;
    }

    public class OpportunitySharingServiceException extends Exception {}
}