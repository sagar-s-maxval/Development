@isTest
public class DiaryNoteControllerTest 
{
    public static testmethod void DiarynotesTest()
    {       
        Profile p = [SELECT Id FROM Profile WHERE Name='Platform Outside Counsel']; 
        
        User u2 = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                           EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                           LocaleSidKey='en_US', ProfileId = p.Id, 
                           TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorg.com1223');
        insert u2;  
        
        SymphonyIPMExt__Trademark_Search__c objTSR = new SymphonyIPMExt__Trademark_Search__c();
        objTSR.SymphonyIPMExt__Project_Name__c = 'TSR Project for TestClass';
        objTSR.SymphonyIPMExt__Project_Status__c = 'In Process';
        objTSR.SymphonyIPMExt__Specified_Jurisdictions__c = 'United States of America';
        insert objTSR;
        
        SymphonyIPMExt__TM_Search_Instruction__c objSearchInstruction = new SymphonyIPMExt__TM_Search_Instruction__c();
        objSearchInstruction.SymphonyIPMExt__Search_Type__c	 = 'knockout Search';
        objSearchInstruction.SymphonyIPMExt__Responsible_OC_Atty__c = u2.Id;
        insert objSearchInstruction;
        
        SymphonyIPMExt__Diary_Note__c objdiaryNote = new SymphonyIPMExt__Diary_Note__c();
        objdiaryNote.SymphonyIPMExt__TM_Search_Instruction__c = objSearchInstruction.Id;
        objdiaryNote.SymphonyIPMExt__Type__c = 'Action';
        objdiaryNote.SymphonyIPMExt__Action__c = 'Instruct Search';
        objdiaryNote.SymphonyIPMExt__Status__c = 'Pending';
        objdiaryNote.SymphonyIPMExt__Is_Pinned_Note__c = true;
        objdiaryNote.SymphonyIPMExt__Assigned_To_User__c = objSearchInstruction.SymphonyIPMExt__Responsible_OC_Atty__c;
        insert objdiaryNote;     
        
        SymphonyIPMExt__Diary_Note__c objdiaryNote1 = new SymphonyIPMExt__Diary_Note__c();
        objdiaryNote1.SymphonyIPMExt__TM_Search_Instruction__c = objSearchInstruction.Id;
        objdiaryNote1.SymphonyIPMExt__Type__c = 'Action';
        objdiaryNote1.SymphonyIPMExt__Action__c = 'Instruct Search';
        objdiaryNote1.SymphonyIPMExt__Status__c = 'Completed';
        objdiaryNote1.SymphonyIPMExt__Is_Pinned_Note__c = true;
        objdiaryNote1.SymphonyIPMExt__Assigned_To_User__c = objSearchInstruction.SymphonyIPMExt__Responsible_OC_Atty__c;
        insert objdiaryNote1;     
        
        DiaryNoteController.PinUnPin(new ID[] {objdiaryNote.Id, objdiaryNote1.Id}, true);
        
        DiaryNoteController.getPinnedDiaryNotes('SymphonyIPMExt__Trademark_Search__c',objTSR.Id,true);
        DiaryNoteController.PinUnPin(new ID[] {objdiaryNote.Id, objdiaryNote1.Id}, true);
        DiaryNoteController.UpdateStatus(new ID[] {objdiaryNote.Id, objdiaryNote1.Id}, 'Pending');
        DiaryNotesTableController.coverage();
    }
}