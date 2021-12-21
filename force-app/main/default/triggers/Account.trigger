trigger Account on Account (before insert, before update) {


    Set<Id> accountsIds = new Set<Id>();
    Set<Id> contactIds = new Set<Id>();

    List<Contact> contacts = new List<Contact>();
    List<CreditCard__c> creditCards = new List<CreditCard__c>();
    List<Opportunity> opps = new List<Opportunity>();
    List<Case> cases = new List<Case>();
    
    // Logica para registros en tiempo beforeUpdate
    if( Trigger.isUpdate && Trigger.isBefore ) {

        // Obtencion de cuentas cuyos campos hayan cambiado sus valores en el campo ActiveBoolean__c
        for( Id accountId : Trigger.oldMap.keySet() ) { 

            if ( Trigger.oldMap.get( accountId ).ActiveBoolean__c && ! Trigger.newMap.get( accountId ).ActiveBoolean__c ) {
                accountsIds.add( accountId );
            }
        }


        
        if( ! accountsIds.isEmpty() ){
        
            // Tratamiento de contactos asociados a las cuentas afectadas
            contacts = [SELECT Id, ProgramType__c FROM Contact WHERE accountId IN : accountsIds ];

            for(Contact contact : contacts) {
                
                contactIds.add( contact.Id );
                
                // to-do Creacion de cases si los contactos afectados son premium


                
                contact.ProgramType__c = 'Canceled';

                


            }

            if( ! contacts.isEmpty() ){

                update contacts;

                // Procesamiento de tarjetas de credito asociadas a los contactos afectados
                creditCards = [SELECT Id, Active__c FROM CreditCard__c Where Contact__c IN : contactIds];

                if( ! creditCards.isEmpty() ){
                    for( CreditCard__c cd : creditCards ){
                        cd.Active__c = false;
                    }
                    update creditCards;
                }

            }



            // Tratamiento de oportunidades asociadas a las cuentas afectadas
            opps = [SELECT id, Description, StageName FROM Opportunity WHERE AccountId in : accountsIds AND (StageName != 'Closed Won' OR StageName != 'Closed Lost') ];

            for(Opportunity op : opps){
                op.StageName = 'Closed Lost';
                op.Description = 'Cerrada por Cuenta Inactiva';
            }

            if( ! opps.isEmpty() ){
                update opps;
            }




        }













    }




}