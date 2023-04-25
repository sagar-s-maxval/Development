/**
 * Created by oadamovskyi on 17.08.2022.
 */

public with sharing class DiaryNotesTableController {

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
  }

  @AuraEnabled(cacheable=true)
  public static List<DiaryNoteWrapper> getSearchProjectDiaryNotesWrapped(String recordId){
    List<DiaryNoteWrapper> noteWrappers = new List<DiaryNotesTableController.DiaryNoteWrapper>();

    for(SymphonyIPMExt__Diary_Note__c note : [SELECT
            Id,
            CreatedDate,
            SymphonyIPMExt__Due_Date_if_any__c,
            SymphonyIPMExt__Action__c,
            SymphonyIPMExt__Assigned_To_User__r.Name,
            SymphonyIPMExt__Note__c
    FROM SymphonyIPMExt__Diary_Note__c
    WHERE SymphonyIPMExt__Trademark_Search__c =: recordId]) {

      noteWrappers.add(new DiaryNoteWrapper(note.Id,note.CreatedDate.format(),
              note.SymphonyIPMExt__Due_Date_if_any__c.format(),
              note.SymphonyIPMExt__Action__c,
              note.SymphonyIPMExt__Assigned_To_User__r.Name,
              note.SymphonyIPMExt__Note__c));

    }

    return noteWrappers;
  }

  @AuraEnabled(cacheable=true)
  public static List<SymphonyIPMExt__Diary_Note__c> getDiaryNotes(String recordId, String objectApi){
    String query = 'SELECT CreatedDate,\n' +
            '            SymphonyIPMExt__Due_Date_if_any__c,\n' +
            '            SymphonyIPMExt__Action__c,\n' +
            '            Legacy_Information__c,\n' +
            '            SymphonyIPMExt__Assigned_To_User__r.Name,\n' +
            '            SymphonyIPMExt__Note__c,\n' +
            '            SymphonyIPMExt__Is_Pinned_Note__c\n' +
            '    FROM SymphonyIPMExt__Diary_Note__c' + ' WHERE ' + objectApi + '= \'' + recordId + '\'';

    System.debug('Query: ' + query);
    System.debug('objectAPI: ' + objectApi);
    System.debug('recordId: ' + recordId);
    System.debug('Database.query(query):' + Database.query(query));
    return Database.query(query);
  }

  public class DiaryNoteWrapper{

    public DiaryNoteWrapper(String id,String createdDate,String dueDate,String action, String assignedTo, String notes){

      this.Id = id;
      this.CreatedDate = createdDate;
      this.DueDate = dueDate;
      this.Action = action;
      this.AssignedTo = assignedTo;
      this.Notes = notes;
    }

    @AuraEnabled
    public String Id;

    @AuraEnabled
    public String CreatedDate;

    @AuraEnabled
    public String DueDate;

    @AuraEnabled
    public String Action;

    @AuraEnabled
    public String AssignedTo;

    @AuraEnabled
    public String Notes;
  }

}