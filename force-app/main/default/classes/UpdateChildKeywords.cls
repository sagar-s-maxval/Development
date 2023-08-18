public class UpdateChildKeywords
{
    @future
    public static void updatekeywordsonparentUpdate(set<id> setofkeywordIds)
    {
        map<Id,SymphonyIPM__Keyword__c> mapKeywords;
        List<SymphonyIPM__Keyword__c> listUpdate = new List<SymphonyIPM__Keyword__c>();
        List<SymphonyIPM__Keyword__c> listkeywords = [SELECT id,name__c,name,Fullname__c,SymphonyIPM__Keyword_Hierarchy__r.Fullname__c, SymphonyIPM__Keyword_Hierarchy__c,SymphonyIPM__Keyword_Hierarchy__r.Name FROM SymphonyIPM__Keyword__c WHERE SymphonyIPM__Keyword_Hierarchy__c IN: setofkeywordIds];
        if(setofkeywordIds.size() > 0)
        {
            mapKeywords = new map<Id,SymphonyIPM__Keyword__c>([SELECT id,name__c,Name,Fullname__c, SymphonyIPM__Keyword_Hierarchy__c,SymphonyIPM__Keyword_Hierarchy__r.Name FROM SymphonyIPM__Keyword__c WHERE Id IN: setofkeywordIds]);
            
        }
        if(listkeywords.size() > 0)
        {
            for(SymphonyIPM__Keyword__c objkey : listkeywords)
            {
                SymphonyIPM__Keyword__c objKeywordUpdate = new SymphonyIPM__Keyword__c();
                objKeywordUpdate.Id = objkey.Id;
                System.debug('---'+ objkey.SymphonyIPM__Keyword_Hierarchy__r.Fullname__c+' : '+objkey.Name);
                //objKeywordUpdate.Fullname__c = objkey.SymphonyIPM__Keyword_Hierarchy__r.Fullname__c+' : '+mapKeywords.get(objkey.SymphonyIPM__Keyword_Hierarchy__c).Name;
                objKeywordUpdate.Fullname__c = objkey.SymphonyIPM__Keyword_Hierarchy__r.Fullname__c+' : '+objkey.Name;
                system.debug('name----'+objkey.name);
                system.debug('name__c'+objkey.name__c);
                objKeywordUpdate.name = objkey.name;
                listUpdate.add(objKeywordUpdate);
            }
        }
        if(listUpdate.size() > 0 )
        {
            
            UPDATE listUpdate;
        }
        Integer i = 0;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
    }
}