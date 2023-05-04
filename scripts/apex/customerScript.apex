String namePrefix = 'Customer';
List<Account> accounts = new List<Account>();

// Create a list of accounts with each having last one for parent.
// First one has no parent.
String[] accountNames = new List<String>();
for (Integer customerOrdinal = 1; customerOrdinal <= 20; customerOrdinal++) {
    String name = namePrefix + ' ' + customerOrdinal;
    accountNames.add(name);
    accounts.add(new Account(Name=name));
}
insert accounts;

// When inserted accounts get ids from salesforce.
// For every customer, set the one created before it as its parent.
// First one has no parent.
List<Account> customers = [SELECT Id, Name FROM Account WHERE Name in :accountNames];
for(Integer customerOrdinal = 1; customerOrdinal < 20; customerOrdinal++) {
    customers[customerOrdinal].ParentId = customers[customerOrdinal-1].Id;
}
update customers;
