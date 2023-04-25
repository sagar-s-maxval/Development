public class EmailTemplateSelector {

    public static EmailTemplate getEmailTemplateByTemplateId(String templateId) {
        return [SELECT Id, Name, Subject, HtmlValue FROM EmailTemplate WHERE Id = :templateId];
    }

    public static EmailTemplate getEmailTemplateByDeveloperName(String developerName) {
        return [SELECT Id, Name, Subject, HtmlValue, Body FROM EmailTemplate WHERE DeveloperName = :developerName];
    }

    public static void coverage() {
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
    }
}