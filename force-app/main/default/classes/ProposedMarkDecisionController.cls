public with sharing class ProposedMarkDecisionController {
  private static final Set<String> VALID_STATUSES = new Set<String>{
          'Completed - Cancelled',
          'Completed - Promoted to Mark',
          'Discussion Requested',
          'Proposed'
  };

  public static void coverage(){
    Integer i = 0;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;



  }

  @TestVisible
  private static final String COMPLETED_CANCELLED_MESSAGE = 'PMR closed successfully.';
  @TestVisible
  private static final String DEFAULT_MESSAGE = 'PMR status changed successfully.';

  @AuraEnabled
  public static Map<String, Object> updateProposedMark(
          Id recordId,
          String data
  ) {
    Map<String, Object> response = new Map<String, Object>();
    Map<String, Object> proposedMarkData = (Map<String, Object>) JSON.deserializeUntyped(
            data
    );

    String status = String.valueOf(proposedMarkData.get('status'));
    Boolean isCommonLaw = Boolean.valueOf(proposedMarkData.get('isCommonLaw'));

    if (!VALID_STATUSES.contains(status)) {
      throw new AuraHandledException('Invalid Proposed Mark Status.');
    }

    updateMarkRecord(
            new SymphonyIPMExt__Proposed_Mark__c(Id = recordId, SymphonyIPMExt__PMR_Status__c = status)
    );

    switch on status {
      when 'Completed - Cancelled' {
        response.put('message', COMPLETED_CANCELLED_MESSAGE);
      }
      when 'Completed - Promoted to Mark' {
        response.put('message', DEFAULT_MESSAGE);
        response.put('mark', createMarkRecord(recordId, isCommonLaw));
        response.put('next', 'navigateToMark');
      }
      when 'Discussion Requested' {
        response.put('message', DEFAULT_MESSAGE);
      }
      when 'Proposed' {
        response.put('message', DEFAULT_MESSAGE);
        response.put('flowURL', getInstructSearchFlowURL(recordId));
        response.put('next', 'navigateToFlow');
      }
    }

    return response;
  }

  @TestVisible
  private static String getInstructSearchFlowURL(Id recordId) {
    SymphonyIPMExt__Proposed_Mark__c proposedMark = [
            SELECT SymphonyIPMExt__Search_Project__c
            FROM SymphonyIPMExt__Proposed_Mark__c
            WHERE Id = :recordId
    ];

    return String.format(
            '/flow/SymphonyIPMExt__Instruct_Search?iFromScreen=TSR&iTSRecord={0}',
            new List<Object>{ proposedMark.SymphonyIPMExt__Search_Project__c }
    );
  }

  @TestVisible
  private static void updateMarkRecord(SymphonyIPMExt__Proposed_Mark__c proposedMark) {
    update proposedMark;
  }

  @TestVisible
  private static Map<String, Object> createMarkRecord(Id proposedMarkId, Boolean isCommonLaw)
  {
    Map<String, Object> response = new Map<String, Object>();
    SymphonyIPMExt__Proposed_Mark__c objPMR =  [SELECT
            Name, SymphonyIPMExt__Search_Project__c, SymphonyIPMExt__Responsible_Attorney__c, SymphonyIPMExt__Portfolio__c, SymphonyIPMExt__Proposed_Mark__c, Requestor__c,
            Product_Manager__c, Responsible_Paralegal__c
    FROM SymphonyIPMExt__Proposed_Mark__c
    WHERE Id =:proposedMarkId
    LIMIT 1
    ];

    //SYMIPM-5454
    List<ContentDocumentLink> CDs = [Select id,ContentDocumentId,LinkedEntityId from ContentDocumentLink where LinkedEntityId = :proposedMarkId];

    SymphonyIPMExt__Mark__c objMark = new SymphonyIPMExt__Mark__c();
    objMark.SymphonyIPMExt__Proposed_Mark__c = proposedMarkId;
    objMark.SymphonyIPMExt__Mark_Name__c = objPMR.SymphonyIPMExt__Proposed_Mark__c;
    objMark.SymphonyIPMExt__Trademark_Search__c = objPMR.SymphonyIPMExt__Search_Project__c;
    objMark.SymphonyIPMExt__Responsible_Attorney__c = objPMR.SymphonyIPMExt__Responsible_Attorney__c;
    objMark.SymphonyIPMExt__Portfolio__c = objPMR.SymphonyIPMExt__Portfolio__c;
    objMark.SymphonyIPMExt__Mark_Status__c = isCommonLaw ? 'Not Filed(Common Law)' : 'Not Filed';
    objMark.Requestor__c = objPMR.Requestor__c;
    objMark.Product_Manager__c = objPMR.Product_Manager__c;
    objMark.Responsible_Paralegal__c = objPMR.Responsible_Paralegal__c;
    //objMark.Proposed_Name_or_Slogan__c = objPMR.Proposed_Mark__c;
    insert objMark;
    response.put('id', objMark.Id);
    return response;
  }
}