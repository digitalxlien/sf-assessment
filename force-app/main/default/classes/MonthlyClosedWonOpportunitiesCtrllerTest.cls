@isTest
public class MonthlyClosedWonOpportunitiesCtrllerTest {
    
    @TestSetup
    static void createTestData(){

        List<Account> accounts = new List<Account>();
        List<Contact> contacts = new List<Contact>();
        List<Opportunity> opps = new List<Opportunity>();
        accounts = TestFactory.accountsFactory(10);
        insert accounts;

        opps = TestFactory.opportunitiesFactory(accounts, 3);
        
        for (Opportunity opp : opps) {
            opp.CloseDate = Date.today();
            opp.StageName= 'Closed Won';
        }
        
        insert opps;
        
        contacts = TestFactory.contactsFactory(accounts, 2);
        
        insert contacts;
    }

    @isTest
    static void loadDataTest() {
        MonthlyClosedWonOpportunitiesController controller = new MonthlyClosedWonOpportunitiesController();
        System.assertEquals(controller.opportunities.size(), 10 * 3);
        System.assertEquals(controller.saveAsExcel(), null);
    }
}
