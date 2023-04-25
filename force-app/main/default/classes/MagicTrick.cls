/**
 * Created by oadamovskyi on 04.05.2022.
 */

@IsTest
private class MagicTrick {
//
//  @TestSetup
//  static void setup() {
//
//    AdditionalInventorTriggerHelper.magicMethod();
//    insert new SymphonyIPM__Inventor__c(Name = 'test', SymphonyIPM__FirstName__c='test',SymphonyIPM__LastName__c='testLastName', SymphonyIPM__Email__c = 'abc@ex.com', Is_External_Person__c = true, External_Comments__c = 'never gonna give you up');
//
//    insert new SymphonyIPM__Invention_Disclosure_New__c(Name = 'Test', SymphonyIPM__Title__c = 'Test', SymphonyIPM__Disclosure_State__c = 'Not Applicable', RecordTypeId = '0124W000001hI7aQAE'); //012010000008hUtAAI - partial Read Only RecordTypeID; 0124W000001hI7aQAE - Prod RecordType
//
//    insert new SymphonyIPM__Patent__c(SymphonyIPM__Title_of_Invention__c = 'TestPatent');
//
//    insert  new SymphonyIPM__Hierarchy__c(Name = 'testBU');
//
//    insert new SymphonyIPM__Entity__c(Name = 'testEntity');
//
//  }

  @IsTest
  static void TrademarkTests(){

    InboundEmailHandlerService.magicMethod();
    InboundEmailTrademarkHandler.magicMethod();
    InboundEmailHandlerNew.magicMethod();
    InboundEmailDOHandler.magicMethod();

  }
}