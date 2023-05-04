import { LightningElement, api, track, wire } from 'lwc';
import getParents from '@salesforce/apex/ListAccountParents.listParents';

import Name from '@salesforce/schema/Account.Name';
import Id from '@salesforce/schema/Account.Id';

export default class CustomerParents extends LightningElement {
    @api recordId
    @api records;
    @api error;

    FIELDS = [Name, Id];

    @wire(getParents, { accountId: '$recordId'})
    wiredAccountParents({ error, data }) {
        // console.log('getParents called');
        // console.log('error' + error);
        console.log('MYDEBUG record:'+ this.recordId);
        if(data) {
            console.log('MYDEBUG data:' + data);
            this.records = data.map((acc) => {
                return { name:acc.Name, id:acc.Id };
            })

            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.records = undefined;
            console.log('MYDEBUG error:' + JSON.stringify(error));
        }
    }
}