/**
 * 取引先責任者トリガハンドラ
 */
public with sharing class ContactTriggerHandler {
    public ContactTriggerHandler() {

    }

    /**
     * 取引先責任者件数を取引先に積み上げ
     * @param  oldMap 旧レコードMap
     * @param  newMap 新レコードMap
     */
    public void updateRecordCount(Map<Id,Contact> oldMap,Map<Id,Contact> newMap){
        // 戻り値
        Set<Id> targetAccountIds = new Set<Id>();

        // 旧レコードが存在する場合（after update, after delete ,after undelete)
        if (oldMap != null){
            for(Contact oldRec:oldMap.values()){
                targetAccountIds.add(oldRec.AccountId);
            }
        }

        // 新レコードが存在する場合（after insert, after update, after undelete)
        if (newMap != null){
            for(Contact newRec:newMap.values()){
                targetAccountIds.add(newRec.AccountId);
            }
        }
        
        // 更新処理
        List<Account> updateAccounts = createUpdateAccounts(targetAccountIds);
        if (updateAccounts.size() > 0){
            update updateAccounts;
        }
    }

    /**
     * 参照する取引先に関連する取引先責任者の件数を積み上げる
     * @param  targetAccountIdSet 取引先IDのset
     */ 
    private List<Account> createUpdateAccounts (Set<Id> targetAccountIdSet){
        // 戻り値
        List<Account> updateAccounts = new List<Account>();
        // 取引先IDに一致する取引先と、紐づく取引先責任者の取得
        List<Account> targetAccounts = [SELECT Id,(SELECT Id FROM Contacts) FROM Account WHERE Id in :targetAccountIdSet];
        for(Account ac:targetAccounts) {
            // それぞれ取引先に関連するレコード件数を入力
            ac.ContactCount__c = ac.contacts.size();
            updateAccounts.add(ac);
        }
        return updateAccounts;

    }
}