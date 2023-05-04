public with sharing class ListAccountParents {
    // Get list of all ancestors for given account.
    // If there are none, return empty list.
    @AuraEnabled(cacheable=true)
    public static List<Account> listParents(String accountId) {
        try {
            List<Account> account = [SELECT Id, Name, ParentId 
                FROM Account 
                WHERE Id=:accountId
                WITH SECURITY_ENFORCED];

            // Return empty list if there is no account by given id.
            if (account.size() == 0) {
                return new List<Account>();
            }

            // Although is generally avoided, sql is used in a loop.
            // This is because the general solution is recursive.
            List<Account> parents = new List<Account>();
            Id parentId = account[0].ParentId;
            while(parentId != null) {
                // Get parent account.
                account = [SELECT Id, Name, ParentId 
                FROM Account 
                WHERE Id=:parentId
                WITH SECURITY_ENFORCED];

                // Return if there is no parent account.
                if (account.size() == 0) {
                    break;
                }

                // Add parent to return list.
                parents.add(account[0]);

                // Get parent Id of current parent for next iteration.
                parentId = account[0].ParentId;
            }

            return parents;
        
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}