public class MonthlyClosedOpportunitiesController {
    
    @AuraEnabled
    public static JsonResponse getMonthlyClosedOpportunitiesLWCData(Id accountId){
        
        JsonResponse response = new JsonResponse();
        
        try {
            response.data.opportunities = [SELECT Id,
                                                Name,
                                                Account.Name,
                                                Amount,
                                                CloseDate,
                                                StageName,
                                                Type FROM Opportunity where accountId = :accountId and (StageName = 'Closed Won' or StageName = 'Closed Lost')];
            response.state.success = true;
        } catch (Exception ex) {
            response.state.success = false;
            response.state.errorMessages.add( ex.getMessage() );
        }
    
        return response;
    }


    public class JsonResponse {

        @AuraEnabled public State state;
        @AuraEnabled public Data data;
        
        public JsonResponse() {
            this.state = new State();
            this.data = new Data();
        }

    }

    public class Data {

        @AuraEnabled public List<Opportunity> opportunities;
        @AuraEnabled public String salesforceBaseUrl;
        
        public Data() {
            this.opportunities = new List<Opportunity>();
            this.salesforceBaseUrl = URL.getSalesforceBaseUrl().toExternalForm();
        }
    }

    public class State {
        @AuraEnabled public Boolean success;
        @AuraEnabled public List<String> errorMessages;
        
        public State(){
            this.success = false;
            this.errorMessages = new List<String>();
        }
    }
}
        