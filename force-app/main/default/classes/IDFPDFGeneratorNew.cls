Global with sharing class IDFPDFGeneratorNew
{
    
  /*  public static final String FORM_HTML_START = '<HTML><BODY>';
    public static final String FORM_HTML_END = '</BODY></HTML>';
    public static String formatDate(Date d) {
        
        return d.year() + '-' + d.month() + '-' + d.day();
        
    }*/
   @Future(callout=true)
    public static void generateIDFPDF(List<id> idf)
    {  //SymphonyIPM__IDF_Questions__c settings = SymphonyIPM__IDF_Questions__c.getInstance('Invention Disclosure Questions');
    
      
      
        List<SymphonyIPM__Invention_Disclosure_New__c> idfs = new List<SymphonyIPM__Invention_Disclosure_New__c>();
      /*  String pdfContent = '';
        String LstInventors = '';
        String relatedInvDisclosures= '';
        String country = '';  
        String path = '';
        String primaryinv = '';
        String primarycontact = '';
        String mentor= '';
        String DisclosureDate= '';*/
        if(Schema.sObjectType.SymphonyIPM__Invention_Disclosure_New__c.isAccessible() && SymphonyIPM__Invention_Disclosure_New__c.sObjectType.getDescribe().isAccessible()) 
        {
          
            idfs=[
                    select id,name,LastModifiedDate,SymphonyIPM__Inventor_Email_Id__c,SymphonyIPM__Invention_Date__c,Competing_Products_Solutions__c,Current_Commercial_Use__c,Current_Stage_of_Invention__c,Don_t_know__c,
                    Future_Implementation__c,Impossible_unless_3rd_party_admitted_use__c,Invention_Description__c,Funding_Source__c,Is_Competing_Products_Solutions__c,Is_Current_Commercisl__c,Managing_Segment_New__c,
                    Is_External__c,Is_Future_Implementation__c,Is_Prior_Submissions__c,Is_Public_Disclosure__c,Is_Reading_Product_literature__c,Is_Reverse_Engineering__c,Is_Testing_a_competitive_solution__c,
                    Is_Third_Party_Contribution__c,Mentors__c,Mentor__r.Name,Other__c,Others__c,Primary_Contact__c,Primary_Contact__r.Name,Prior_Submission_Description__c,Public_Disclosure_Date__c,Public_Disclosure__c,Reading_Product_literature__c,
                    Reverse_Engineering__c,SymphonyIPM__Alternative_Implementations_New__c,SymphonyIPM__Detailed_Description__c,Third_Party_Confidentiality__c,Is_Third_Party_Confidentiality__c,SymphonyIPM__Disclosure_Status__c,SymphonyIPM__Hierarchy__c,SymphonyIPM__Hierarchy__r.Name,SymphonyIPM__Inventive_Features__c,
                    SymphonyIPM__Primary_Inventor__c,SymphonyIPM__Primary_Inventor__r.Name,SymphonyIPM__Primary_Inventor__r.SymphonyIPM__Email__c,Primary_Inventor__c,Primary_Inventor__r.Name,SymphonyIPM__Title__c,Testing_a_competitive_solution__c,Third_Party_Contribution__c,External_Use__c,(select SymphonyIPM__Inventor__c,SymphonyIPM__Inventor__r.Name,SymphonyIPM__Inventor__r.SymphonyIPM__Email__c from SymphonyIPM__Inventor_Details__r)
                    from SymphonyIPM__Invention_Disclosure_New__c where Id in : idf
                 ];
        }
        if(idfs!=null && idfs.size()>0)                                            
        for(SymphonyIPM__Invention_Disclosure_New__c inv : idfs)
        {
            savepdf(inv);
                
        }
    }
            //country = inv.SymphonyIPM__Invention_Country__r.Name;
           /* path = inv.SymphonyIPM__Hierarchy__r.Name;
            if(inv.SymphonyIPM__Primary_Inventor__c != null)
            {
                primaryinv= inv.SymphonyIPM__Primary_Inventor__r.Name;
            }
            else
            {
                primaryinv = '';
            }
            system.debug('primaryinv'+ primaryinv);
            if(inv.Primary_Contact__c != null)
            {
                primarycontact = inv.Primary_Contact__r.Name;
            }
            else
            {
                primarycontact = '';
            }
            if(inv.Mentors__c != null)
            {
                mentor = inv.Mentors__c;
            }
            else
            {
                mentor = '';
            }
            if(inv.Public_Disclosure_Date__c != null) 
            DisclosureDate=formatDate(inv.Public_Disclosure_Date__c);
            pdfContent = '' + FORM_HTML_START;
            for(SymphonyIPM__Additional_Inventor__c adinv : inv.SymphonyIPM__Inventor_Details__r)
            {
                system.debug(adinv.SymphonyIPM__Inventor__r.Name);
                if(adinv.SymphonyIPM__Inventor__r.Name !=inv.SymphonyIPM__Primary_Inventor__r.Name){
                if(LstInventors == '')
                    LstInventors=adinv.SymphonyIPM__Inventor__r.Name + ' ( ' + adinv.SymphonyIPM__Inventor__r.SymphonyIPM__Email__c + ' ) ';
                else
                    LstInventors = LstInventors+', '+adinv.SymphonyIPM__Inventor__r.Name + ' ( ' + adinv.SymphonyIPM__Inventor__r.SymphonyIPM__Email__c + ' ) ';
               }     
                    
            }
       
            try
            {
                pdfContent = '' + FORM_HTML_START;
                pdfContent = pdfContent + '<H2>Invention Disclosure Submission</H2>';
                
                //Dynamically grab all the fields to store in the PDF
                Map<String, Schema.SObjectType> sobjectSchemaMap = Schema.getGlobalDescribe();
                Schema.DescribeSObjectResult objDescribe = sobjectSchemaMap.get(settings.SymphonyIPM__Namespace__c+'Invention_Disclosure_New__c').getDescribe();
                Map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
                
                //Append each Field to the PDF
                pdfContent = pdfContent + '<br>';
                pdfContent = pdfContent + '<P>' + settings.SymphonyIPM__Invention_Title__c + '&nbsp;' + '&nbsp;' + '&nbsp;' + '&nbsp;' + '&nbsp;' + '&nbsp;' + '&nbsp;' + '&nbsp;' + '&nbsp;' + ':' + '&nbsp;' + '&nbsp;'+inv.get(settings.SymphonyIPM__Namespace__c+'Title__c') + '</P>';
                pdfContent = pdfContent + '<br>';
                //pdfContent = pdfContent + '<H4>Funding source </H4>';
                pdfContent = pdfContent + '<P>' + settings.SymphonyIPM__made_or_used_this_Invention__c + '&nbsp;' + '&nbsp;' + '&nbsp;' + '&nbsp;' + '&nbsp;' + '&nbsp;' + '&nbsp;' + '&nbsp;' + '&nbsp;' + ':' + '&nbsp;' + '&nbsp;'+inv.get('Funding_Source__c') + '</P>';             
                pdfContent = pdfContent + '<br>';
                //Managing Segment
                pdfContent = pdfContent + '<P>' + settings.Managing_Segment__c + '&nbsp;' + '&nbsp;' + '&nbsp;' + '&nbsp;' + ':' + '&nbsp;' + '&nbsp;'+inv.get('Managing_Segment_New__c') + '</P>';             
                pdfContent = pdfContent + '<br>';
                //----------------
                pdfContent = pdfContent + '<P>' + settings.SymphonyIPM__Select_a_Path__c + ':'+ '&nbsp;' +'&nbsp;' + + path  + '</P>';
                pdfContent = pdfContent + '<br>';
                pdfContent = pdfContent + '<P>' + settings.Current_stage_of_invention__c + ':'+ '&nbsp;' + '&nbsp;'; 
                 if(inv.get('Current_Stage_of_Invention__c')!= null) 
                    pdfContent = pdfContent + inv.get('Current_Stage_of_Invention__c') + '</P>';
                    else
                       pdfContent = pdfContent + '</P>';
                pdfContent = pdfContent + '<br>';
                pdfContent = pdfContent + '<div align="center"><H3><B> Contributor Information </B></H3></div>';
                pdfContent = pdfContent + '<br>';
               
                pdfContent = pdfContent + '<P>' + settings.Primary_Inventor__c + ':'+ '&nbsp;' +'&nbsp;' +'<B>' + primaryinv +' ( '+ inv.SymphonyIPM__Primary_Inventor__r.SymphonyIPM__Email__c + ' )' +'</B></P>';
                pdfContent = pdfContent + '<br>';
                pdfContent = pdfContent + '<P>' + settings.SymphonyIPM__Add_Inventors__c + ':'+ '&nbsp;' + '&nbsp;'  + LstInventors + '</P>';
                pdfContent = pdfContent + '<br>';
                pdfContent = pdfContent + '<P>' + settings.Primary_Contact__c + ':'+ '&nbsp;' +'&nbsp;' + + primarycontact  + '</P>';
                pdfContent = pdfContent + '<br>';
                //pdfContent = pdfContent + '<P> Additional Inventors </P>';
                //pdfContent = pdfContent + '<br>';
               pdfContent = pdfContent + '<P>' + settings.Mentor__c + ':'+ '&nbsp;' +'&nbsp;' + + mentor  + '</P>';
                pdfContent = pdfContent + '<br>';
                pdfContent = pdfContent + '<div align="center"><H3><B> Invention Description </B></H3></div>';
                pdfContent = pdfContent + '<br>';
                //pdfContent = pdfContent + '<P><B>Step 1 - Invention Description </B></P>';
                //pdfContent = pdfContent + '<br>';
                pdfContent = pdfContent + '<P>' + settings.SymphonyIPM__Question_1__c;
                if(inv.get('Invention_Description__c')!= null) 
                    pdfContent = pdfContent + inv.get('Invention_Description__c') + '</P>';
                else
                pdfContent = pdfContent + '</P>';
                pdfContent = pdfContent + '<br>';
                pdfContent = pdfContent + '<P>' + settings.SymphonyIPM__Question_2__c;
                if(inv.get('SymphonyIPM__Detailed_Description__c')!= null) 
                    pdfContent = pdfContent + inv.get('SymphonyIPM__Detailed_Description__c') + '</P>';
                else
                    pdfContent = pdfContent + '</P>';
                pdfContent = pdfContent + '<br>';
                
                pdfContent = pdfContent + '<P>' + settings.SymphonyIPM__Question_3__c;
                if(inv.get('SymphonyIPM__Inventive_Features__c')!= null) 
                    pdfContent = pdfContent + inv.get('SymphonyIPM__Inventive_Features__c') + '</P>';
                else
                    pdfContent = pdfContent + '</P>';
                pdfContent = pdfContent + '<br>';
                
                pdfContent = pdfContent + '<P>' + settings.SymphonyIPM__Question_4__c;
                if(inv.get('SymphonyIPM__Alternative_Implementations_New__c')!= null) 
                    pdfContent = pdfContent + inv.get('SymphonyIPM__Alternative_Implementations_New__c') + '</P>';
                else
                    pdfContent = pdfContent + '</P>';
                
                pdfContent = pdfContent + '<br>';
                
                pdfContent = pdfContent + '<div align="center"><H3><B> Additional Questions </B></H3></div>';
                pdfContent = pdfContent + '<br>';
                pdfContent = pdfContent + '<P>' + settings.Prior_Submissions__c + ' '+ '&nbsp;' + '&nbsp;'; 
                  if(inv.get('Is_Prior_Submissions__c')!= null && inv.get('Is_Prior_Submissions__c')== true ) 
                    pdfContent = pdfContent + 'Yes' + '</P>';
                    else if(inv.get('Is_Prior_Submissions__c')!= null && inv.get('Is_Prior_Submissions__c')== false )
                       pdfContent = pdfContent + 'No' +'</P>';
                pdfContent = pdfContent + '<P>' + settings.Description__c + ':'+ '&nbsp;' + '&nbsp;';
                if(inv.get('Prior_Submission_Description__c')!= null) 
                    pdfContent = pdfContent + inv.get('Prior_Submission_Description__c') + '</P>';
                    else
                       pdfContent = pdfContent + '</P>';
                       pdfContent = pdfContent + '<br>';
                
                
                pdfContent = pdfContent + '<P>' + settings.Public_Disclosures__c + ' '+ '&nbsp;' + '&nbsp;'; 
                if(inv.get('Is_Public_Disclosure__c')!= null && inv.get('Is_Public_Disclosure__c')== true ) 
                    pdfContent = pdfContent + 'Yes' + '</P>';
                else if(inv.get('Is_Public_Disclosure__c')!= null && inv.get('Is_Public_Disclosure__c')== false )
                    pdfContent = pdfContent + 'No' +'</P>';
                pdfContent = pdfContent + '<P>' + settings.Public_Disclosures_Date__c + ':'+ '&nbsp;' + '&nbsp;';
                if(inv.get('Public_Disclosure_Date__c')!= null) 
                    pdfContent = pdfContent + DisclosureDate + '</P>';
                    else
                       pdfContent = pdfContent + '</P>';
                //pdfContent = pdfContent + '<br>';
                pdfContent = pdfContent + '<P>' + settings.Description__c + ':'+ '&nbsp;' + '&nbsp;';
                if(inv.get('Public_Disclosure__c')!= null) 
                    pdfContent = pdfContent + inv.get('Public_Disclosure__c') + '</P>';
                else
                pdfContent = pdfContent + '</P>';
                pdfContent = pdfContent + '<br>';
                //pdfContent = pdfContent + '<P>' + settings.Public_Disclosures_Date__c  + ':'+ '&nbsp;' + '&nbsp;';
               
                
                
                
                pdfContent = pdfContent + '<P>' + settings.Current_Commercial_Use__c + ' '+ '&nbsp;' + '&nbsp;'; 
                if(inv.get('Is_Current_Commercisl__c')!= null && inv.get('Is_Current_Commercisl__c')== true ) 
                    pdfContent = pdfContent + 'Yes' + '</P>';
                else if(inv.get('Is_Current_Commercisl__c')!= null && inv.get('Is_Current_Commercisl__c')== false )
                    pdfContent = pdfContent + 'No' +'</P>';
                pdfContent = pdfContent + '<p>' + settings.Description__c + ':'+ '&nbsp;' + '&nbsp;';
                if(inv.get('Current_Commercial_Use__c')!= null) 
                    pdfContent = pdfContent + inv.get('Current_Commercial_Use__c') + '</p>';
                else
                    pdfContent = pdfContent + '</P>';
                pdfContent = pdfContent + '<br>';
                pdfContent = pdfContent + '<P>' + settings.External_Use_Desc__c + ' '+ '&nbsp;' + '&nbsp;';
                if(inv.get('Is_External__c')!= null && inv.get('Is_External__c')== true ) 
                    pdfContent = pdfContent + 'Yes' + '</P>';
                else if(inv.get('Is_External__c')!= null && inv.get('Is_External__c')== false )
                    pdfContent = pdfContent + 'No' +'</P>';
                pdfContent = pdfContent + '<P>' + settings.Description__c + ':'+ '&nbsp;' + '&nbsp;';
                if(inv.get('External_Use__c')!= null) 
                    pdfContent = pdfContent + inv.get('External_Use__c') + '</P>';
                else
                    pdfContent = pdfContent + '</P>';
                pdfContent = pdfContent + '<br>';
                
                
                pdfContent = pdfContent + '<P>' + settings.Third_Party_Payor__c + ' '+ '&nbsp;' + '&nbsp;'; 
                if(inv.get('Is_Third_Party_Confidentiality__c')!= null && inv.get('Is_Third_Party_Confidentiality__c')== true ) 
                    pdfContent = pdfContent + 'Yes' + '</P>';
                else if(inv.get('Is_Third_Party_Confidentiality__c')!= null && inv.get('Is_Third_Party_Confidentiality__c')== false )
                    pdfContent = pdfContent + 'No' +'</P>';
                pdfContent = pdfContent + '<P>' + settings.Description__c + ':'+ '&nbsp;' + '&nbsp;';
                if(inv.get('Third_Party_Confidentiality__c')!= null) 
                    pdfContent = pdfContent + inv.get('Third_Party_Confidentiality__c') + '</P>';
                else
                pdfContent = pdfContent + '</P>';
                pdfContent = pdfContent + '<br>';
                
                
                pdfContent = pdfContent + '<P>' + settings.Future_Implementation__c + ' '+ '&nbsp;' + '&nbsp;'; 
                if(inv.get('Is_Future_Implementation__c')!= null && inv.get('Is_Future_Implementation__c')== true ) 
                    pdfContent = pdfContent + 'Yes' + '</P>';
                else if(inv.get('Is_Future_Implementation__c')!= null && inv.get('Is_Future_Implementation__c')== false )
                    pdfContent = pdfContent + 'No' +'</P>';
                pdfContent = pdfContent + '<P>' + settings.Description__c + ':'+ '&nbsp;' + '&nbsp;';
                if(inv.get('Future_Implementation__c')!= null) 
                    pdfContent = pdfContent + inv.get('Future_Implementation__c') + '</P>';
                else
                pdfContent = pdfContent + '</P>';
                pdfContent = pdfContent + '<br>';
                
                
                
                
                pdfContent = pdfContent + '<P>' + settings.Competing_Products_Solutions__c + ':'+ '&nbsp;' + '&nbsp;'; 
                if(inv.get('Is_Competing_Products_Solutions__c')!= null && inv.get('Is_Competing_Products_Solutions__c')== true ) 
                    pdfContent = pdfContent + 'Yes' + '</P>';
                else if(inv.get('Is_Competing_Products_Solutions__c')!= null && inv.get('Is_Competing_Products_Solutions__c')== false )
                    pdfContent = pdfContent + 'No' +'</P>';
                pdfContent = pdfContent + '<P>' + settings.Description__c + ':'+ '&nbsp;' + '&nbsp;';
                if(inv.get('Competing_Products_Solutions__c')!= null) 
                    pdfContent = pdfContent + inv.get('Competing_Products_Solutions__c') + '</P>';
                else
                pdfContent = pdfContent + '</P>';
                pdfContent = pdfContent + '<br>';
                
                
                pdfContent = pdfContent + '<P>' + settings.Third_Party_Contributions__c + ' '+ '&nbsp;' + '&nbsp;'; 
                if(inv.get('Is_Third_Party_Contribution__c')!= null && inv.get('Is_Third_Party_Contribution__c')== true ) 
                    pdfContent = pdfContent + 'Yes' + '</P>';
                else if(inv.get('Is_Third_Party_Contribution__c')!= null && inv.get('Is_Third_Party_Contribution__c')== false )
                    pdfContent = pdfContent + 'No' +'</P>';
                pdfContent = pdfContent + '<P>' + settings.Description__c + ':'+ '&nbsp;' + '&nbsp;';
                if(inv.get('Third_Party_Contribution__c')!= null) 
                    pdfContent = pdfContent + inv.get('Third_Party_Contribution__c') + '</P>';
                else
                pdfContent = pdfContent + '</P>';
                pdfContent = pdfContent + '<br>';
                
                
                
                pdfContent = pdfContent + '<P>' + settings.Detection__c + ':'+ '&nbsp;' + '&nbsp;'; 
                pdfContent = pdfContent + '<br>';
                pdfContent = pdfContent + '<P>' + settings.Reverse_engineering_or_code__c + ' '+ '&nbsp;' + '&nbsp;';
                if(inv.get('Is_Reverse_Engineering__c')!= null && inv.get('Is_Reverse_Engineering__c')== true ) 
                    pdfContent = pdfContent + 'Yes' + '</P>';
                else if(inv.get('Is_Reverse_Engineering__c')!= null && inv.get('Is_Reverse_Engineering__c')== false )
                    pdfContent = pdfContent + 'No' +'</P>';
                pdfContent = pdfContent + '<P>' + settings.Description__c + ':'+ '&nbsp;' + '&nbsp;';
                if(inv.get('Reverse_Engineering__c')!= null) 
                    pdfContent = pdfContent + inv.get('Reverse_Engineering__c') + '</P>';
                else
                pdfContent = pdfContent + '</P>';
                pdfContent = pdfContent + '<br>';
                
                pdfContent = pdfContent + '<P>' + settings.Testing_a_competitive_solution__c + ':'+ '&nbsp;' + '&nbsp;';
                if(inv.get('Is_Testing_a_competitive_solution__c')!= null && inv.get('Is_Testing_a_competitive_solution__c')== true ) 
                    pdfContent = pdfContent + 'Yes' + '</P>';
                else if(inv.get('Is_Testing_a_competitive_solution__c')!= null && inv.get('Is_Testing_a_competitive_solution__c')== false )
                    pdfContent = pdfContent + 'No' +'</P>';
                pdfContent = pdfContent + '<P>' + settings.Description__c + ':'+ '&nbsp;' + '&nbsp;';
                if(inv.get('Testing_a_competitive_solution__c')!= null) 
                    pdfContent = pdfContent + inv.get('Testing_a_competitive_solution__c') + '</P>';
                else
                pdfContent = pdfContent + '</P>';
                pdfContent = pdfContent + '<br>';
                
                
                pdfContent = pdfContent + '<P>' + settings.Reading_product_literature__c + ':'+ '&nbsp;' + '&nbsp;';
                if(inv.get('Is_Reading_Product_literature__c')!= null && inv.get('Is_Reading_Product_literature__c')== true ) 
                    pdfContent = pdfContent + 'Yes' + '</P>';
                else if(inv.get('Is_Reading_Product_literature__c')!= null && inv.get('Is_Reading_Product_literature__c')== false )
                    pdfContent = pdfContent + 'No' +'</P>';
                pdfContent = pdfContent + '<P>' + settings.Description__c + ':'+ '&nbsp;' + '&nbsp;';
                if(inv.get('Reading_Product_literature__c')!= null) 
                    pdfContent = pdfContent + inv.get('Reading_Product_literature__c') + '</P>';
                else
                pdfContent = pdfContent + '</P>';
                pdfContent = pdfContent + '<br>';
                
                
                pdfContent = pdfContent + '<P>' + settings.Impossible_unless_3rd_party_admits__c + ':'+ '&nbsp;' + '&nbsp;';
                if(inv.get('Impossible_unless_3rd_party_admitted_use__c')!= null && inv.get('Impossible_unless_3rd_party_admitted_use__c')== true ) 
                    pdfContent = pdfContent + 'Yes' + '</P>';
                else if(inv.get('Impossible_unless_3rd_party_admitted_use__c')!= null && inv.get('Impossible_unless_3rd_party_admitted_use__c')== false )
                    pdfContent = pdfContent + 'No' +'</P>';
                else
                pdfContent = pdfContent + '</P>';
                pdfContent = pdfContent + '<br>';
                
                pdfContent = pdfContent + '<P>' + settings.Dont_Know__c + ':'+ '&nbsp;' + '&nbsp;';
                if(inv.get('Don_t_know__c')!= null && inv.get('Don_t_know__c')== true ) 
                    pdfContent = pdfContent + 'Yes' + '</P>';
                else if(inv.get('Don_t_know__c')!= null && inv.get('Don_t_know__c')== false )
                    pdfContent = pdfContent + 'No' +'</P>';
                else
                pdfContent = pdfContent + '</P>';
                pdfContent = pdfContent + '<br>';
                
                
                pdfContent = pdfContent + '<P>' + settings.Other__c  + ':'+ '&nbsp;' + '&nbsp;';
                if(inv.get('Other__c')!= null && inv.get('Other__c')== true ) 
                    pdfContent = pdfContent + 'Yes' + '</P>';
                else if(inv.get('Other__c')!= null && inv.get('Other__c')== false )
                    pdfContent = pdfContent + 'No' +'</P>';
                pdfContent = pdfContent + '<P>' + settings.Description__c + ':'+ '&nbsp;' + '&nbsp;';
                if(inv.get('Others__c')!= null) 
                    pdfContent = pdfContent + inv.get('Others__c') + '</P>';
                else
                pdfContent = pdfContent + '</P>';
                pdfContent = pdfContent + '<br>';      
                
                pdfContent = pdfContent + FORM_HTML_END;
            }catch(Exception e)
            {
                pdfContent = '' + FORM_HTML_START;
                pdfContent = pdfContent + '<P>THERE WAS AN ERROR GENERATING PDF: ' + e.getMessage() +' '+e.getLineNumber()+  '</P>';
                pdfContent = pdfContent + FORM_HTML_END;
            }*/
            //attachPDF(inv,pdfContent);
            //string discId =inv.id;
        
    public static void savepdf(SymphonyIPM__Invention_Disclosure_New__c invention) {
      PageReference pdf = Page.DisclosurePDF;
      pdf.getParameters().put('id',invention.id);
        //pdf.getParameters().put('msg',LstInventors);  
        Blob body;
        if(Test.isRunningTest()) {
             body = blob.valueOf('Unit.Test');
        } else {
            body = pdf.getContentAsPDF();
        }

     // Blob body = pdf.getContentAsPDF();
       try
        {
            if(Schema.sObjectType.ContentVersion.isCreateable() 
                && ContentVersion.sObjectType.getDescribe().isCreateable() 
                && Schema.sObjectType.ContentVersion.isAccessible() 
                && Schema.sObjectType.ContentDocumentLink.isCreateable() 
                && ContentDocumentLink.sObjectType.getDescribe().isCreateable()
                )
            {
                ContentVersion conVer = new ContentVersion();
                conVer.ContentLocation = 'S'; // S specify this document is in SF, use E for external files
                conVer.PathOnClient = invention.SymphonyIPM__Title__c+ '.pdf';  // The files name, extension is very important here which will help the file in preview.
                conVer.Title = invention.SymphonyIPM__Title__c+' -'+invention.LastModifiedDate+'.pdf'; // Display name of the files
                conVer.VersionData =  body; // converting your binary string to Blog
                insert conVer;
                
                // First get the content document Id from ContentVersion
                Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;
                
                //Create ContentDocumentLink
                ContentDocumentLink cDe = new ContentDocumentLink();
                cDe.ContentDocumentId = conDoc;
                cDe.LinkedEntityId = invention.Id; // you can use objectId,GroupId etc
                cDe.ShareType = 'V'; // Inferred permission, checkout description of ContentDocumentLink object for more details
               // cDe.Visibility = 'ALL';
                insert cDe;
            }
            
        }catch(Exception e)
        {
            system.debug(e.getMessage());
        } 
  } 
   /* public static void attachPDF(SymphonyIPM__Invention_Disclosure_New__c invention, String pdfContent)
    {
        if(invention!=null)
        
        try
        {
            if(Schema.sObjectType.ContentVersion.isCreateable() 
                && ContentVersion.sObjectType.getDescribe().isCreateable() 
                && Schema.sObjectType.ContentVersion.isAccessible() 
                && Schema.sObjectType.ContentDocumentLink.isCreateable() 
                && ContentDocumentLink.sObjectType.getDescribe().isCreateable()
                )
            {
                ContentVersion conVer = new ContentVersion();
                conVer.ContentLocation = 'S'; // S specify this document is in SF, use E for external files
                conVer.PathOnClient = invention.SymphonyIPM__Title__c+ '.pdf';  // The files name, extension is very important here which will help the file in preview.
                conVer.Title = invention.SymphonyIPM__Title__c+' -'+invention.LastModifiedDate+'.pdf'; // Display name of the files
                conVer.VersionData =  Blob.toPDF(pdfContent); // converting your binary string to Blog
                insert conVer;
                
                // First get the content document Id from ContentVersion
                Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;
                
                //Create ContentDocumentLink
                ContentDocumentLink cDe = new ContentDocumentLink();
                cDe.ContentDocumentId = conDoc;
                cDe.LinkedEntityId = invention.Id; // you can use objectId,GroupId etc
                cDe.ShareType = 'I'; // Inferred permission, checkout description of ContentDocumentLink object for more details
               // cDe.Visibility = 'ALL';
                insert cDe;
            }
            
        }catch(Exception e)
        {
            system.debug(e.getMessage());
        }
    }*/
}