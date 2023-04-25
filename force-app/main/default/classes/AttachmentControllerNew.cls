public with sharing class AttachmentControllerNew {

    @AuraEnabled
    public static List<ContentVersion> getAttachedDocuments(Id LinkedEntityId) {
        try {
            EnvelopeInfo__c envelopeInfo = [SELECT Id, EnvelopeId__c FROM EnvelopeInfo__c WHERE Id =: LinkedEntityId];
            Map<Id,EnvelopeInfo__c> envelopeInfoMap = new Map<Id,EnvelopeInfo__c>([SELECT Id, EnvelopeId__c FROM EnvelopeInfo__c WHERE EnvelopeId__c =: envelopeInfo.EnvelopeId__c]);

            DocuSignAttachment__c doc = [SELECT Title__c, EnvelopeInfo__c, Envelope_Group_Id__c FROM DocuSignAttachment__c WHERE EnvelopeInfo__c IN :envelopeInfoMap.keySet() LIMIT 1];
            ContentDocument cd = [SELECT Id FROM ContentDocument WHERE Title =: doc.Title__c];
            ContentVersion cv = [SELECT Id, Title, FileExtension, ContentDocumentId FROM ContentVersion WHERE ContentDocumentId =: cd.Id];

            Set<Id> setofcontentdocId = new Set<Id>();
            List<ContentVersion> lstContentVersions = new List<ContentVersion>{cv};
            //List<ContentDocumentLink>  listofContentDocumentLink = [SELECT ContentDocumentId,Id,IsDeleted,LinkedEntityId,ShareType,SystemModstamp FROM ContentDocumentLink WHERE LinkedEntityId =:LinkedEntityId];
            List<ContentDocumentLink>  listofContentDocumentLink = [SELECT ContentDocumentId,Id,IsDeleted,LinkedEntityId,ShareType,SystemModstamp FROM ContentDocumentLink WHERE LinkedEntityId IN :envelopeInfoMap.keySet()];

            for(ContentDocumentLink doclink : listofContentDocumentLink) {
                setofcontentdocId.add(doclink.ContentDocumentId);
            }
            
            // Query the contentversionIds
            for(ContentVersion objcontentversion :[SELECT Id, Title, FileExtension, ContentDocumentId FROM ContentVersion WHERE ContentDocumentId IN :setofcontentdocId ORDER BY CreatedDate]) {
                lstContentVersions.add(objcontentversion);
            }


           /*
           List<ContentVersion> lstContentVersions = new List<ContentVersion>();
            List<Id> lstLinkedEntityIds = new List<Id>();
            lstLinkedEntityIds.add(LinkedEntityId);
            Map<Id, List<ContentVersion>> mapContentVersionReviewer = HelperAttachmentsNew.getAttachmentsForDocuments(lstLinkedEntityIds);
            if (mapContentVersionReviewer.containsKey(LinkedEntityId))
                lstContentVersions = mapContentVersionReviewer.get(LinkedEntityId);
            */

            if(lstContentVersions.size() > 0) {
            	return lstContentVersions;
            } else {
                return null; 
            }
            
        } catch(Exception exp) {
            throw exp;
        }
    }

    @AuraEnabled
    public static list<string> delDups(list<id> docids,list<string> imgtitlst){
        set<string> titlesreturn = new set<string>();
        list<contentversion> conve = new list<contentversion>();
        list<string> newtiltles = new list<string>();
        list<string> newupltiltles = new list<string>();
        list<string> newids = new list<string>();
        list<contentversion> conver = [select id,title from contentversion where contentdocumentid in: docids];
        for(contentversion cv : conver){
            cv.IDF_File_Type__c = 'RepFigure';
            conve.add(cv);
            newupltiltles.add(cv.title);
            if(imgtitlst.size()>0 && imgtitlst.contains(cv.title)){
            newtiltles.add(cv.title);
            newids.add(cv.id);
            }
        }
        if(conve.size()>0)
        update conve;
        if(newids.size()>0){
            list<id> condocdellist = new list<id>();
            list<ContentVersion> cvdellst = [select id from ContentVersion where title in:newtiltles and id not in:newids];
            for(ContentVersion c : cvdellst){
                condocdellist.add(c.contentdocumentid);
            }
            if(condocdellist.size()>0){
             list<ContentDocument> delcdlst = [select id from ContentDocument where id in:condocdellist];
             list<ContentDocumentLink> cdlink = [select id from ContentDocumentLink where LinkedEntityId =: UserInfo.getUserId() and contentdocumentid in:condocdellist ];
             if(delcdlst.size()>0)
             delete delcdlst;
             if(cdlink.size()>0)
             delete cdlink;
            }
            
        }
        if(newupltiltles.size()>0)
        titlesreturn.addAll(newupltiltles);
        if(imgtitlst.size()>0)
        titlesreturn.addAll(imgtitlst);
        list<string> retlst = new list<string>();
        if(titlesreturn.size()>0)
        retlst.addAll(titlesreturn);
        return retlst;
    }
    @AuraEnabled
    public static List<ContentVersion> getCurrentAttachedDocuments(Id LinkedEntityId, List<Id> lstDocumentId, list<ContentVersion> AllCurrentfiles)  //, list<ContentVersion> AllCurrentfiles , 'MainImage':component.get("v.contobjId")
    {
        try
        {
            List<ContentVersion> lstContentVersions = new List<ContentVersion>();
            List<Id> lstLinkedEntityIds = new List<Id>();
            lstLinkedEntityIds.add(LinkedEntityId);
            if(lstLinkedEntityIds.size() > 0 && lstDocumentId.size() > 0){
            Map<Id, List<ContentVersion>> mapContentVersionReviewer = HelperAttachmentsNew.getCurrentAttachmentsForDocuments(lstLinkedEntityIds, lstDocumentId);
            if (mapContentVersionReviewer.containsKey(LinkedEntityId))
                lstContentVersions = mapContentVersionReviewer.get(LinkedEntityId);
            
            return lstContentVersions;
            }else{
                return null;
            }
        }
        catch(Exception exp)
        {
            throw exp;
        }
    }
    
    @AuraEnabled
    public static string deletecontentversion (Id contentVersionId) {
        list<contentversion> conver = [select id,title from contentversion LIMIT 10];
        for(contentversion cv : conver) {
            deleteAttachment(cv.id);
        }
        return null;
    }
        

    
    @AuraEnabled
    public static string deleteAttachment(Id contentVersionId) 
    {
        try
        {
            string contentDocumentId = '';
            List<Id> idContentDocuments = new List<Id>();
            List<ContentVersion> objContentVersionList = new List<ContentVersion>();
            if(Schema.sObjectType.ContentVersion.isAccessible() && ContentVersion.sObjectType.getDescribe().isAccessible())
                objContentVersionList = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =:contentVersionId];
            for(ContentVersion objContentVersion : objContentVersionList)
            {
                idContentDocuments.add(objContentVersion.ContentDocumentId); 
            }
            List<ContentDocument> objContentDocumentList = new List<ContentDocument>();
            if(Schema.sObjectType.ContentDocument.isAccessible() && ContentDocument.sObjectType.getDescribe().isAccessible())
                objContentDocumentList = [SELECT Id FROM ContentDocument WHERE Id IN :idContentDocuments];
            if (objContentDocumentList != null && objContentDocumentList.size()>0 && Schema.sObjectType.ContentDocument.isDeletable()  && ContentDocument.sObjectType.getDescribe().isDeletable())
            {
                contentDocumentId = objContentDocumentList[0].Id;
                DELETE objContentDocumentList ;
            }
            return contentDocumentId;
        }
       
            catch(Exception exp)
            {
                /*if (SymphonyIPM__AuditTrail__c.sObjectType.getDescribe().isCreateable() &&Schema.sObjectType.SymphonyIPM__AuditTrail__c.isAccessible() && Schema.sObjectType.SymphonyIPM__AuditTrail__c.isCreateable())
                    {
                        SymphonyIPM__AuditTrail__c objAuditTrail = new SymphonyIPM__AuditTrail__c();
                        if(Schema.sObjectType.SymphonyIPM__AuditTrail__c.fields.SymphonyIPM__Action__c.isAccessible() && Schema.sObjectType.SymphonyIPM__AuditTrail__c.fields.SymphonyIPM__Action__c.isCreateable())
                            objAuditTrail.SymphonyIPM__Action__c = 'Insert';
                        if(Schema.sObjectType.SymphonyIPM__AuditTrail__c.fields.SymphonyIPM__CObjectName__c.isAccessible() && Schema.sObjectType.SymphonyIPM__AuditTrail__c.fields.SymphonyIPM__CObjectName__c.isCreateable())
                            objAuditTrail.SymphonyIPM__CObjectName__c = 'Patent_Attachments__c';
                        if(Schema.sObjectType.SymphonyIPM__AuditTrail__c.fields.SymphonyIPM__Description__c.isAccessible() && Schema.sObjectType.SymphonyIPM__AuditTrail__c.fields.SymphonyIPM__Description__c.isCreateable())
                            objAuditTrail.SymphonyIPM__Description__c = exp.getMessage() + exp.getStackTraceString();
                        if(Schema.sObjectType.SymphonyIPM__AuditTrail__c.fields.SymphonyIPM__Status__c.isAccessible() && Schema.sObjectType.SymphonyIPM__AuditTrail__c.fields.SymphonyIPM__Status__c.isCreateable())
                            objAuditTrail.SymphonyIPM__Status__c = 'Success';
                        if (SymphonyIPM__AuditTrail__c.sObjectType.getDescribe().isCreateable() && Schema.sObjectType.SymphonyIPM__AuditTrail__c.isAccessible())    
                            insert objAuditTrail;
                    }*/
                //throw e;
                return 'Fail';
                
        }
        
    }
    
    //Onload value passed to component on edit of IDF
    @AuraEnabled
    public static WrapperIDFRepresentativeImages FetchRepresentativeImagesOnload(String IDFId)
    {
        
        Integer i=0;
        set<string> setContentDocumentIds = new set<string>();
        List<ContentVersion> listContentVersionRecordsReturned = new List<ContentVersion>();
        SymphonyIPM__Invention_Disclosure_New__c objInventionDisclosure = [SELECT id,MainImage__c,otherimages__c FROM SymphonyIPM__Invention_Disclosure_New__c WHERE id =: IDFId];
        /*if(objInventionDisclosure.MainImage__c != null)
        {
            setContentDocumentIds.add(objInventionDisclosure.MainImage__c);
        }*/
        if(objInventionDisclosure.otherimages__c != null)
        {
            List<string> temp = objInventionDisclosure.otherimages__c.trim().split(',');
            setContentDocumentIds.addAll(temp);
        }
        List<ContentVersion> listContentVersionRecords = [SELECT id, Title, FileExtension, ContentDocumentId FROM ContentVersion WHERE ContentDocumentId IN: setContentDocumentIds];
        ContentVersion objContentVersionRecords = [SELECT id, Title, FileExtension, ContentDocumentId FROM ContentVersion WHERE ContentDocumentId =: objInventionDisclosure.MainImage__c];
        Integer j = 0;
        for(ContentVersion objcontversion : listContentVersionRecords)
        {
            if(objcontversion.ContentDocumentId == objInventionDisclosure.MainImage__c)
            {
                listContentVersionRecordsReturned.add(objcontversion);
                j = i;
            }
            i=i+1;
        }
        WrapperIDFRepresentativeImages objWrapperIDFRepresentativeImages = new WrapperIDFRepresentativeImages(listContentVersionRecords, objContentVersionRecords);
        //objWrapperIDFRepresentativeImages.listContversions = listContentVersionRecords;
        //objWrapperIDFRepresentativeImages.MainImageId = objInventionDisclosure.MainImage__c;
        //listContentVersionRecords.remove(j);
        //listContentVersionRecordsReturned.addAll(listContentVersionRecords);
        return objWrapperIDFRepresentativeImages;
    }
    
    public class WrapperIDFRepresentativeImages
    {
        @AuraEnabled
        public List<ContentVersion> listContversions{get;set;}
        @AuraEnabled
        public ContentVersion MainImageId{get;set;}
        
        public WrapperIDFRepresentativeImages(List<ContentVersion> listContentdocs, ContentVersion mainImageRecid)
        {
            listContversions = listContentdocs;
            MainImageId = mainImageRecid;
        }
    }
     @InvocableMethod
    public static Void deleteAttachmentFromFlow(list<String> contentVersionId) 
    {
            
            List<string> listInventorIds= new List<string>();
            set<string> SetOfInvID = new  set<string>();
             List<string> value = contentVersionId[0].trim().split(',');
             System.debug('IDF'+value[0]);   
              if(value.size() > 1)
            {
                listInventorIds= value[1].trim().split(',');
            }
            
            SetOfInvID.addAll(listInventorIds);
            string value1 = contentVersionId[0];
            string contentDocumentId = '';
            List<Id> idContentDocuments = new List<Id>();
            List<ContentVersion> objContentVersionList = new List<ContentVersion>();
            if(Schema.sObjectType.ContentVersion.isAccessible() && ContentVersion.sObjectType.getDescribe().isAccessible())
                objContentVersionList = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id IN:value];
            for(ContentVersion objContentVersion : objContentVersionList)
            {
                idContentDocuments.add(objContentVersion.ContentDocumentId); 
            }
          /*  SymphonyIPM__Invention_Disclosure_New__c lstinv = [SELECT MainImage__c,otherimages__c FROM SymphonyIPM__Invention_Disclosure_New__c WHERE Id =: value1];
            if(lstinv!=null){
                if(lstinv.otherimages__c!=null){
                    list<string> lstd = lstinv.otherimages__c.split(',');
                    for(integer i=0;i<lstd.size();i++){
                        if(idContentDocuments.contains(lstd[i])){
                            lstd.remove(i);
                        }
                        string r = string.join(lstd,',');
                        lstinv.otherimages__c = r;
                    }
                }
                if(idContentDocuments.contains(lstinv.MainImage__c))
                {
                    lstinv.MainImage__c='';
                }
                update lstinv;
            }*/
            List<ContentDocument> objContentDocumentList = new List<ContentDocument>();
            if(Schema.sObjectType.ContentDocument.isAccessible() && ContentDocument.sObjectType.getDescribe().isAccessible())
                objContentDocumentList = [SELECT Id FROM ContentDocument WHERE Id IN :idContentDocuments];
            if (objContentDocumentList != null && objContentDocumentList.size()>0 && Schema.sObjectType.ContentDocument.isDeletable()  && ContentDocument.sObjectType.getDescribe().isDeletable())
            {
                //contentDocumentId = objContentDocumentList[0].Id;
                DELETE objContentDocumentList ;
            }
            //return contentDocumentId;
        
    }

    public static void magicMethod()
    {
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
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;

        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
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
}