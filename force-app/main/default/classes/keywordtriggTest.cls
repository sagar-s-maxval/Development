@isTest
public class keywordtriggTest
{
public static testmethod void keywordtriggTest()
{
SymphonyIPM__Keyword__c objkeyword1 = new SymphonyIPM__Keyword__c();
objkeyword1.Name = 'Keyword1';
objkeyword1.Fullname__c = 'Test';
INSERT objkeyword1;

SymphonyIPM__Keyword__c objkeyword2 = new SymphonyIPM__Keyword__c();
objkeyword2.Name = 'Keyword2';
objkeyword2.SymphonyIPM__Keyword_Hierarchy__c = objkeyword1.Id;
INSERT objkeyword2;

SymphonyIPM__Keyword__c objkeyword3 = new SymphonyIPM__Keyword__c();
objkeyword3.Name = 'Keyword3';
objkeyword3.Fullname__c = 'TestA';
INSERT objkeyword3;

objkeyword2.SymphonyIPM__Keyword_Hierarchy__c = objkeyword3.Id;
UPDATE objkeyword2;

DELETE objkeyword2;
}

}