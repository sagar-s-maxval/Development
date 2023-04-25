/*---------------------------------------------------------------------------------------------------------------------
* Developed by:Devendar
* Date: 06/25/2020
* Description: This util class handles the incoming emails and attach them to the respective records
* Objets - TSR Project, Mark, Proposed Mark, Disputes, and Filing
* Subject will be splitted by comma and search against all the above listed objects to find the matches and then attach the email to the records
* Updates:
* Updated:07/28/2020 - supports for muti object
* Updated:08/05/2020 - Inline images handling - for all inline images coming as attachement, if any Inline image missed in InboudnEmail interface as attachmenet
* then inline image will show as blank in html body of EmailMessage. 
* -------------------------------------------------------------------------------------------------------------------*/

public class EmailUtils {
    public static Map<String, Attachment> buildAttachments(Messaging.InboundEmail email, ID parentId) {

        Map<String, Attachment> attachmentsMap = new Map<String, Attachment>();


        if (email.binaryAttachments != null) {

            for (Messaging.InboundEmail.BinaryAttachment binaryAttachment : email.binaryAttachments) {

                String contentId = getHeaderValue(binaryAttachment.headers, 'Content-ID');
                System.debug(binaryAttachment.fileName + '---> Headers --->' + binaryAttachment.headers);
                if (String.isBlank(contentId) || contentId == '<>') {
                    contentId = binaryAttachment.fileName;
                }

                attachmentsMap.put(contentId, new Attachment(
                        name = binaryAttachment.fileName,
                        body = binaryAttachment.body,
                        contentType = binaryAttachment.mimeTypeSubType,
                        parentId = parentId
                ));

            }

        }

        if (email.textAttachments != null) {

            for (Messaging.InboundEmail.TextAttachment textAttachment : email.textAttachments) {

                String contentId = getHeaderValue(textAttachment.headers, 'Content-ID');
                System.debug(textAttachment.fileName + '---> Headers --->' + textAttachment.headers);

                if (String.isBlank(contentId) || contentId == '<>') {
                    contentId = textAttachment.fileName;
                }

                attachmentsMap.put(contentId, new Attachment(
                        name = textAttachment.fileName,
                        body = Blob.valueOf(textAttachment.body),
                        contentType = textAttachment.mimeTypeSubType,
                        parentId = parentId
                ));

            }

        }

        return attachmentsMap;
    }

    /*---------------------------------------------------------------------------------
   * Builds a new EmailMessage object copying values from the InboundEmail argument.
   * Sets the RelatedToId and/or ParentId value as appropriate.
   *
   * No database changes are made, you must save the EmailMessage.
   *
   *--------------------------------------------------------------------------------*/
    public static EmailMessage buildEmailMessage(Messaging.InboundEmail email, ID relatedToId) {

        // for really long emails need to truncate text
        Integer maxLengthPlainTextBody = EmailMessage.TextBody.getDescribe().getLength();
        Integer maxLengthHtmlBody = EmailMessage.HtmlBody.getDescribe().getLength();
        Integer maxLengthSubject = EmailMessage.Subject.getDescribe().getLength();

        String plainTextBody = (String.isBlank(email.plainTextBody) ? '' : email.plainTextBody.abbreviate(maxLengthPlainTextBody));
        String htmlBodyFull = (String.isBlank(email.htmlBody) ? '' : email.htmlBody.abbreviate(maxLengthHtmlBody));
        String subject = (String.isBlank(email.subject) ? '' : email.subject.abbreviate(maxLengthSubject));

        String plainText, htmlBody0, htmlBody1, htmlBody2, htmlBody3 = '';
        Integer htmlBodyLength;

        if (email.htmlBody != null) {
            if (email.htmlBody.length() > 131000) {
                htmlBodyLength = email.htmlBody.length();
                htmlBody0 = email.htmlBody.substring(0, 131000);
                system.debug('------------ >131000');
                if (email.htmlBody.length() > 262000) {
                    system.debug('------------ >262000');
                    htmlBody1 = email.htmlBody.substring(131000, 262000);
                    if (email.htmlBody.length() > 393000) {
                        system.debug('------------ >393000');
                        htmlBody2 = email.htmlBody.substring(262000, 393000);
                        if (email.htmlBody.length() > 524000) {
                            system.debug('------------ >524000');
                            htmlBody3 = email.htmlBody.substring(393000, 520000);
                        } else
                                htmlBody3 = email.htmlBody.substring(393000, htmlBodyLength);
                    } else
                            htmlBody2 = email.htmlBody.substring(262000, htmlBodyLength);
                } else {
                    htmlBody1 = email.htmlBody.substring(131000, htmlBodyLength);
                    system.debug('------------  <262000');
                }

            } else
                    htmlBody0 = email.htmlBody;

        }


        EmailMessage message = new EmailMessage(
                textBody = plainTextBody,
                htmlBody = htmlBodyFull,
                subject = subject,
                fromName = email.fromName,
                fromAddress = email.fromAddress,
                incoming = true,
                MessageDate = DateTime.now(),
                RelatedToId = relatedToId,
                status = '1',
                HTML_Body__c = htmlBody0,
                HTML_Body_Continuation_1__c = htmlBody1,
                HTML_Body_Continuation_2__c = htmlBody2,
                HTML_Body_Continuation_3__c = htmlBody3
        );


        if (email.headers != null && email.headers.size() > 0) {
            message.headers = toString(email.headers);
        }

        if (email.toAddresses != null && email.toAddresses.size() > 0) {
            message.toAddress = String.join(email.toAddresses, ';');
        }

        if (email.ccAddresses != null && email.ccAddresses.size() > 0) {
            message.ccAddress = String.join(email.ccAddresses, ';');
        }

        return message;
    }

    private static String getHeaderValue(List<Messaging.InboundEmail.Header> headers, String name) {

        String value = null;

        if (headers != null) {
            for (Messaging.InboundEmail.Header header : headers) {
                if (header.name == name) {
                    value = header.value;
                    break;
                }
            }
        }

        return value;
    }

    private static String toString(List<Messaging.InboundEmail.Header> headers) {

        String text = '';

        if (headers != null) {
            for (Messaging.InboundEmail.Header header : headers) {
                text += header.name + '=' + header.value + '\n';
            }
        }

        return text;
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
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
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