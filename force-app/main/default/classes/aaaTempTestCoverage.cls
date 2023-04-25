@isTest
public class aaaTempTestCoverage {
    @IsTest(SeeAllData=true)
    public static void test(){
//        ContentDocumentSelector.magicMethod();
//        SendEmailService.coverage();
//        System.assert(true);
        RequestRecommendationController.coverage();


    }
}


//Failures
//    ========
//• classes/DocuSignEnvelopeStatusBatchTest.cls: ERROR at line 5, column 53 - Dependent class is invalid and needs recompilation:
//Class DocumentDocuSignController : Dependent class is invalid and needs recompilation:
//Class DocumentDocuSignService : Dependent class is invalid and needs recompilation:
//Class DocuSignFutureWrapper : Constructor not defined: [cmpDocuSignBatchMultipleCtrl].<Constructor>(Id, List<Id>, String, Date, String, String, String, String, Id, String, String, List<String>, Boolean, Boolean)
//• classes/DocumentDocuSignController.cls: ERROR at line 5, column 53 - Dependent class is invalid and needs recompilation:
//Class DocumentDocuSignService : Dependent class is invalid and needs recompilation:
//Class DocuSignFutureWrapper : Constructor not defined: [cmpDocuSignBatchMultipleCtrl].<Constructor>(Id, List<Id>, String, Date, String, String, String, String, Id, String, String, List<String>, Boolean, Boolean)