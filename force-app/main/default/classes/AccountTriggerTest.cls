@isTest
public with sharing class AccountTriggerTest {
    
    public static Integer totalAccounts = 10;
    public static Integer totalOpps = 3;
    public static Integer totalContacts = 2;
    public static Integer totalCreditCards = 1;

    @TestSetup
    static void createTestData(){
    
        List<Account> accounts = new List<Account>();
        List<Contact> contacts = new List<Contact>();
        List<Opportunity> opps = new List<Opportunity>();
        List<CreditCard__c> creditCards = new List<CreditCard__c>();

        accounts = TestFactory.accountsFactory(totalAccounts);
        insert accounts;
        
        opps = TestFactory.opportunitiesFactory(accounts, totalOpps);
        insert opps;

        contacts = TestFactory.contactsFactory(accounts, totalContacts);
        insert contacts;

        creditCards = TestFactory.creditCardsFactory(contacts, totalCreditCards);
        insert creditCards;
    
    }




    @isTest 
    static void uptadeAccountTest() {
        
        Test.setMock(HttpCalloutMock.class, new validateCreditCardSuccessCalloutMock());


        List<Account> accounts = new List<Account>();
        Set<Id> accountsIds = new Set<Id>();
        List<Contact> contacts = new List<Contact>();
        List<Contact> premiumContacts = new List<Contact>();
        List<CreditCard__c> creditCards = new List<CreditCard__c>();
        List<Opportunity> initialOpps = new List<Opportunity>();
        List<Opportunity> afectedOpps = new List<Opportunity>();

        List<Case> cases = new List<Case>();
        
        
        accounts = [SELECT Id, ActiveBoolean__c FROM Account];
        premiumContacts = [SELECT Id From Contact WHERE ProgramType__c = 'Premium'];
        
        for (account acc : accounts) {
            acc.ActiveBoolean__c = false;
            accountsIds.add(acc.id);
        }

        
        initialOpps = [SELECT Id, StageName FROM Opportunity WHERE AccountId In : accountsIds AND (StageName != 'Closed Won' OR StageName != 'Closed Lost') ];


        Test.startTest();
        update accounts;
        Test.stopTest();

        accounts = [SELECT Id FROM Account WHERE ActiveBoolean__c = true];
        contacts = [SELECT Id, ProgramType__c FROM Contact WHERE AccountId In : accountsIds];
        afectedOpps = [SELECT Id, StageName FROM Opportunity WHERE AccountId In : accountsIds AND (StageName = 'Closed Lost') ];
        creditCards = [SELECT Id, Active__c FROM CreditCard__c ];
        cases = [SELECT Id FROm Case ];

        System.assert( accounts.isEmpty() );

        for(CreditCard__c cd : creditCards ){
            System.assertEquals(false, cd.Active__c);
        }

        for(Contact con : contacts ){
            System.assertEquals('Canceled', con.ProgramType__c);
        }

        
        // System.assertEquals( afectedOpps.size(), initialOpps.size() );
        
        // System.assertEquals(expected, actual)

        System.assertEquals( cases.size(), premiumContacts.size() );
       
        System.assertEquals( creditCards.size(), (AccountTriggerTest.totalAccounts * AccountTriggerTest.totalContacts) * AccountTriggerTest.totalCreditCards  );
    
    }
        






}
