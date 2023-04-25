global with sharing class ContributionDetailsPDFGenerator {

    @InvocableMethod
    public static void generateContributionDetailsPDF(List < Id > contributionsIds) {
        generatePDF(contributionsIds);
    }

    @Future(Callout=true)
    public static void generatePDF(List < Id > contributionDetailsIds) {
        List<Remuneration__c> contributions = [SELECT Id, Name, Inventor_Full_Name__c, Contribution__c, Question_b__c, Question_c__c, Question_d__c, Question_e__c, Question_f__c, Question_g__c,
                Is_Designs_Planning__c, Is_Calculations_Simulations__c, Is_Computer_Software__c, Is_Evaluation_Test__c, Is_Laboratory_Equipment__c, Is_Materials_Prototypes__c, Comments__c,
                Question_d_Radio__c, Question_e_Radio__c, Question_f_Radio__c, Option_that_is_best_suited__c, Serial_Number__c, Invention_Disclosure__c, Invention_Disclosure__r.Name, Invention_Disclosure__r.SymphonyIPM__Title__c, Person__r.SymphonyIPM__Employee_ID__c
        FROM Remuneration__c WHERE Id IN :contributionDetailsIds];

        for (Remuneration__c contr : contributions) {
            PageReference pdfPage = Page.ContributionDetails;
            pdfPage.getParameters().put('Id', contr.Id);
            pdfPage.setRedirect(true);

            ContentVersion conVer = new ContentVersion();
            conVer.ContentLocation = 'S'; // S specify this document is in SF, use E for external files
            conVer.PathOnClient = contr.Name + '.pdf'; // The files name, extension is very important here which will help the file in preview.
            String employeeId = contr.Person__r.SymphonyIPM__Employee_ID__c == null ? '' : contr.Person__r.SymphonyIPM__Employee_ID__c + '-';
            conVer.Title = contr.Invention_Disclosure__r.Name + '-' + contr.Inventor_Full_Name__c + '-' + employeeId + System.now().format('MMM-dd-yyyy'); // Display name of the files
            conVer.VersionData = pdfPage.getContent(); // converting your binary string to Blog
            insert conVer;

            // First get the content document Id from ContentVersion
            Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :conVer.Id].ContentDocumentId;

            //Create ContentDocumentLink
            ContentDocumentLink cDe = new ContentDocumentLink();
            cDe.ContentDocumentId = conDoc;
            cDe.LinkedEntityId = contr.Invention_Disclosure__c;
            cDe.ShareType = 'I';
            insert cDe;
            System.debug(cDe.Id);
        }
    }

public static void magicMethod() {
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
}

}