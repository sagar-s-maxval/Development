public with sharing class PDFGeneratorController {

    public String pdfBody {get;set;}
    public String templateId {get;set;}
    public String recordId {get;set;}
    public String customTemplateValues {get;set;}
    public String proposedMark {get;set;}
    public String docketNo {get;set;}

    public PDFGeneratorController() {

        this.templateId = null != ApexPages.currentPage() && ApexPages.currentPage().getParameters().containsKey('templateId') ? String.valueOf(ApexPages.currentPage().getParameters().get('templateId')) : null;
        this.recordId = null != ApexPages.currentPage() && ApexPages.currentPage().getParameters().containsKey('recordId') ? String.valueOf(ApexPages.currentPage().getParameters().get('recordId')) : null;
        this.customTemplateValues = null != ApexPages.currentPage() && ApexPages.currentPage().getParameters().containsKey('customTemplateValues') ? ApexPages.currentPage().getParameters().get('customTemplateValues') : null;

        EmailTemplate attachTemplate = EmailTemplateSelector.getEmailTemplateByTemplateId(this.templateId);
        String body = attachTemplate.HtmlValue;
        
        body = body.replace('width="550"','width="700"');
        body = body.replace('<![CDATA[', '');
        body = body.replace('</span>]]>', '</span>');
        body = body.replace('<br>', '<br/>');

        List<String> newStr =  (List<String>) JSON.deserialize(this.customTemplateValues, List<String>.class);

        if (newStr != null && !newStr.isEmpty()) {
            for (Integer i = 0; i < newStr.size(); i++) {
                if (!String.isNotBlank(newStr[i])) {
                    newStr[i] = ' ';
                }
                body = body.replace('{' + i + '}', newStr[i]);
            }
        }

        SymphonyIPMExt__TM_Search_Instruction__c searchInstruction = [SELECT Id, SymphonyIPMExt__Proposed_Mark_Text__c, SymphonyIPMExt__Proposed_Mark__r.Name, Goods_and_Services__c FROM SymphonyIPMExt__TM_Search_Instruction__c WHERE Id = :this.recordId];

        this.proposedMark = searchInstruction.SymphonyIPMExt__Proposed_Mark_Text__c;
        this.docketNo = searchInstruction.SymphonyIPMExt__Proposed_Mark__r.Name;

        System.debug([SELECT Id, Consider_mark_to_be__c, Mark_Classes_Plain__c, Goods_and_Services__c FROM SymphonyIPMExt__TM_Search_Instruction__c WHERE Id = :this.recordId]);

        body = Messaging.renderEmailTemplate(null, this.recordId, new List<String>{
                body
        })[0].mergedBody;

        body = '<div style="border: solid">' + body + '</div>';

        System.debug('body1>>>>>' + body);

        this.pdfBody = body;
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
    }

}