public class UHGHomePageController {

    public PageReference urlRedirection() {

          string url = 'http://uhg.my.salesforce.com/';
	      
          PageReference page = new PageReference(url);
          page.setRedirect(true);
          return page;
    }
}