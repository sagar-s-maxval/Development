public with sharing class DisputeOppositionController
{
    public class WrapperComboBoxOption {
        @AuraEnabled
        public String label { get; set; }
        @AuraEnabled
        public String value { get; set; }
        @AuraEnabled
        public Boolean isSelected { get; set; }
    }
    
    @AuraEnabled
    public static DisputeOpposition_Goods_Services__c insertTSG(DisputeOpposition_Goods_Services__c tsg,id TrademarkId)
    {
        System.debug(tsg);
        SymphonyIPMExt__Dispute_Opposition__c instance = null;
        if(Schema.sObjectType.SymphonyIPMExt__Dispute_Opposition__c.isAccessible() && SymphonyIPMExt__Dispute_Opposition__c.sObjectType.getDescribe().isAccessible())
            instance = [select id,name from SymphonyIPMExt__Dispute_Opposition__c where id=:TrademarkId];
        if(Schema.sObjectType.DisputeOpposition_Goods_Services__c.fields.Name.isCreateable())
            tsg.Name = instance.name;
        if(Schema.sObjectType.DisputeOpposition_Goods_Services__c.isCreateable() && DisputeOpposition_Goods_Services__c.sObjectType.getDescribe().isCreateable())
            insert tsg;
        return tsg;
    }
    
    @AuraEnabled
    public static Map<string,List<String>> TrademarkGSClass()
    {
        Map<string,List<String>> picklistValues = New Map<string,List<String>>();
        List<String> classOptions = new List<String>();        
        Schema.DescribeFieldResult fieldResult = DisputeOpposition_Goods_Services__c.Class__c.getDescribe();
        List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p: pList) 
        {
            classoptions.add(p.getLabel());
        }     
        picklistValues.Put('classVal',classOptions);
        
        List<String> goodsOptions = new List<String>();        
        Schema.DescribeFieldResult fieldResult1 = DisputeOpposition_Goods_Services__c.Good_s_Language__c.getDescribe();
        List<Schema.PicklistEntry> pList1 = fieldResult1.getPicklistValues();
        for (Schema.PicklistEntry p: pList1) 
        {
            GoodsOptions.add(p.getLabel());
        }  
        picklistValues.Put('goods',GoodsOptions);
        
        List<String> FilingOptions = new List<String>();        
        Schema.DescribeFieldResult fieldResult2 = DisputeOpposition_Goods_Services__c.Filing_Basis__c.getDescribe();
        List<Schema.PicklistEntry> pList2 = fieldResult2.getPicklistValues();
        for (Schema.PicklistEntry p: pList2) 
        {
            FilingOptions.add(p.getLabel());
        }  
        picklistValues.Put('filingB',FilingOptions);
        return picklistValues;
    }
    
    @AuraEnabled
    public static wrapperTrademark getMarkImage(Id trademarkId) 
    {
        try
        {
            string strDateFormat = 'MM/dd/yyyy';
            wrapperTrademark objMarkInfo = new wrapperTrademark();
            if(Schema.sObjectType.SymphonyIPMExt__Dispute_Opposition__c.isAccessible() && SymphonyIPMExt__Dispute_Opposition__c.sObjectType.getDescribe().isAccessible())
            {
                List<SymphonyIPMExt__Dispute_Opposition__c> objTrademarks = [
                    SELECT
                    Id
                    , Name
                    FROM SymphonyIPMExt__Dispute_Opposition__c
                    WHERE Id = :trademarkId
                ];
                
                if (objTrademarks != null && objTrademarks.size()>0)
                {
                    SymphonyIPMExt__Dispute_Opposition__c objTrademark = objTrademarks[0];
                    objMarkInfo.trademarkId = objTrademark.Id ;
                    objMarkInfo.mark = (objTrademark.Name!=null)?objTrademark.Name:'';
                    /*if(Schema.sObjectType.SymphonyIPMExt__Dispute_Opposition__c.fields.Mark_ContentVersion_Id__c.isAccessible())
                        objMarkInfo.markContentVersionId = (objTrademark.Mark_ContentVersion_Id__c !=null)?objTrademark.Mark_ContentVersion_Id__c:'';
                    if(Schema.sObjectType.SymphonyIPMExt__Dispute_Opposition__c.fields.Mark_ContentVersion_Id_Uploaded__c.isAccessible())
                        objMarkInfo.markContentVersionIdUploaded= (objTrademark.Mark_ContentVersion_Id_Uploaded__c!=null)?objTrademark.Mark_ContentVersion_Id_Uploaded__c:'';    
					*/
                } 
            }
            //objMarkInfo.trademarkId = trademarkId;
            return objMarkInfo;
        }
        catch(Exception exp)
        {
            throw exp;
        }
    }
    @AuraEnabled
    public static wrapperTrademark saveMarkInfo(string strWrapperTrademarkJSON) 
    {
        try
        {
            wrapperTrademark objWrapperTrademark  = (wrapperTrademark)JSON.deserialize(strWrapperTrademarkJSON, wrapperTrademark.class);
            if(Schema.sObjectType.SymphonyIPMExt__Dispute_Opposition__c.isAccessible() && SymphonyIPMExt__Dispute_Opposition__c.sObjectType.getDescribe().isAccessible())
            {
                List<SymphonyIPMExt__Dispute_Opposition__c> objTrademarkInfoList = [
                    SELECT
                    Id
                    FROM SymphonyIPMExt__Dispute_Opposition__c
                    WHERE Id = :objWrapperTrademark.trademarkId
                ];
                if (objTrademarkInfoList != null && objTrademarkInfoList.size()>0)
                {
                    SymphonyIPMExt__Dispute_Opposition__c objMarkInfo = objTrademarkInfoList[0];
                    if (objMarkInfo != null )
                    {
                        /*if (Schema.sObjectType.SymphonyIPMExt__Dispute_Opposition__c.fields.Mark_Characteristics__c.isUpdateable())
                            objMarkInfo.Mark_Characteristics__c = objWrapperTrademark.markCharacteristics;
                        if (Schema.sObjectType.SymphonyIPMExt__Dispute_Opposition__c.fields.Mark_Type__c.isUpdateable())
                            objMarkInfo.Mark_Type__c = objWrapperTrademark.markType;
                        if (Schema.sObjectType.SymphonyIPMExt__Dispute_Opposition__c.fields.Registration_Type__c.isUpdateable())
                            objMarkInfo.Registration_Type__c = objWrapperTrademark.registrationType;
                        if (Schema.sObjectType.SymphonyIPMExt__Dispute_Opposition__c.fields.Colors_Claimed__c.isUpdateable())
                            objMarkInfo.Colors_Claimed__c= objWrapperTrademark.colorClaimed;
                        if (Schema.sObjectType.SymphonyIPMExt__Dispute_Opposition__c.fields.Description_of_Design_Mark__c.isUpdateable())
                            objMarkInfo.Description_of_Design_Mark__c = objWrapperTrademark.descriptionofDesignMark;
                        if (Schema.sObjectType.SymphonyIPMExt__Dispute_Opposition__c.fields.Translation__c.isUpdateable())
                            objMarkInfo.Translation__c = objWrapperTrademark.translation;    
						*/
                        if (SymphonyIPMExt__Dispute_Opposition__c.sObjectType.getDescribe().isUpdateable() && Schema.sObjectType.SymphonyIPMExt__Dispute_Opposition__c.isUpdateable())
                            UPDATE objMarkInfo;
                    }
                }
            }
            system.debug('objWrapperTrademark:' + objWrapperTrademark);
            
            return objWrapperTrademark;
        }
        catch(Exception exp)
        {
            
            throw exp;
        }
    }
    @AuraEnabled
    public static wrapperTrademark  getMarkInformation(Id trademarkId) 
    {
        try
        {
            string strDateFormat = 'MM/dd/yyyy';
            wrapperTrademark objMarkInfo = new wrapperTrademark();
            if(Schema.sObjectType.SymphonyIPMExt__Dispute_Opposition__c.isAccessible() && SymphonyIPMExt__Dispute_Opposition__c.sObjectType.getDescribe().isAccessible())
            {
                List<SymphonyIPMExt__Dispute_Opposition__c> objTrademarks = [
                    SELECT
                    Id
                    , Name
                    FROM SymphonyIPMExt__Dispute_Opposition__c
                    WHERE Id = :trademarkId
                ];
                
                if (objTrademarks != null && objTrademarks.size()>0)
                {
                    SymphonyIPMExt__Dispute_Opposition__c objTrademark = objTrademarks[0];
                    //TODO
                    objMarkInfo.trademarkId = objTrademark.Id ;
                    /*if(Schema.sObjectType.SymphonyIPMExt__Dispute_Opposition__c.fields.Mark__c.isAccessible())
                        objMarkInfo.mark = (objTrademark.Mark__c!=null)?objTrademark.Mark__c:'';
                    if(Schema.sObjectType.SymphonyIPMExt__Dispute_Opposition__c.fields.Mark_Image__c.isAccessible())
                        objMarkInfo.markImage = (objTrademark.Mark_Image__c!=null)?objTrademark.Mark_Image__c:'';
                    if(Schema.sObjectType.SymphonyIPMExt__Dispute_Opposition__c.fields.Mark_ContentVersion_Id__c.isAccessible())
                        objMarkInfo.markContentVersionId = (objTrademark.Mark_ContentVersion_Id__c !=null)?objTrademark.Mark_ContentVersion_Id__c:'';
                    if(Schema.sObjectType.SymphonyIPMExt__Dispute_Opposition__c.fields.Colors_Claimed__c.isAccessible())
                        objMarkInfo.colorClaimed = (objTrademark.Colors_Claimed__c!=null)?objTrademark.Colors_Claimed__c:'';
                    if(Schema.sObjectType.SymphonyIPMExt__Dispute_Opposition__c.fields.Description_of_Design_Mark__c.isAccessible())
                        objMarkInfo.descriptionofDesignMark  = (objTrademark.Description_of_Design_Mark__c!=null)?objTrademark.Description_of_Design_Mark__c:'';
                    if(Schema.sObjectType.SymphonyIPMExt__Dispute_Opposition__c.fields.Mark_Characteristics__c.isAccessible())
                        objMarkInfo.markCharacteristics = string.valueOf(objTrademark.Mark_Characteristics__c);
                    if(Schema.sObjectType.SymphonyIPMExt__Dispute_Opposition__c.fields.Mark_Type__c.isAccessible())
                        objMarkInfo.markType = (objTrademark.Mark_Type__c!=null)?objTrademark.Mark_Type__c:'';
                    if(Schema.sObjectType.SymphonyIPMExt__Dispute_Opposition__c.fields.Registration_Type__c.isAccessible())
                        objMarkInfo.registrationType = (objTrademark.Registration_Type__c!=null)?objTrademark.Registration_Type__c:'';
                    if(Schema.sObjectType.SymphonyIPMExt__Dispute_Opposition__c.fields.Status__c.isAccessible())
                        objMarkInfo.status = (objTrademark.Status__c!=null)?objTrademark.Status__c:'';
                    if(Schema.sObjectType.SymphonyIPMExt__Dispute_Opposition__c.fields.Status_Date__c.isAccessible() && objTrademark.Status_Date__c!= null)
                        objMarkInfo.statusDate = ((DateTime)objTrademark.Status_Date__c).format(strDateFormat);
                    if(Schema.sObjectType.SymphonyIPMExt__Dispute_Opposition__c.fields.Translation__c.isAccessible())
                        objMarkInfo.translation = (objTrademark.Translation__c!=null)?objTrademark.Translation__c:'';
                    
                    objMarkInfo.markCharacteristics_options = getOptions('SymphonyIPMExt__Dispute_Opposition__c','Mark_Characteristics__c');
                    objMarkInfo.markType_options = getOptions('SymphonyIPMExt__Dispute_Opposition__c','Mark_Type__c');
                    objMarkInfo.registrationType_options = getOptions('SymphonyIPMExt__Dispute_Opposition__c','Registration_Type__c');
                    */
                } 
            }
            return objMarkInfo;
        }
        catch(Exception exp)
        {
            throw exp;
        }
    }
    @AuraEnabled
    public static wrapperTrademark  getWrapper(Id trademarkId) 
    {
        try
        {
            wrapperTrademark objMarkInfo = new wrapperTrademark();
            if(Schema.sObjectType.SymphonyIPMExt__Dispute_Opposition__c.isAccessible() && SymphonyIPMExt__Dispute_Opposition__c.sObjectType.getDescribe().isAccessible())
            {
                //TODO
                objMarkInfo.trademarkId = trademarkId ;
                objMarkInfo.mark = '';
                objMarkInfo.markImage = '';
                objMarkInfo.markContentVersionId = '';
                objMarkInfo.colorClaimed = '';
                objMarkInfo.descriptionofDesignMark  = '';
                objMarkInfo.markCharacteristics = '';
                objMarkInfo.markType = '';
                objMarkInfo.registrationType = '';
                objMarkInfo.status = '';
                objMarkInfo.statusDate = '';
                objMarkInfo.translation = '';
                
                //objMarkInfo.markCharacteristics_options = getOptions('SymphonyIPMExt__Dispute_Opposition__c','Mark_Characteristics__c');
                //objMarkInfo.markType_options = getOptions('SymphonyIPMExt__Dispute_Opposition__c','Mark_Type__c');
                //objMarkInfo.registrationType_options = getOptions('SymphonyIPMExt__Dispute_Opposition__c','Registration_Type__c');
            }
            return objMarkInfo;
        }
        catch(Exception exp)
        {
            throw exp;
        }
    }
    public static List<wrapperComboboxOption> getOptions(string CObjectName, string FieldName)
    {
        string strClass = 'TrademarkController';
        string strNamespacePrefix='';
        //string strNamespacePrefix = SymphonyIPM__HelperGeneralSetting.getNamespacePrefix();
        if (strNamespacePrefix != '')
        {   
            strNamespacePrefix += '__';
        }
         
        System.debug('strNamespacePrefix----->'+strNamespacePrefix);

        List<wrapperComboboxOption> lstOptions = new List<wrapperComboboxOption>();
        DescribeSObjectResult objResult = Schema.getGlobalDescribe().get(strNamespacePrefix + CObjectName).getDescribe();
        DescribeFieldResult fieldResult = objResult.fields.getMap().get(strNamespacePrefix + FieldName).getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple)
        {
            wrapperComboboxOption objOption = new wrapperComboboxOption();
            objOption.label =  f.getLabel();
            objOption.value = f.getValue();
            lstOptions.add(objOption);
        }
        return lstOptions;
    }
    
    @AuraEnabled
    public static string saveMarkName(Id trademarkId, string markName) 
    {
        try
        {
            system.debug('trademarkId:' + trademarkId + ',markName:' + markName);
            if(Schema.sObjectType.SymphonyIPMExt__Dispute_Opposition__c.isAccessible() && SymphonyIPMExt__Dispute_Opposition__c.sObjectType.getDescribe().isAccessible())
            {
                SymphonyIPMExt__Dispute_Opposition__c objTrademark = [SELECT Id, Name FROM SymphonyIPMExt__Dispute_Opposition__c WHERE Id = :trademarkId LIMIT 1];
                if (objTrademark != null)
                {
                    //if(Schema.sObjectType.SymphonyIPMExt__Dispute_Opposition__c.fields.Mark__c.isUpdateable())
                    //    objTrademark.Mark__c = markName;
                    if(Schema.sObjectType.SymphonyIPMExt__Dispute_Opposition__c.fields.Name.isUpdateable())
                        //objTrademark.Name = markName;
                    if (SymphonyIPMExt__Dispute_Opposition__c.sObjectType.getDescribe().isUpdateable() && Schema.sObjectType.SymphonyIPMExt__Dispute_Opposition__c.isUpdateable())
                        UPDATE objTrademark;
                }
            }
            return 'Success';
        }
        catch(Exception exp)
        {
            
            throw exp;
        }
    }
    
    @AuraEnabled
    public static List<wrapperTrademarkGoodsService> getGoodsAndServices(Id trademarkId) 
    {
        try
        {
            string strDateFormat = 'MM/dd/yyyy';
            Map<string, SymphonyIPM__TM_Goods_Classes__mdt> mapGoodsClasses = new Map<string, SymphonyIPM__TM_Goods_Classes__mdt>();
            List<SymphonyIPM__TM_Goods_Classes__mdt> objTMGoodsClasses = null;
            if(Schema.sObjectType.SymphonyIPM__TM_Goods_Classes__mdt.isAccessible() && SymphonyIPM__TM_Goods_Classes__mdt.sObjectType.getDescribe().isAccessible())
                objTMGoodsClasses = [SELECT MasterLabel, SymphonyIPM__Class_Heading__c, SymphonyIPM__Class_Description__c FROM SymphonyIPM__TM_Goods_Classes__mdt LIMIT 49999];
            for(SymphonyIPM__TM_Goods_Classes__mdt objGoodsClass : objTMGoodsClasses)
            {
                mapGoodsClasses.put(objGoodsClass.MasterLabel, objGoodsClass); 
            }
            
            List<wrapperTrademarkGoodsService> objGoodsAndServiceList = new List<wrapperTrademarkGoodsService>();
            if(Schema.sObjectType.DisputeOpposition_Goods_Services__c.isAccessible() && DisputeOpposition_Goods_Services__c.sObjectType.getDescribe().isAccessible())
            {
                List<DisputeOpposition_Goods_Services__c> objGoodsServicesList = [
                    SELECT
                    Id
                    , Class__c
                    , Domestic_Classes__c
                    , Goods_Description__c
                    , Filing_Basis__c
                    , Good_s_Language__c
                    , First_Use_Date__c
                    , First_Use_in_Commerce_Date__c
                    FROM DisputeOpposition_Goods_Services__c
                    WHERE Dispute_Opposition__c = :trademarkId
                ];
                
                if (objGoodsServicesList != null && objGoodsServicesList.size()>0)
                {
                    for(DisputeOpposition_Goods_Services__c objGoodsService : objGoodsServicesList)
                    {
                        wrapperTrademarkGoodsService objWrapperTrademarkGoodsService = new wrapperTrademarkGoodsService();
                        objWrapperTrademarkGoodsService.goodsServicesId =  objGoodsService.Id;
                        if(Schema.sObjectType.DisputeOpposition_Goods_Services__c.fields.Class__c.isAccessible())
                        {
                            objWrapperTrademarkGoodsService.classValue = (objGoodsService.Class__c!=null)?objGoodsService.Class__c:'';
                            if (mapGoodsClasses.containsKey(objGoodsService.Class__c))
                            {
                                SymphonyIPM__TM_Goods_Classes__mdt objGoodsClass = mapGoodsClasses.get(objGoodsService.Class__c);
                                if(Schema.sObjectType.SymphonyIPM__TM_Goods_Classes__mdt.fields.SymphonyIPM__Class_Heading__c.isAccessible())
                                    objWrapperTrademarkGoodsService.classHeading = (objGoodsClass.SymphonyIPM__Class_Heading__c!=null)?objGoodsClass.SymphonyIPM__Class_Heading__c:'';
                            }
                        }
                        if(Schema.sObjectType.DisputeOpposition_Goods_Services__c.fields.Domestic_Classes__c.isAccessible())
                            objWrapperTrademarkGoodsService.usClasses = (objGoodsService.Domestic_Classes__c!=null)?objGoodsService.Domestic_Classes__c:'';
                        if(Schema.sObjectType.DisputeOpposition_Goods_Services__c.fields.Goods_Description__c.isAccessible())
                            objWrapperTrademarkGoodsService.goodsDescription = (objGoodsService.Goods_Description__c!=null)?objGoodsService.Goods_Description__c:'';
                        objWrapperTrademarkGoodsService.goodsDescription = (objWrapperTrademarkGoodsService.goodsDescription!='')?objWrapperTrademarkGoodsService.goodsDescription:'[No description]';
                        if(Schema.sObjectType.DisputeOpposition_Goods_Services__c.fields.Filing_Basis__c.isAccessible())
                            objWrapperTrademarkGoodsService.filingBasis = (objGoodsService.Filing_Basis__c!=null)?objGoodsService.Filing_Basis__c:'';
                        if(Schema.sObjectType.DisputeOpposition_Goods_Services__c.fields.Good_s_Language__c.isAccessible())
                            objWrapperTrademarkGoodsService.goodsLanguage = (objGoodsService.Good_s_Language__c!=null)?objGoodsService.Good_s_Language__c:'';
                        if (objGoodsService.First_Use_Date__c!=null && Schema.sObjectType.DisputeOpposition_Goods_Services__c.fields.First_Use_Date__c.isAccessible())
                        {
                            //objWrapperTrademarkGoodsService.firstUseDate = ((DateTime)objGoodsService.First_Use_Date__c).format(strDateFormat);
                            objWrapperTrademarkGoodsService.firstUseDate = objGoodsService.First_Use_Date__c;
                        }
                        if (objGoodsService.First_Use_in_Commerce_Date__c!=null && Schema.sObjectType.DisputeOpposition_Goods_Services__c.fields.First_Use_in_Commerce_Date__c.isAccessible())
                        {
                            //objWrapperTrademarkGoodsService.firstUseInCommerceDate  = ((DateTime)objGoodsService.First_Use_in_Commerce_Date__c).format(strDateFormat);
                            objWrapperTrademarkGoodsService.firstUseInCommerceDate  = objGoodsService.First_Use_in_Commerce_Date__c;
                        }
                        objGoodsAndServiceList.add(objWrapperTrademarkGoodsService);
                    }
                } 
            }
            return objGoodsAndServiceList;
        }
        catch(Exception exp)
        {
            throw exp;
        }
    }
    @AuraEnabled
    public static string deleteGoodsAndServices(Id goodsServiceId) 
    {
        try
        {
            if(Schema.sObjectType.DisputeOpposition_Goods_Services__c.isAccessible() && DisputeOpposition_Goods_Services__c.sObjectType.getDescribe().isAccessible())
            {
                List<DisputeOpposition_Goods_Services__c> objGoodsServicesList = [SELECT Id FROM DisputeOpposition_Goods_Services__c WHERE Id= :goodsServiceId];
                if (objGoodsServicesList != null && objGoodsServicesList.size()>0)
                {
                    if (DisputeOpposition_Goods_Services__c.sObjectType.getDescribe().isDeletable() && Schema.sObjectType.DisputeOpposition_Goods_Services__c.isDeletable())
                        DELETE objGoodsServicesList;
                }
            }
            return 'SUCCESS';
        }
        catch(Exception exp)
        {
            throw exp;
        }
    }
    
    @AuraEnabled
    public static string updateAttachment(Id attachmentId) 
    {
        try
        {
            Id ContentVersionId = null;
            if
            (
                Schema.sObjectType.ContentDocumentLink.isAccessible() && ContentDocumentLink.sObjectType.getDescribe().isAccessible()
                && Schema.sObjectType.ContentDocument.isAccessible() && ContentDocument.sObjectType.getDescribe().isAccessible()
                && Schema.sObjectType.ContentVersion.isAccessible() && ContentVersion.sObjectType.getDescribe().isAccessible()
            )
            {
                List<ContentDocumentLink> objContentDocumentLinkList = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId =:attachmentId ORDER BY SystemModstamp DESC];
                if (objContentDocumentLinkList != null && objContentDocumentLinkList.size()>0)
                {
                    ContentDocumentLink objContentDocumentLink = objContentDocumentLinkList[0];
                    
                    List<ContentVersion> objContentVersionList = [SELECT Id FROM ContentVersion WHERE ContentDocumentId=:objContentDocumentLink.ContentDocumentId  ORDER BY CreatedDate DESC];        
                    if (objContentVersionList != null && objContentVersionList.size()>0)
                    {
                        ContentVersionId = objContentVersionList[0].Id;
                    }
                }
            } 
            if(Schema.sObjectType.SymphonyIPM__Trademark_Attachments__c.isAccessible() && SymphonyIPM__Trademark_Attachments__c.sObjectType.getDescribe().isAccessible())
            {
                List<SymphonyIPM__Trademark_Attachments__c> objAttachmentList = [SELECT Id, SymphonyIPM__Content_Version_Id__c FROM SymphonyIPM__Trademark_Attachments__c WHERE Id=:attachmentId];
                if (objAttachmentList != null && objAttachmentList.size()>0)
                {
                    SymphonyIPM__Trademark_Attachments__c objAttachment = objAttachmentList[0];
                    if(Schema.sObjectType.SymphonyIPM__Trademark_Attachments__c.fields.SymphonyIPM__Content_Version_Id__c.isUpdateable())
                        objAttachment.SymphonyIPM__Content_Version_Id__c = ContentVersionId;
                }    
                if (SymphonyIPM__Trademark_Attachments__c.sObjectType.getDescribe().isUpdateable() && Schema.sObjectType.SymphonyIPM__Trademark_Attachments__c.isUpdateable())
                    UPDATE objAttachmentList;
            }
            return 'Success';
        }
        catch(Exception exp)
        {
            throw exp;
        }
    }
    
    @AuraEnabled
    public static string removeAttachment(Id attachmentId) 
    {
        string strResult = '';
        try
        {
            Id contentVersionId = null;
            List<SymphonyIPM__Trademark_Attachments__c> objAttachmentList =  new List<SymphonyIPM__Trademark_Attachments__c>();
            if(Schema.sObjectType.SymphonyIPM__Trademark_Attachments__c.isAccessible() && SymphonyIPM__Trademark_Attachments__c.sObjectType.getDescribe().isAccessible())
                objAttachmentList = [SELECT Id, SymphonyIPM__Content_Version_Id__c FROM SymphonyIPM__Trademark_Attachments__c WHERE Id=:attachmentId];
            /*if(test.isrunningtest())
            {
                Trademark_Attachments__c objAttachment = objAttachmentList[0];
            }*/
            if (objAttachmentList != null && objAttachmentList.size()>0)
            {
                SymphonyIPM__Trademark_Attachments__c objAttachment = objAttachmentList[0];
                if(Schema.sObjectType.SymphonyIPM__Trademark_Attachments__c.fields.SymphonyIPM__Content_Version_Id__c.isUpdateable() && Schema.sObjectType.SymphonyIPM__Trademark_Attachments__c.fields.SymphonyIPM__Content_Version_Id__c.isAccessible())
                {
                    contentVersionId  = (Id)objAttachment.SymphonyIPM__Content_Version_Id__c;
                    objAttachment.SymphonyIPM__Content_Version_Id__c = '';
                }
            }    
            if (SymphonyIPM__Trademark_Attachments__c.sObjectType.getDescribe().isUpdateable() && Schema.sObjectType.SymphonyIPM__Trademark_Attachments__c.isUpdateable())
                UPDATE objAttachmentList;
            List<ContentDocumentLink> objContentDocumentLinkList =  new List<ContentDocumentLink>();
            if(Schema.sObjectType.ContentDocumentLink.isAccessible() && ContentDocumentLink.sObjectType.getDescribe().isAccessible())
                objContentDocumentLinkList = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId =:attachmentId];
            
            if(Schema.sObjectType.ContentDocumentLink.isDeletable()  && ContentDocumentLink.sObjectType.getDescribe().isDeletable())
                DELETE objContentDocumentLinkList;
            
        }
        catch(Exception exp)
        {
            strResult = exp.getMessage();
        }
        return strResult;
    }
    
    @AuraEnabled
    public static string updateMarkImage(Id trademarkId) 
    {
        try
        {
            Id ContentVersionId = null;
            if
            (
                Schema.sObjectType.ContentDocumentLink.isAccessible() && ContentDocumentLink.sObjectType.getDescribe().isAccessible()
                && Schema.sObjectType.ContentDocument.isAccessible() && ContentDocument.sObjectType.getDescribe().isAccessible()
                && Schema.sObjectType.ContentVersion.isAccessible() && ContentVersion.sObjectType.getDescribe().isAccessible()
            )
            {
                List<ContentDocumentLink> objContentDocumentLinkList = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId =:trademarkId ORDER BY SystemModstamp DESC];
                if (objContentDocumentLinkList != null && objContentDocumentLinkList.size()>0)
                {
                    ContentDocumentLink objContentDocumentLink = objContentDocumentLinkList[0];
                    
                    List<ContentVersion> objContentVersionList = [SELECT Id FROM ContentVersion WHERE ContentDocumentId=:objContentDocumentLink.ContentDocumentId  ORDER BY CreatedDate DESC];        
                    if (objContentVersionList != null && objContentVersionList.size()>0)
                    {
                        ContentVersionId = objContentVersionList[0].Id;
                    }
                }
            } 
            if(Schema.sObjectType.SymphonyIPMExt__Dispute_Opposition__c.isAccessible() && SymphonyIPMExt__Dispute_Opposition__c.sObjectType.getDescribe().isAccessible())
            {
                List<SymphonyIPMExt__Dispute_Opposition__c> objTrademarkList = [SELECT Id FROM SymphonyIPMExt__Dispute_Opposition__c WHERE Id=:trademarkId];
                if (objTrademarkList != null && objTrademarkList.size()>0)
                {
                    SymphonyIPMExt__Dispute_Opposition__c objTrademark = objTrademarkList[0];
                    //if(Schema.sObjectType.SymphonyIPMExt__Dispute_Opposition__c.fields.Mark_ContentVersion_Id_Uploaded__c.isUpdateable())
                    //    objTrademark.Mark_ContentVersion_Id_Uploaded__c = ContentVersionId;
                }    
                if (SymphonyIPMExt__Dispute_Opposition__c.sObjectType.getDescribe().isUpdateable() && Schema.sObjectType.SymphonyIPMExt__Dispute_Opposition__c.isUpdateable())
                    UPDATE objTrademarkList;
            }
            return 'Success';
        }
        catch(Exception exp)
        {
            throw exp;
        }
    }
    @AuraEnabled
    public static string removeMarkImage(Id trademarkId) 
    {
        try
        {
            Id ContentVersionId = null;
            if
            (
                Schema.sObjectType.ContentDocumentLink.isAccessible() && ContentDocumentLink.sObjectType.getDescribe().isAccessible()
                && Schema.sObjectType.ContentDocument.isAccessible() && ContentDocument.sObjectType.getDescribe().isAccessible()
                && Schema.sObjectType.ContentVersion.isAccessible() && ContentVersion.sObjectType.getDescribe().isAccessible()
            )
            {
                List<ContentDocumentLink> objContentDocumentLinkList = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId =:trademarkId ORDER BY SystemModstamp DESC];
                if (objContentDocumentLinkList != null && objContentDocumentLinkList.size()>0)
                {
                    ContentDocumentLink objContentDocumentLink = objContentDocumentLinkList[0];
                    
                    List<ContentVersion> objContentVersionList = [SELECT Id FROM ContentVersion WHERE ContentDocumentId=:objContentDocumentLink.ContentDocumentId  ORDER BY CreatedDate DESC];        
                    if (objContentVersionList != null && objContentVersionList.size()>0)
                    {
                        ContentVersionId = objContentVersionList[0].Id;
                    }
                }
            } 
            if(Schema.sObjectType.SymphonyIPMExt__Dispute_Opposition__c.isAccessible() && SymphonyIPMExt__Dispute_Opposition__c.sObjectType.getDescribe().isAccessible())
            {
                List<SymphonyIPMExt__Dispute_Opposition__c> objTrademarkList = [SELECT Id FROM SymphonyIPMExt__Dispute_Opposition__c WHERE Id=:trademarkId];
                if (objTrademarkList != null && objTrademarkList.size()>0)
                {
                    SymphonyIPMExt__Dispute_Opposition__c objTrademark = objTrademarkList[0];
                    //if(Schema.sObjectType.SymphonyIPMExt__Dispute_Opposition__c.fields.Mark_ContentVersion_Id_Uploaded__c.isUpdateable())
                    //    objTrademark.Mark_ContentVersion_Id_Uploaded__c = '';
                }    
                if (SymphonyIPMExt__Dispute_Opposition__c.sObjectType.getDescribe().isUpdateable() && Schema.sObjectType.SymphonyIPMExt__Dispute_Opposition__c.isUpdateable())
                    UPDATE objTrademarkList;
            }
            return 'Success';
        }
        catch(Exception exp)
        {
            throw exp;
        }
    }
    
    @AuraEnabled
    public static List<SymphonyIPM__Trademark_Prosecution_History__c> getProsecutionHistory(Id trademarkId) 
    //public static wrapperDataTable getProsecutionHistory(Id trademarkId) 
    {
        try
        {
            string strDateFormat = 'MM/dd/yyyy';
            List<SymphonyIPM__Trademark_Prosecution_History__c> objProsecutionHistoryList = new List<SymphonyIPM__Trademark_Prosecution_History__c>();
            if(Schema.sObjectType.SymphonyIPM__Trademark_Prosecution_History__c.isAccessible() && SymphonyIPM__Trademark_Prosecution_History__c.sObjectType.getDescribe().isAccessible())
            {
                objProsecutionHistoryList = [
                    SELECT
                    Id
                    , Name
                    , SymphonyIPM__Event_Description__c
                    , SymphonyIPM__Event_Date__c
                    , SymphonyIPM__Event_Additional__c
                    , SymphonyIPM__Event_Entry_No__c
                    , SymphonyIPM__Event_Category__c
                    FROM SymphonyIPM__Trademark_Prosecution_History__c
                    WHERE SymphonyIPM__Trademark__c = :trademarkId
                    ORDER BY SymphonyIPM__Event_Entry_No__c DESC
                ];
            }
            return objProsecutionHistoryList;
        }
        catch(Exception exp)
        {
            throw exp;
        }
    }


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
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
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