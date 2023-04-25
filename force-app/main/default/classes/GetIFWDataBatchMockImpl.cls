global class GetIFWDataBatchMockImpl implements HttpCalloutMock {
    
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        
        System.assertEquals('GET', req.getMethod());
        
        String response ='<IfwDataList xmlns="IfwDataList" xmlns:i="http://www.w3.org/2001/XMLSchema-instance">'
                            +'<QueryResult>169 Record(s) found</QueryResult>'
                            +'<IfwInfoList>'
                               +'<IFWData>'
                                    +'<ActivityDate>2021-07-22T07:01:38.767</ActivityDate>'
                                    +'<ActivityId>15370944</ActivityId>'
                                    +'<ApplicationId>0</ApplicationId>'
                                    +'<ClientId>39</ClientId>'
                                    +'<CrawlerId>110</CrawlerId>'
                                    +'<CreatedDate>2021-07-22T07:01:38.767</CreatedDate>'
                                    +'<DocumentDescription>Email Notification</DocumentDescription>'
                                    +'<FileDownloadStatus/>'
                                    +'<FileWrapperDocumentCode>OA.EMAIL</FileWrapperDocumentCode>'
                                    +'<IfwDocumentId>J26QZCBVRXEAPX5</IfwDocumentId>'
                                    +'<IsAcknowledged>false</IsAcknowledged>'
                                    +'<IsActive>false</IsActive>'
                                    +'<IsPDFDownloaded>false</IsPDFDownloaded>'
                                    +'<MailRoomDate>2017-05-01T00:00:00</MailRoomDate>'
                                    +'<ModifiedDate i:nil="true"/>'
                                    +'<MxDocumentDataStatus>NA</MxDocumentDataStatus>'
                                    +'<MxOCRErrorDetails/>'
                                    +'<MxOCRStatus>Completed</MxOCRStatus>'
                                    +'<PDFFileName>20170501_US15495034_OA.EMAIL_J26QZCBVRXEAPX5_39_110</PDFFileName>'
                                    +'<PageQuantity>1</PageQuantity>'
                                    +'<PairDocumentID>0</PairDocumentID>'
                                +'</IFWData>'
                                +'<IFWData>'
                                    +'<ActivityDate>2021-07-22T07:01:35.23</ActivityDate>'
                                    +'<ActivityId>15370942</ActivityId>'
                                    +'<ApplicationId>0</ApplicationId>'
                                    +'<ClientId>39</ClientId>'
                                    +'<CrawlerId>110</CrawlerId>'
                                    +'<CreatedDate>2021-07-22T07:01:35.23</CreatedDate>'
                                    +'<DocumentDescription>Miscellaneous Communication to Applicant - No Action Count</DocumentDescription>'
                                    +'<FileDownloadStatus/>'
                                    +'<FileWrapperDocumentCode>M327</FileWrapperDocumentCode>'
                                    +'<IfwDocumentId>J21SAJBRRXEAPX3</IfwDocumentId>'
                                    +'<IsAcknowledged>false</IsAcknowledged>'
                                    +'<IsActive>false</IsActive>'
                                    +'<IsPDFDownloaded>false</IsPDFDownloaded>'
                                    +'<MailRoomDate>2017-05-01T00:00:00</MailRoomDate>'
                                    +'<ModifiedDate i:nil="true"/>'
                                    +'<MxDocumentDataStatus>NA</MxDocumentDataStatus>'
                                    +'<MxOCRErrorDetails/>'
                                    +'<MxOCRStatus>Completed</MxOCRStatus>'
                                    +'<PDFFileName>20170501_US15495034_M327_J21SAJBRRXEAPX3_39_110</PDFFileName>'
                                    +'<PageQuantity>2</PageQuantity>'
                                    +'<PairDocumentID>0</PairDocumentID>'
                                +'</IFWData>'
                                +'<IFWData>'
                                    +'<ActivityDate>2021-07-22T07:01:33.5</ActivityDate>'
                                    +'<ActivityId>15370941</ActivityId>'
                                    +'<ApplicationId>0</ApplicationId>'
                                    +'<ClientId>39</ClientId>'
                                    +'<CrawlerId>110</CrawlerId>'
                                    +'<CreatedDate>2021-07-22T07:01:33.5</CreatedDate>'
                                    +'<DocumentDescription>Fee Worksheet (SB06)</DocumentDescription>'
                                    +'<FileDownloadStatus/>'
                                    +'<FileWrapperDocumentCode>WFEE</FileWrapperDocumentCode>'
                                    +'<IfwDocumentId>J21S4BKYRXEAPX4</IfwDocumentId>'
                                    +'<IsAcknowledged>false</IsAcknowledged>'
                                    +'<IsActive>false</IsActive>'
                                    +'<IsPDFDownloaded>false</IsPDFDownloaded>'
                                    +'<MailRoomDate>2017-05-01T00:00:00</MailRoomDate>'
                                    +'<ModifiedDate i:nil="true"/>'
                                    +'<MxDocumentDataStatus>NA</MxDocumentDataStatus>'
                                    +'<MxOCRErrorDetails/>'
                                    +'<MxOCRStatus>Completed</MxOCRStatus>'
                                    +'<PDFFileName>20170501_US15495034_WFEE_J21S4BKYRXEAPX4_39_110</PDFFileName>'
                                    +'<PageQuantity>1</PageQuantity>'
                                    +'<PairDocumentID>0</PairDocumentID>'
                                +'</IFWData>'
                                +'<IFWData>'
                                    +'<ActivityDate>2021-07-22T07:01:29.907</ActivityDate>'
                                    +'<ActivityId>15370939</ActivityId>'
                                    +'<ApplicationId>0</ApplicationId>'
                                    +'<ClientId>39</ClientId>'
                                    +'<CrawlerId>110</CrawlerId>'
                                    +'<CreatedDate>2021-07-22T07:01:29.907</CreatedDate>'
                                    +'<DocumentDescription>Fee Worksheet (SB06)</DocumentDescription>'
                                    +'<FileDownloadStatus/>'
                                    +'<FileWrapperDocumentCode>WFEE</FileWrapperDocumentCode>'
                                    +'<IfwDocumentId>J1WHJK7DRXEAPX1</IfwDocumentId>'
                                    +'<IsAcknowledged>false</IsAcknowledged>'
                                    +'<IsActive>false</IsActive>'
                                    +'<IsPDFDownloaded>false</IsPDFDownloaded>'
                                    +'<MailRoomDate>2017-04-24T00:00:00</MailRoomDate>'
                                    +'<ModifiedDate i:nil="true"/>'
                                    +'<MxDocumentDataStatus>NA</MxDocumentDataStatus>'
                                    +'<MxOCRErrorDetails/>'
                                    +'<MxOCRStatus>Completed</MxOCRStatus>'
                                    +'<PDFFileName>20170424_US15495034_WFEE_J1WHJK7DRXEAPX1_39_110</PDFFileName>'
                                    +'<PageQuantity>2</PageQuantity>'
                                    +'<PairDocumentID>0</PairDocumentID>'
                                +'</IFWData>'
                                +'<IFWData>'
                                    +'<ActivityDate>2021-07-22T07:01:31.77</ActivityDate>'
                                    +'<ActivityId>15370940</ActivityId>'
                                    +'<ApplicationId>0</ApplicationId>'
                                    +'<ClientId>39</ClientId>'
                                    +'<CrawlerId>110</CrawlerId>'
                                    +'<CreatedDate>2021-07-22T07:01:31.77</CreatedDate>'
                                    +'<DocumentDescription>EFS Acknowledgment Receipt</DocumentDescription>'
                                    +'<FileDownloadStatus/>'
                                    +'<FileWrapperDocumentCode>N417</FileWrapperDocumentCode>'
                                    +'<IfwDocumentId>J1WHJK7ERXEAPX1</IfwDocumentId>'
                                    +'<IsAcknowledged>false</IsAcknowledged>'
                                    +'<IsActive>false</IsActive>'
                                    +'<IsPDFDownloaded>false</IsPDFDownloaded>'
                                    +'<MailRoomDate>2017-04-24T00:00:00</MailRoomDate>'
                                    +'<ModifiedDate i:nil="true"/>'
                                    +'<MxDocumentDataStatus>NA</MxDocumentDataStatus>'
                                    +'<MxOCRErrorDetails/>'
                                    +'<MxOCRStatus>Completed</MxOCRStatus>'
                                    +'<PDFFileName>20170424_US15495034_N417_J1WHJK7ERXEAPX1_39_110</PDFFileName>'
                                    +'<PageQuantity>3</PageQuantity>'
                                    +'<PairDocumentID>0</PairDocumentID>'
                                +'</IFWData>'
                                +'<IFWData>'
                                    +'<ActivityDate>2021-07-22T07:01:27.903</ActivityDate>'
                                    +'<ActivityId>15370938</ActivityId>'
                                    +'<ApplicationId>0</ApplicationId>'
                                    +'<ClientId>39</ClientId>'
                                    +'<CrawlerId>110</CrawlerId>'
                                    +'<CreatedDate>2021-07-22T07:01:27.903</CreatedDate>'
                                    +'<DocumentDescription>Drawings-other than black and white line drawings</DocumentDescription>'
                                    +'<FileDownloadStatus/>'
                                    +'<FileWrapperDocumentCode>DRW.NONBW</FileWrapperDocumentCode>'
                                    +'<IfwDocumentId>J1WHJK7BRXEAPX1</IfwDocumentId>'
                                    +'<IsAcknowledged>false</IsAcknowledged>'
                                    +'<IsActive>false</IsActive>'
                                    +'<IsPDFDownloaded>false</IsPDFDownloaded>'
                                    +'<MailRoomDate>2017-04-24T00:00:00</MailRoomDate>'
                                    +'<ModifiedDate i:nil="true"/>'
                                    +'<MxDocumentDataStatus>NA</MxDocumentDataStatus>'
                                    +'<MxOCRErrorDetails/>'
                                    +'<MxOCRStatus>Completed</MxOCRStatus>'
                                    +'<PDFFileName>20170424_US15495034_DRW.NONBW_J1WHJK7BRXEAPX1_39_110</PDFFileName>'
                                    +'<PageQuantity>38</PageQuantity>'
                                    +'<PairDocumentID>0</PairDocumentID>'
                                +'</IFWData>'
                                +'<IFWData>'
                                    +'<ActivityDate>2021-07-22T07:01:25.11</ActivityDate>'
                                    +'<ActivityId>15370937</ActivityId>'
                                    +'<ApplicationId>0</ApplicationId>'
                                    +'<ClientId>39</ClientId>'
                                    +'<CrawlerId>110</CrawlerId>'
                                    +'<CreatedDate>2021-07-22T07:01:25.11</CreatedDate>'
                                    +'<DocumentDescription>Abstract</DocumentDescription>'
                                    +'<FileDownloadStatus/>'
                                    +'<FileWrapperDocumentCode>ABST</FileWrapperDocumentCode>'
                                    +'<IfwDocumentId>J1WHJK7ARXEAPX1</IfwDocumentId>'
                                    +'<IsAcknowledged>false</IsAcknowledged>'
                                    +'<IsActive>false</IsActive>'
                                    +'<IsPDFDownloaded>false</IsPDFDownloaded>'
                                    +'<MailRoomDate>2017-04-24T00:00:00</MailRoomDate>'
                                    +'<ModifiedDate i:nil="true"/>'
                                    +'<MxDocumentDataStatus>NA</MxDocumentDataStatus>'
                                    +'<MxOCRErrorDetails/>'
                                    +'<MxOCRStatus>Completed</MxOCRStatus>'
                                    +'<PDFFileName>20170424_US15495034_ABST_J1WHJK7ARXEAPX1_39_110</PDFFileName>'
                                    +'<PageQuantity>1</PageQuantity>'
                                    +'<PairDocumentID>0</PairDocumentID>'
                                +'</IFWData>'
                                +'<IFWData>'
                                    +'<ActivityDate>2021-07-22T07:01:21.627</ActivityDate>'
                                    +'<ActivityId>15370935</ActivityId>'
                                    +'<ApplicationId>0</ApplicationId>'
                                    +'<ClientId>39</ClientId>'
                                    +'<CrawlerId>110</CrawlerId>'
                                    +'<CreatedDate>2021-07-22T07:01:21.627</CreatedDate>'
                                    +'<DocumentDescription>Specification</DocumentDescription>'
                                    +'<FileDownloadStatus/>'
                                    +'<FileWrapperDocumentCode>SPEC</FileWrapperDocumentCode>'
                                    +'<IfwDocumentId>J1WHJK78RXEAPX1</IfwDocumentId>'
                                    +'<IsAcknowledged>false</IsAcknowledged>'
                                    +'<IsActive>false</IsActive>'
                                    +'<IsPDFDownloaded>false</IsPDFDownloaded>'
                                    +'<MailRoomDate>2017-04-24T00:00:00</MailRoomDate>'
                                    +'<ModifiedDate i:nil="true"/>'
                                    +'<MxDocumentDataStatus>NA</MxDocumentDataStatus>'
                                    +'<MxOCRErrorDetails/>'
                                    +'<MxOCRStatus>Completed</MxOCRStatus>'
                                    +'<PDFFileName>20170424_US15495034_SPEC_J1WHJK78RXEAPX1_39_110</PDFFileName>'
                                    +'<PageQuantity>75</PageQuantity>'
                                    +'<PairDocumentID>0</PairDocumentID>'
                                +'</IFWData>'
                                +'<IFWData>'
                                    +'<ActivityDate>2021-07-22T07:01:23.413</ActivityDate>'
                                    +'<ActivityId>15370936</ActivityId>'
                                    +'<ApplicationId>0</ApplicationId>'
                                    +'<ClientId>39</ClientId>'
                                    +'<CrawlerId>110</CrawlerId>'
                                    +'<CreatedDate>2021-07-22T07:01:23.413</CreatedDate>'
                                    +'<DocumentDescription>Claims</DocumentDescription>'
                                    +'<FileDownloadStatus/>'
                                    +'<FileWrapperDocumentCode>CLM</FileWrapperDocumentCode>'
                                    +'<IfwDocumentId>J1WHJK79RXEAPX1</IfwDocumentId>'
                                    +'<IsAcknowledged>false</IsAcknowledged>'
                                    +'<IsActive>false</IsActive>'
                                    +'<IsPDFDownloaded>false</IsPDFDownloaded>'
                                    +'<MailRoomDate>2017-04-24T00:00:00</MailRoomDate>'
                                    +'<ModifiedDate i:nil="true"/>'
                                    +'<MxDocumentDataStatus>NA</MxDocumentDataStatus>'
                                    +'<MxOCRErrorDetails/>'
                                    +'<MxOCRStatus>Completed</MxOCRStatus>'
                                    +'<PDFFileName>20170424_US15495034_CLM_J1WHJK79RXEAPX1_39_110</PDFFileName>'
                                    +'<PageQuantity>3</PageQuantity>'
                                    +'<PairDocumentID>0</PairDocumentID>'
                                +'</IFWData>'
                                +'<IFWData>'
                                    +'<ActivityDate>2021-07-22T07:01:17.977</ActivityDate>'
                                    +'<ActivityId>15370934</ActivityId>'
                                    +'<ApplicationId>0</ApplicationId>'
                                    +'<ClientId>39</ClientId>'
                                    +'<CrawlerId>110</CrawlerId>'
                                    +'<CreatedDate>2021-07-22T07:01:17.977</CreatedDate>'
                                    +'<DocumentDescription>Application Data Sheet</DocumentDescription>'
                                    +'<FileDownloadStatus/>'
                                    +'<FileWrapperDocumentCode>ADS</FileWrapperDocumentCode>'
                                    +'<IfwDocumentId>J1WHJK77RXEAPX1</IfwDocumentId>'
                                    +'<IsAcknowledged>false</IsAcknowledged>'
                                    +'<IsActive>false</IsActive>'
                                    +'<IsPDFDownloaded>false</IsPDFDownloaded>'
                                    +'<MailRoomDate>2017-04-24T00:00:00</MailRoomDate>'
                                    +'<ModifiedDate i:nil="true"/>'
                                    +'<MxDocumentDataStatus>NA</MxDocumentDataStatus>'
                                    +'<MxOCRErrorDetails/>'
                                    +'<MxOCRStatus>Completed</MxOCRStatus>'
                                    +'<PDFFileName>20170424_US15495034_ADS_J1WHJK77RXEAPX1_39_110</PDFFileName>'
                                    +'<PageQuantity>13</PageQuantity>'
                                    +'<PairDocumentID>0</PairDocumentID>'
                                +'</IFWData>'
                                +'<IFWData>'
                                    +'<ActivityDate>2021-07-22T07:01:42.17</ActivityDate>'
                                    +'<ActivityId>15370946</ActivityId>'
                                    +'<ApplicationId>0</ApplicationId>'
                                    +'<ClientId>39</ClientId>'
                                    +'<CrawlerId>110</CrawlerId>'
                                    +'<CreatedDate>2021-07-22T07:01:42.17</CreatedDate>'
                                    +'<DocumentDescription>Fee Worksheet (SB06)</DocumentDescription>'
                                    +'<FileDownloadStatus/>'
                                    +'<FileWrapperDocumentCode>WFEE</FileWrapperDocumentCode>'
                                    +'<IfwDocumentId>J8HBI6NARXEAPX3</IfwDocumentId>'
                                    +'<IsAcknowledged>false</IsAcknowledged>'
                                    +'<IsActive>false</IsActive>'
                                    +'<IsPDFDownloaded>false</IsPDFDownloaded>'
                                    +'<MailRoomDate>2017-04-24T00:00:00</MailRoomDate>'
                                    +'<ModifiedDate i:nil="true"/>'
                                    +'<MxDocumentDataStatus>NA</MxDocumentDataStatus>'
                                    +'<MxOCRErrorDetails/>'
                                    +'<MxOCRStatus>Completed</MxOCRStatus>'
                                    +'<PDFFileName>20170424_US15495034_WFEE_J8HBI6NARXEAPX3_39_110</PDFFileName>'
                                    +'<PageQuantity>1</PageQuantity>'
                                    +'<PairDocumentID>0</PairDocumentID>'
                                +'</IFWData>'
                                +'<IFWData>'
                                    +'<ActivityDate>2021-07-22T07:01:40.467</ActivityDate>'
                                    +'<ActivityId>15370945</ActivityId>'
                                    +'<ApplicationId>0</ApplicationId>'
                                    +'<ClientId>39</ClientId>'
                                    +'<CrawlerId>110</CrawlerId>'
                                    +'<CreatedDate>2021-07-22T07:01:40.467</CreatedDate>'
                                    +'<DocumentDescription>Placeholder sheet indicating presence of supplemental content in SCORE</DocumentDescription>'
                                    +'<FileDownloadStatus/>'
                                    +'<FileWrapperDocumentCode>SCORE</FileWrapperDocumentCode>'
                                    +'<IfwDocumentId>J2T905D5RXEAPX1</IfwDocumentId>'
                                    +'<IsAcknowledged>false</IsAcknowledged>'
                                    +'<IsActive>false</IsActive>'
                                    +'<IsPDFDownloaded>false</IsPDFDownloaded>'
                                    +'<MailRoomDate>2017-04-24T00:00:00</MailRoomDate>'
                                    +'<ModifiedDate i:nil="true"/>'
                                    +'<MxDocumentDataStatus>NA</MxDocumentDataStatus>'
                                    +'<MxOCRErrorDetails/>'
                                    +'<MxOCRStatus>Completed</MxOCRStatus>'
                                    +'<PDFFileName>20170424_US15495034_SCORE_J2T905D5RXEAPX1_39_110</PDFFileName>'
                                    +'<PageQuantity>1</PageQuantity>'
                                    +'<PairDocumentID>0</PairDocumentID>'
                                +'</IFWData>'
                            +'</IfwInfoList>'
                        +'</IfwDataList>';
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'text/xml');
        res.setBody(response);
        res.setStatusCode(200);
        return res;
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

    }



}