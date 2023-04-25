public with sharing class DocuSignDto {
    public class DocuSignEnvelope {
        public String emailSubject { set; get; }
        public String emailBlurb { set; get; }
        public List<DocuSignDocument> documents = new List<DocuSignDto.DocuSignDocument>();
        public DocuSignRecipients recipients = new DocuSignRecipients();
        public String status { set; get; }

        public override String toString() {
            return JSON.serialize(this);
        }
    }

    public class DocuSignDocument {
        public String documentId { set; get; }
        public String documentBase64 { set; get; }
        public String name { set; get; }
        public String fileExtension { set; get; }
        public String order { set; get; }

        // custom
        public String templateId { set; get; }
    }

    public class DocuSignRecipients {
        public List<DocuSignCarbonCopy> carbonCopies = new List<DocuSignCarbonCopy>();
        public List<DocuSignSigners> signers = new List<DocuSignSigners>();
    }

    public class DocuSignCarbonCopy {
        public String email { set; get; }
        public String name { set; get; }
        public String recipientId { set; get; }
        public String routingOrder { set; get; }
    }

    public class DocuSignSigners {
        public String email { set; get; }
        public String name { set; get; }
        public String recipientId { set; get; }
        public String routingOrder { set; get; }
        public DocuSignTab tabs = new DocuSignTab();
    }

    public class DocuSignTab {
        public List<DocuSignTabData> dateSignedTabs = new List<DocuSignTabData>();
        public List<DocuSignTabData> signHereTabs = new List<DocuSignTabData>();
    }

    public class DocuSignTabData {
        public String documentId { set; get; }
        public String font { set; get; }
        public String fontColor { set; get; }
        public String fontSize { set; get; }
        public String locked { set; get; }
        public String value { set; get; }
        public String anchorString { set; get; }
        public String anchorXOffset { set; get; }
        public String anchorYOffset { set; get; }
        public String anchorIgnoreIfNotPresent { set; get; }
        public String recipientId { set; get; }
        public String tabLabel { set; get; }
        public String anchorUnits { set; get; }
    }
}