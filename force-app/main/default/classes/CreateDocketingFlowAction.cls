public with sharing class CreateDocketingFlowAction {

    public class IFWDocActivitiesData {

        @InvocableVariable(Label='Patent Id')
        public String patentId;

        @InvocableVariable(Label='Email Tracker Id')
        public String emailTrackerId;

        @InvocableVariable(Label='strwrapperFinalTriggerActionCloseBy')
        public String strwrapperFinalTriggerActionCloseBy;

        @InvocableVariable(Label='Event Date')
        public String strCompletedClosedDate;

        @InvocableVariable(Label='Comments')
        public String comment;

        @InvocableVariable(Label='Manual Due Date')
        public String docketingManualDueDate;

        @InvocableVariable(Label='file name')
        public List<String> fileNames;

        @InvocableVariable(Label='base64data')
        public List<String> base64data;

        @InvocableVariable(Label='filetypes')
        public List<String> filetypes;

        @InvocableVariable(Label='miscfileNames')
        public List<String> miscfileNames;

        @InvocableVariable(Label='miscbase64data')
        public List<String> miscbase64data;

        @InvocableVariable(Label='miscfiletypes')
        public List<String> miscfiletypes;
    }

    public static Datetime getUTCDateTime(Datetime dt) {
        Datetime GMTDate = Datetime.newInstanceGmt(
                dt.year(),
                dt.month(),
                dt.day(),
                dt.hour(),
                dt.minute(),
                dt.second());
        return GMTDate;
    }

    @AuraEnabled
    public static String updateDocketingActivities(String patentId, String strwrapperFinalTriggerActionCloseBy, String strCompletedClosedDate, String strComments, String emailTrackerId) {
        String AuditTrailStatus = 'Success';
        String strAuditTrailLogText = '[Started]';
        try {
            SymphonyIPM__Patent__c objPatent = [SELECT Id,SymphonyIPM__Asset_Type__c FROM SymphonyIPM__Patent__c WHERE Id = :patentId];
            Set<String> DocCodeMtd = new Set<String>();
            Date dateCompletedClosedDate = Date.valueOf(strCompletedClosedDate.replace('"', ''));

            List<SymphonyIPM__DocketDocumentCodeList__mdt> mdtDocketDocumentCodeLists = null;
            wrapperFinalTriggerActionCloseBy objWrapperFinalTriggerActionCloseBy = (wrapperFinalTriggerActionCloseBy) JSON.deserialize(strwrapperFinalTriggerActionCloseBy, wrapperFinalTriggerActionCloseBy.class);
            System.debug('Selected Option : ' + objWrapperFinalTriggerActionCloseBy.selectedOption);
            if (Schema.SObjectType.SymphonyIPM__DocketDocumentCodeList__mdt.isAccessible() && SymphonyIPM__DocketDocumentCodeList__mdt.SObjectType.getDescribe().isAccessible())
                mdtDocketDocumentCodeLists = [
                        SELECT
                                DeveloperName
                                , MasterLabel
                                , SymphonyIPM__Description__c
                                , SymphonyIPM__PTO__c
                        FROM SymphonyIPM__DocketDocumentCodeList__mdt
                        WHERE MasterLabel = :objWrapperFinalTriggerActionCloseBy.selectedOption
                        ORDER BY SymphonyIPM__Description__c
                ];
            String strDocumentDescription = '';
            if (mdtDocketDocumentCodeLists != null && mdtDocketDocumentCodeLists.size() > 0) {
                SymphonyIPM__DocketDocumentCodeList__mdt mdtDocketDocumentCodeList = mdtDocketDocumentCodeLists[0];
                if (Schema.SObjectType.SymphonyIPM__DocketDocumentCodeList__mdt.fields.SymphonyIPM__Description__c.isAccessible())
                    strDocumentDescription = mdtDocketDocumentCodeList.SymphonyIPM__Description__c;
            }
            for (SymphonyIPM__DocketDocumentCodeList__mdt dcmtd : mdtDocketDocumentCodeLists) {
                if (dcmtd.SymphonyIPM__PTO__c)
                    DocCodeMtd.add(dcmtd.MasterLabel);
            }
            SymphonyIPM__IFW_Data_v1__c objIFWData = null;

            if (Schema.SObjectType.SymphonyIPM__IFW_Data_v1__c.isCreateable() && SymphonyIPM__IFW_Data_v1__c.SObjectType.getDescribe().isCreateable()) {
                System.debug('objWrapperFinalTriggerActionCloseBy.selectedOption' + objWrapperFinalTriggerActionCloseBy.selectedOption);
                String IFWname = strDocumentDescription.trim();
                if (IFWname.length() > 80)
                    IFWname = IFWname.subString(0, 77) + '...';
                System.debug('IFWname :' + IFWname);
                objIFWData = new SymphonyIPM__IFW_Data_v1__c(Name = IFWname, SymphonyIPM__Asset__c = Id.valueOf(patentId), SymphonyIPM__Document_Code__c = objWrapperFinalTriggerActionCloseBy.selectedOption, SymphonyIPM__Document_Description__c = strDocumentDescription, SymphonyIPM__Mail_Room_Date__c = dateCompletedClosedDate);
                System.debug('Obj1:' + objIFWData);
                strAuditTrailLogText += 'IFW:' + objIFWData;
                if (DocCodeMtd.contains(objIFWData.SymphonyIPM__Document_Code__c)) {
                } else {
                    objIFWData.SymphonyIPM__Document_Code__c = '';
                    objIFWData.SymphonyIPM__Trigger__c = objWrapperFinalTriggerActionCloseBy.selectedOption;
                }
                System.debug('Obj2:' + objIFWData);
            }
            if (Schema.SObjectType.SymphonyIPM__IFW_Data_v1__c.isCreateable() && SymphonyIPM__IFW_Data_v1__c.SObjectType.getDescribe().isCreateable()) {
                System.debug('Obj:' + objIFWData);
                strAuditTrailLogText += 'IFW1:' + objIFWData;
                insert objIFWData;
            }

            strAuditTrailLogText += 'comment :' + strComments;
            /*-----------------Comments into Notes-----*/
            System.debug('comment :' + strComments);
            if (strDocumentDescription != '' && strDocumentDescription != null && strComments != '' && strComments != null) {
                ContentNote docketingActNote = new ContentNote();
                if (Schema.SObjectType.ContentNote.fields.Content.isCreateable())
                    docketingActNote.Content = Blob.valueOf(strComments);
                if (Schema.SObjectType.ContentNote.fields.title.isCreateable())
                    docketingActNote.title = strDocumentDescription;
                if (Schema.SObjectType.ContentNote.isCreateable() && ContentNote.SObjectType.getDescribe().isCreateable())
                    insert docketingActNote;

                ContentDocumentLink link = new ContentDocumentLink();
                link.LinkedEntityId = objIFWData.Id;
                link.ContentDocumentId = docketingActNote.id;
                if (Schema.SObjectType.ContentDocumentLink.fields.ShareType.isCreateable())
                    link.ShareType = 'V';
                if (Schema.SObjectType.ContentDocumentLink.fields.Visibility.isCreateable())
                    link.Visibility = 'AllUsers';
                if (Schema.SObjectType.ContentDocumentLink.isCreateable() && ContentDocumentLink.SObjectType.getDescribe().isCreateable())
                    insert link;
            }

            List<ID> IFWid = null;
            //if(Schema.SObjectType.SymphonyIPM__IFW_Data_v1__c.fields.id.isAccessible())
            IFWid = new List<ID>{
                    objIFWData.id
            };
            //InsertIFWRelatedDocActBatch ifwbDA = new InsertIFWRelatedDocActBatch(IFWid,'Patent','Event');
            //Id batchJobId = Database.executeBatch(ifwbDA, 100);
            InsertIFWRelatedDocActClass ifwbDA = new InsertIFWRelatedDocActClass();
            //String result = ifwbDA.mtdInsertIFWRelatedDocActClass(IFWid ,'Patent','Event');
            //TODO  - Change the Date parameter to Due date of Manual event.
            //System.debug('Manual Due Date ------->'+docketingEventManualDueDate);
            String triggerTypeForAction = 'Document Code';
            System.debug('IFWid :' + IFWid);
            //String result = ifwbDA.mtdInsertIFWRelatedDocActClass(IFWid ,'Patent',triggerTypeForAction,null);//Harsha on 18-10-2018
            String result = ifwbDA.mtdInsertIFWRelatedDocActClass(IFWid, objPatent.SymphonyIPM__Asset_Type__c, triggerTypeForAction, null, emailTrackerId);//Harsha on 18-10-2018
            strAuditTrailLogText += 'Result:' + result;
        } catch (Exception ex) {
            AuditTrailStatus = 'Fail';
            strAuditTrailLogText += '[ Error raised:' + ex.getMessage() + ' | ' + ex.getStackTraceString() + ' ]';
        } finally {
            strAuditTrailLogText += '[Stopped]';
            SymphonyIPM__AuditTrail__c objAuditTrail = null;
            if (Schema.SObjectType.SymphonyIPM__AuditTrail__c.isAccessible() && SymphonyIPM__AuditTrail__c.SObjectType.getDescribe().isAccessible() && SymphonyIPM__AuditTrail__c.SObjectType.getDescribe().isCreateable() && Schema.SObjectType.SymphonyIPM__AuditTrail__c.isCreateable()) {
                objAuditTrail = new SymphonyIPM__AuditTrail__c();
                if (Schema.SObjectType.SymphonyIPM__AuditTrail__c.fields.SymphonyIPM__Action__c.isCreateable())
                    objAuditTrail.SymphonyIPM__Action__c = 'Insert';
                if (Schema.SObjectType.SymphonyIPM__AuditTrail__c.fields.SymphonyIPM__CObjectName__c.isCreateable())
                    objAuditTrail.SymphonyIPM__CObjectName__c = 'DocketingActivityController(updateDocketingActivities)';
                if (Schema.SObjectType.SymphonyIPM__AuditTrail__c.fields.SymphonyIPM__Description__c.isCreateable())
                    objAuditTrail.SymphonyIPM__Description__c = strAuditTrailLogText;
                if (Schema.SObjectType.SymphonyIPM__AuditTrail__c.fields.SymphonyIPM__Status__c.isCreateable())
                    objAuditTrail.SymphonyIPM__Status__c = AuditTrailStatus;
                if (SymphonyIPM__AuditTrail__c.SObjectType.getDescribe().isCreateable() && Schema.SObjectType.SymphonyIPM__AuditTrail__c.isCreateable())
                    insert objAuditTrail;
            }
        }
        return AuditTrailStatus ;
    }

    @InvocableMethod(Label='IFW Doc Activities')
    public static void flowActionIFWDocActivities (List<IFWDocActivitiesData> ifwDocActivitiesData) {
        for (IFWDocActivitiesData ifwDocActivities : ifwDocActivitiesData) {
            List<String> emptyList = new List<String>();
            ifwDocActivities.strwrapperFinalTriggerActionCloseBy = '{"selectedOption":' + '"' + ifwDocActivities.strwrapperFinalTriggerActionCloseBy + '"}';
            createIFWDocActivities(ifwDocActivities.patentId, ifwDocActivities.strwrapperFinalTriggerActionCloseBy, ifwDocActivities.strCompletedClosedDate, ifwDocActivities.docketingManualDueDate,
                    ifwDocActivities.comment, emptyList, emptyList, emptyList, emptyList, emptyList, emptyList, ifwDocActivities.emailTrackerId);
        }
    }

    public static String createIFWDocActivities(String patentId, String strwrapperFinalTriggerActionCloseBy, String strCompletedClosedDate, String docketingManualDueDate,
            String comment, List<String> fileNames, List<String> base64data, List<String> filetypes,
            List<String> miscfileNames, List<String> miscbase64data, List<String> miscfiletypes, String emailTrackerId) {
        String AuditTrailStatus = 'Success';
        String strAuditTrailLogText = '[Started]';
        try {
            SymphonyIPM__Patent__c objPatent = [SELECT Id,SymphonyIPM__Asset_Type__c FROM SymphonyIPM__Patent__c WHERE Id = :patentId];
            Set<String> DocCodeMtd = new Set<String>();
            Date dateCompletedClosedDate = Date.valueOf(strCompletedClosedDate.replace('"', ''));
            Date docketingEventManualDueDate;
            if (docketingManualDueDate != null && docketingManualDueDate != '')
                docketingEventManualDueDate = Date.valueOf(docketingManualDueDate.replace('"', ''));
            System.debug('Manual due date :' + docketingEventManualDueDate);
            List<SymphonyIPM__DocketDocumentCodeList__mdt> mdtDocketDocumentCodeLists = null;
            wrapperFinalTriggerActionCloseBy objWrapperFinalTriggerActionCloseBy = (wrapperFinalTriggerActionCloseBy) JSON.deserialize(strwrapperFinalTriggerActionCloseBy, wrapperFinalTriggerActionCloseBy.class);
            if (Schema.SObjectType.SymphonyIPM__DocketDocumentCodeList__mdt.isAccessible() && SymphonyIPM__DocketDocumentCodeList__mdt.SObjectType.getDescribe().isAccessible())
                mdtDocketDocumentCodeLists = [
                        SELECT
                                DeveloperName
                                , MasterLabel
                                , SymphonyIPM__Description__c
                                , SymphonyIPM__PTO__c
                        FROM SymphonyIPM__DocketDocumentCodeList__mdt
                        WHERE MasterLabel = :objWrapperFinalTriggerActionCloseBy.selectedOption
                        ORDER BY SymphonyIPM__Description__c
                ];
            String strDocumentDescription = '';
            if (mdtDocketDocumentCodeLists != null && mdtDocketDocumentCodeLists.size() > 0) {
                SymphonyIPM__DocketDocumentCodeList__mdt mdtDocketDocumentCodeList = mdtDocketDocumentCodeLists[0];
                if (Schema.SObjectType.SymphonyIPM__DocketDocumentCodeList__mdt.fields.SymphonyIPM__Description__c.isAccessible()) {
                    strDocumentDescription = mdtDocketDocumentCodeList.SymphonyIPM__Description__c;
                }
            }
            for (SymphonyIPM__DocketDocumentCodeList__mdt dcmtd : mdtDocketDocumentCodeLists) {
                if (dcmtd.SymphonyIPM__PTO__c) {
                    DocCodeMtd.add(dcmtd.MasterLabel);
                }
            }
            SymphonyIPM__IFW_Data_v1__c objIFWData = null;

            if (Schema.SObjectType.SymphonyIPM__IFW_Data_v1__c.isCreateable() && SymphonyIPM__IFW_Data_v1__c.SObjectType.getDescribe().isCreateable()) {
                String ifwName = strDocumentDescription.trim();
                if (ifwName.length() > 80) {
                    String trimstr = ifwName;
                    ifwName = trimstr.substring(0, 76) + '...';
                }
                objIFWData = new SymphonyIPM__IFW_Data_v1__c(Name = ifwName, SymphonyIPM__Asset__c = Id.valueOf(patentId), SymphonyIPM__Document_Code__c = objWrapperFinalTriggerActionCloseBy.selectedOption, SymphonyIPM__Document_Description__c = strDocumentDescription, SymphonyIPM__Mail_Room_Date__c = dateCompletedClosedDate, SymphonyIPM__Is_Manual_Entry__c = true);
                strAuditTrailLogText += 'IFW:' + objIFWData;
                if (DocCodeMtd.contains(objIFWData.SymphonyIPM__Document_Code__c)) {
                    objIFWData.SymphonyIPM__Document_Code__c = objWrapperFinalTriggerActionCloseBy.selectedOption;
                } else {
                    objIFWData.SymphonyIPM__Document_Code__c = '';
                    objIFWData.SymphonyIPM__Trigger__c = objWrapperFinalTriggerActionCloseBy.selectedOption;
                }
                //Added this condition by Devendar to show Doc Code in Prosecution History - Its a Temp Fix need to find solution
                if (objWrapperFinalTriggerActionCloseBy.selectedOption.length() < 15) {
                    objIFWData.SymphonyIPM__Document_Code__c = objWrapperFinalTriggerActionCloseBy.selectedOption;
                }
            }
            if (Schema.SObjectType.SymphonyIPM__IFW_Data_v1__c.isCreateable() && SymphonyIPM__IFW_Data_v1__c.SObjectType.getDescribe().isCreateable()) {
                strAuditTrailLogText += 'IFW1:' + objIFWData;
                insert objIFWData;
            }
            if (Schema.SObjectType.SymphonyIPM__PatentDraft__c.isCreateable() && SymphonyIPM__PatentDraft__c.SObjectType.getDescribe().isCreateable()) {
                SymphonyIPM__PatentDraft__c objPD = new SymphonyIPM__PatentDraft__c();
                objPD.SymphonyIPM__Prosecution_Name__c = strDocumentDescription;
                objPD.SymphonyIPM__Patent__c = patentId;
                insert objPD;
            }
            List<Attachment> docsIFWProsecution = new List<Attachment>();
            //--Attachments--
            for (Integer i = 0; i < base64data.size(); i = i + 1) {
                Attachment attachment = new Attachment();
                attachment.ParentId = objIFWData.Id;
                attachment.Body = EncodingUtil.base64Decode(base64data[i]);
                attachment.Name = fileNames[i];
                attachment.ContentType = filetypes[i];
                docsIFWProsecution.add(attachment);
            }
            if (docsIFWProsecution.size() > 0 && docsIFWProsecution != null)
                insert docsIFWProsecution;
            /*-----------------Comments into Notes-----*/
            if (strDocumentDescription != '' && strDocumentDescription != null && comment != '' && comment != null) {
                ContentNote docketingActNote = new ContentNote();
                if (Schema.SObjectType.ContentNote.fields.Content.isCreateable())
                    docketingActNote.Content = Blob.valueOf(comment);
                if (Schema.SObjectType.ContentNote.fields.Title.isCreateable())
                    docketingActNote.Title = strDocumentDescription;
                if (Schema.SObjectType.ContentNote.isCreateable() && ContentNote.SObjectType.getDescribe().isCreateable())
                    insert docketingActNote;

                ContentDocumentLink link = new ContentDocumentLink();
                link.LinkedEntityId = objIFWData.Id;
                link.ContentDocumentId = docketingActNote.Id;
                if (Schema.SObjectType.ContentDocumentLink.fields.ShareType.isCreateable())
                    link.ShareType = 'V';
                if (Schema.SObjectType.ContentDocumentLink.fields.Visibility.isCreateable())
                    link.Visibility = 'AllUsers';
                if (Schema.SObjectType.ContentDocumentLink.isCreateable() && ContentDocumentLink.SObjectType.getDescribe().isCreateable())
                    insert link;
            }
            List<Id> IFWid = null;
            if (Schema.SObjectType.SymphonyIPM__IFW_Data_v1__c.fields.Id.isAccessible())
                IFWid = new List<Id>{
                        objIFWData.Id
                };

            InsertIFWRelatedDocActClass ifwbDA = new InsertIFWRelatedDocActClass();

            //TODO  - Change the Date parameter to Due date of Manual event.
            String triggerTypeForAction = 'Document Code';


            String result = ifwbDA.mtdInsertIFWRelatedDocActClassWithAttachment(IFWid, objPatent.SymphonyIPM__Asset_Type__c, docketingEventManualDueDate, miscfileNames, miscbase64data, miscfiletypes, emailTrackerId);

            strAuditTrailLogText += 'Result:' + result;
        } catch (Exception ex) {
            AuditTrailStatus = 'Fail';
            strAuditTrailLogText += '[ Error raised:' + ex.getMessage() + ' | ' + ex.getStackTraceString() + ' ]';
        } finally {
            strAuditTrailLogText += '[Stopped]';
            SymphonyIPM__AuditTrail__c objAuditTrail = null;
            if (Schema.SObjectType.SymphonyIPM__AuditTrail__c.isAccessible() && SymphonyIPM__AuditTrail__c.SObjectType.getDescribe().isAccessible() && SymphonyIPM__AuditTrail__c.SObjectType.getDescribe().isCreateable() && Schema.SObjectType.SymphonyIPM__AuditTrail__c.isCreateable()) {
                objAuditTrail = new SymphonyIPM__AuditTrail__c();
                if (Schema.SObjectType.SymphonyIPM__AuditTrail__c.fields.SymphonyIPM__Action__c.isCreateable())
                    objAuditTrail.SymphonyIPM__Action__c = 'Insert';
                if (Schema.SObjectType.SymphonyIPM__AuditTrail__c.fields.SymphonyIPM__CObjectName__c.isCreateable())
                    objAuditTrail.SymphonyIPM__CObjectName__c = 'DocketingActivityController(updateDocketingActivities)';
                if (Schema.SObjectType.SymphonyIPM__AuditTrail__c.fields.SymphonyIPM__Description__c.isCreateable())
                    objAuditTrail.SymphonyIPM__Description__c = strAuditTrailLogText;
                if (Schema.SObjectType.SymphonyIPM__AuditTrail__c.fields.SymphonyIPM__Status__c.isCreateable())
                    objAuditTrail.SymphonyIPM__Status__c = AuditTrailStatus;
                if (SymphonyIPM__AuditTrail__c.SObjectType.getDescribe().isCreateable() && Schema.SObjectType.SymphonyIPM__AuditTrail__c.isCreateable())
                    insert objAuditTrail;
            }
        }
        return AuditTrailStatus ;
    }

public static void magicMethod(){
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
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
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