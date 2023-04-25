public with sharing class DiaryNoteController
{
    @AuraEnabled
    public static List<SymphonyIPMExt__Diary_Note__c> getPinnedDiaryNotes(string FilterFieldAPIName, Id RecordId, boolean IsPinned)
    {
        Id UserId = UserInfo.getUserId();
        string strQuery ='';
        strQuery = strQuery + 'SELECT ';
        strQuery = strQuery + 'Id, Name, CreatedDate, SymphonyIPMExt__Due_Date_if_any__c, SymphonyIPMExt__Action__c, SymphonyIPMExt__Note__c, SymphonyIPMExt__Status__c';
        strQuery = strQuery + ', SymphonyIPMExt__Type__c, SymphonyIPMExt__Assigned_To_User__r.Name, SymphonyIPMExt__Assign_To_Office__r.Name, SymphonyIPMExt__Assigned_To_User_Text__c';
        strQuery = strQuery + ', SymphonyIPMExt__Closing_Summary__c, SymphonyIPMExt__Is_Pinned_Note__c, LastModifiedDate, CreatedBy.Name, LastModifiedBy.Name, Legacy_Information__c ';
        strQuery = strQuery + ' FROM SymphonyIPMExt__Diary_Note__c';
        strQuery = strQuery + ' WHERE ' + FilterFieldAPIName + ' = :RecordId' ;
        if (IsPinned)
            strQuery = strQuery + ' AND SymphonyIPMExt__Is_Pinned_Note__c = true';
        strQuery = strQuery + ' ORDER BY CreatedDate DESC';

        List<SymphonyIPMExt__Diary_Note__c> objDiaryNoteList = Database.query(strQuery);
        return objDiaryNoteList;
    }
    @AuraEnabled
    public static boolean UpdateStatus(Id[] DiaryNoteId, string ActionText) 
    {
        boolean IsSuccess = true;
        try
        {
            List<SymphonyIPMExt__Diary_Note__c> objDiaryNoteList = [
                SELECT Id, SymphonyIPMExt__Status__c, SymphonyIPMExt__Type__c
                FROM SymphonyIPMExt__Diary_Note__c
                WHERE Id IN :DiaryNoteId
            ];
            if (objDiaryNoteList != null && objDiaryNoteList.size()>0)
            {
                for(SymphonyIPMExt__Diary_Note__c objDiaryNote : objDiaryNoteList)
                {
                    if (objDiaryNote.SymphonyIPMExt__Type__c == 'Action')
                        objDiaryNote.SymphonyIPMExt__Status__c = ActionText;
                }
                UPDATE objDiaryNoteList ;
            }
        }
        catch(Exception exp)
        {
            IsSuccess = false;
        }
        return IsSuccess;
    }
    @AuraEnabled
    public static boolean PinUnPin(Id[] DiaryNoteId, boolean IsPinned) 
    {
        boolean IsSuccess = true;
        try
        {
            List<SymphonyIPMExt__Diary_Note__c> objDiaryNoteList = [
                SELECT Id, SymphonyIPMExt__Is_Pinned_Note__c
                FROM SymphonyIPMExt__Diary_Note__c
                WHERE Id IN :DiaryNoteId
            ];
            if (objDiaryNoteList != null && objDiaryNoteList.size()>0)
            {
                for(SymphonyIPMExt__Diary_Note__c objDiaryNote : objDiaryNoteList)
                {
                    objDiaryNote.SymphonyIPMExt__Is_Pinned_Note__c = IsPinned;
                }
                UPDATE objDiaryNoteList;
            }
        }
        catch(Exception exp)
        {
            IsSuccess = false;
        }
        return IsSuccess;
    }
}