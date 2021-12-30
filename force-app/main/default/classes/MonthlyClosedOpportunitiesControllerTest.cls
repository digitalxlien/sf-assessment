@isTest
public class MonthlyClosedOpportunitiesControllerTest {

    @TestSetup
    static void createTestData(){
        List<Account> accounts = new List<Account>();
        List<Opportunity> opps = new List<Opportunity>();
        accounts = TestFactory.accountsFactory(1);
        insert accounts;
        opps = TestFactory.opportunitiesFactory(accounts, 10);

        for (Integer x = 0; x < opps.size(); x++) {
            opps[x].CloseDate = Date.today();
            opps[x].StageName = System.Math.mod(x, 2) == 0 ? 'Closed Won': 'Closed Lost' ;
        }
        insert opps;
    }

    @isTest
    static void getDataSuccessTest() {
        Account accountTest = [SELECT Id from Account Limit 1];
        MonthlyClosedOpportunitiesController.JsonResponse response = new MonthlyClosedOpportunitiesController.JsonResponse();
        response = MonthlyClosedOpportunitiesController.getMonthlyClosedOpportunitiesLWCData(accountTest.id);
        System.assert(response.state.success);
        System.assertEquals(response.data.opportunities.size(), 10);
    }
}