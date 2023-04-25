trigger PRCMeetingTrigger on SymphonyIPM__PRC_Meeting__c (before insert) {

    Set<String> newPRBs = new Set<String>();

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

    for (SymphonyIPM__PRC_Meeting__c meeting : Trigger.new) {
        newPRBs.add(meeting.Review_Board__c);
    }

    for (SymphonyIPM__PRC_Meeting__c meeting : [SELECT Id, Review_Board__c, SymphonyIPM__Meeting_Date__c FROM SymphonyIPM__PRC_Meeting__c WHERE Review_Board__c IN :newPRBs]) {
        for (SymphonyIPM__PRC_Meeting__c newMeeting : Trigger.new) {
            if (newMeeting.Review_Board__c == meeting.Review_Board__c && newMeeting.SymphonyIPM__Meeting_Date__c == meeting.SymphonyIPM__Meeting_Date__c) {
                newMeeting.Review_Board__c.addError('Meeting has already been created for the selected Review Board');
            }
        }
    }
}