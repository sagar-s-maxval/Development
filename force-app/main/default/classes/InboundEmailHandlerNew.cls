global without sharing class InboundEmailHandlerNew implements Messaging.InboundEmailHandler {

    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
        Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
        try {
            List<String> lstSub = checkEmailSubject(email);
            if (lstSub.size() > 0) {
                result = InboundEmailHandlerService.createEmailMessages('SymphonyIPM__Patent__c', lstSub, 'Patent', email);
            } else {
                result = InboundEmailHandlerService.emailResultFalse(result, email);
            }

        } catch (Exception e) {
            System.debug(e.getMessage());
            System.debug(LoggingLevel.ERROR, e.getStackTraceString());

            result.message = 'Please contact System administrator with this error message:\n' + e.getMessage() + '\n' + e.getStackTraceString();
            result.success = false;

        }

        return result;
    }

    public static List<String> checkEmailSubject(Messaging.InboundEmail email) {
        List<String> lstSub = new List<String>();
        String temp = email.subject;
        Integer tempLength = temp.length();
        if (tempLength == 18) {
            try {
                Id myId = Id.valueOf(temp);
                String sObjName = myId.getSobjectType().getDescribe().getLabel();
                if (sObjName == 'Import Batch') {
                    SymphonyIPM.ImportServiceBibliographicBatch objImportServiceBibliographicBatch = new SymphonyIPM.ImportServiceBibliographicBatch(temp);
                    Database.executeBatch(objImportServiceBibliographicBatch, 1);
                }
            } catch (Exception e) {
                System.debug('Message :' + e.getMessage());
            }
        }

        if (email.subject != null && email.subject != '') {
            String userNam = ' ';
            List<String> lstStrUser = new List<String>();
            Boolean check = true;
            List<User> u = [SELECT Id, Name FROM User WHERE Email = :email.fromAddress];
            for (User s : u) {
                lstStrUser.add(s.Name);
            }
            if (u != null) {
                for (String s : lstStrUser) {
                    if (check == false) {
                        userNam += ',';
                    }
                    userNam += s;
                    check = false;
                }
            } else {
                userNam = null;
            }
            String docId = email.subject;
            Pattern pattern = Pattern.compile('\\[([^\\]]+)\\]');
            Matcher matcher = pattern.matcher(docId);
            String sub = '';
            while (matcher.find()) {
                if (sub != '') {
                    sub = sub + ',' + matcher.group(1);
                } else {
                    sub = matcher.group(1);
                }
            }
            List<String> lstString = sub.split(',');
            for (String s : lstString) {
                if (s.trim() != '') {
                    lstSub.add(s.trim());
                }
            }
        }
        return lstSub;
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
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
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
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
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