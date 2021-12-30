
@isTest
global class validateCreditCardSuccessCalloutMock implements HttpCalloutMock {
    
    global HTTPResponse respond(HTTPRequest request) {
      
        // Response
        List<CreditCardWebservice.ValidatedCreditCard> validatedCreditCards = new List<CreditCardWebservice.ValidatedCreditCard>() ;
        CreditCardWebservice.ValidatedCreditCard vcc;
      

        for(integer x = 0; x < (AccountTriggerTest.totalAccounts * AccountTriggerTest.totalContacts) * AccountTriggerTest.totalCreditCards ; x++){
            vcc = new CreditCardWebservice.ValidatedCreditCard();
            vcc.creditCardNumber = String.valueOf(x).leftPad( 16  ,'0');
            vcc.validated = true ;
            validatedCreditCards.add(vcc);
        }

        System.debug('http response : ' + JSON.serialize(validatedCreditCards ) );

        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setStatusCode(201);
        response.setBody( JSON.serialize(validatedCreditCards ));

        return response;
    }
}






