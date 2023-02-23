public with sharing class OpportunitySharingService {
    List<OpportunityShare> opportunityShareList = new List<OpportunityShare>();
    public static final String READ_ACCESS = 'Read';
    public static final String EDIT_ACCESS = 'Edit';


    public void prepareForSharingWithUsers(Opportunity opp, List<Id> sharedUserIds, String accessRecordLevel) {
        if (opp == null || sharedUserIds == null || sharedUserIds.isEmpty() || this.isNotValidLevel(accessRecordLevel)) {
            throw new OpportunitySharingServiceException(
                'one of the params not specified: opportunity ' + opp + ' sharedUserIds ' + sharedUserIds + ' accessRecordLevel ' + accessRecordLevel
            );        
        }
        
        for (Id userId : sharedUserIds) {
            OpportunityShare opportunityShare = new OpportunityShare(
                OpportunityId = opp.Id, 
                UserOrGroupId = userId, 
                OpportunityAccessLevel = accessRecordLevel,
                RowCause = 'Manual'
            );
            this.opportunityShareList.add(opportunityShare);
        }
    }

    public void shareRecords() {
        if (!this.opportunityShareList.isEmpty()) {
            Database.insert(this.opportunityShareList, false); 
            //TODO process handle errors if any
        }
    }

    private Boolean isNotValidLevel(String accessRecordLevel) {
        return accessRecordLevel != READ_ACCESS && accessRecordLevel != EDIT_ACCESS;
    }

    public class OpportunitySharingServiceException extends Exception {}
}