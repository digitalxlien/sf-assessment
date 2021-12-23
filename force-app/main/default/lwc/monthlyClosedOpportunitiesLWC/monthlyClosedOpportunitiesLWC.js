import { LightningElement, api, track, } from 'lwc';
import getMonthlyClosedOpportunitiesLWCData from '@salesforce/apex/MonthlyClosedOpportunitiesController.getMonthlyClosedOpportunitiesLWCData';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class MonthlyClosedOpportunitiesLWC extends LightningElement {
    
    @api recordId;

    @track bodyCard = {
        visible : false
    };


    @track table = {
        columns: [
            {
                label: 'Nombre',
                fieldName: 'NameUrl',
                type: 'url',
                typeAttributes: {
                    label: { fieldName: 'Name' },
                    target: '_blank'
                }
            },
            { label: 'Cuenta', fieldName: 'AccountName' },
            { label: 'Monto', fieldName: 'Amount', type: 'currency' },
            { label: 'Fecha de cierre', fieldName: 'CloseDate' },
            { label: 'Etapa', fieldName: 'StageName' },
            { label: 'Tipo', fieldName: 'Type' }
        ],
        items: []
    }


    connectedCallback() {
        // Fetching data from lwc controller
        getMonthlyClosedOpportunitiesLWCData( { accountId: this.recordId } ).then( (response) => {
            
            if (response.state.success) {

                console.log( JSON.stringify(response) );

                this.data = response.data;
                this.table.items = this.data.opportunities;
                this.bodyCard.visible = true;
                for (let x = 0; x < this.table.items.length; x++) {
                    this.table.items[x].NameUrl = this.data.salesforceBaseUrl + '/' + this.table.items[x].Id;
                    this.table.items[x].AccountName = this.table.items[x].Account.Name;
                }

            } else {
                
                const evt = new ShowToastEvent({
                    title: 'An error ocurred while fetching the data.',
                    message: '',
                    variant: 'error',
                });
                this.dispatchEvent(evt);
            }

        }, this).catch((error) => {
            console.log(JSON.stringify(error));
            console.log('Error while trying to call the data method.');
            console.error(error);
        }, this);
    
    
    
    
    
    }


}
