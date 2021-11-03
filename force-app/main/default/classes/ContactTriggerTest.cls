/**
 * ContactTriggerテストクラス
 */
@isTest
public with sharing class ContactTriggerTest {

    @TestSetup
    /**
     * テストデータ作成
     */
    static void makeData(){
        Account account1 = new Account(
            Name = 'account1'
        );
        Account account2 = new Account(
            Name = 'account2'
        );      
        insert new List<Account>{account1,account2};

        Contact contact1 = new Contact(
            LastName = 'contact1'
            ,AccountId = account2.Id
        );
        insert contact1;
    }

    /**
     * 取引先取得用
     * @param  accountName accountName description
     * @return             return description
     */
    static Account getAccountByName(String accountName){
        return [
            SELECT
                Id
                ,Name
                ,ContactCount__c
                ,(SELECT Id,AccountId FROM Contacts)
            FROM
                Account
            WHERE
                Name = :accountName
        ];
    }

    /**
     * Insert時のテスト
     */
    @isTest
    static void Case001(){
        Account account1 = getAccountByName('account1');

        Contact contact1 = new Contact(
            LastName = 'countact1'
            ,AccountId = account1.Id
        );

        Test.startTest();
            insert contact1;

        Test.stopTest();

        // 期待値：account1:1
        Account resultAccount1 = getAccountByName('account1');
        System.assertEquals(1, resultAccount1.ContactCount__c);
    }

    /**
     * update時のテスト（別の取引先への付け替え）
     */
    @isTest
    static void Case002(){
        Account account1 = getAccountByName('account1');
        Account account2 = getAccountByName('account2');

        System.assertEquals(0, account1.ContactCount__c);
        System.assertEquals(1, account2.ContactCount__c);

        // 取引先責任者のAccountIdをaccount2→account2に付け替える
        Contact updateContact = account2.contacts[0];
        updateContact.AccountId = account1.Id;

        Test.startTest();
            update updateContact;

        Test.stopTest();

        // 期待値：account1:1、account2:0
        Account resultAccount1 = getAccountByName('account1');
        Account resultAccount2 = getAccountByName('account2');
        System.assertEquals(1, resultAccount1.ContactCount__c);
        System.assertEquals(0, resultAccount2.ContactCount__c);
    }

    /**
     * delete時のテスト
     */
    @isTest
    static void Case003(){
        Account account2 = getAccountByName('account2');
        System.assertEquals(1, account2.ContactCount__c);

        // 取引先責任者のAccountIdをaccount2→account2に付け替える
        Contact updateContact = account2.contacts[0];

        Test.startTest();
            delete updateContact;

        Test.stopTest();

        // 期待値：account2:0
        Account resultAccount2 = getAccountByName('account2');
        System.assertEquals(0, resultAccount2.ContactCount__c);
    }

    /**
     * undelete時のテスト（ゴミ箱からの復元）
     */
    @isTest
    static void Case004(){
        Account account2 = getAccountByName('account2');
        System.assertEquals(1, account2.ContactCount__c);

        // 取引先責任者を一旦削除
        Contact updateContact = account2.contacts[0];
        delete updateContact;

        Contact undeleteContact = [
            SELECT
                Id
                ,AccountId
            FROM
                Contact
            WHERE
                LastName = 'contact1'
            ALL ROWS
        ];

        Test.startTest();
            undelete undeleteContact;

        Test.stopTest();

        // 期待値：account2:1
        Account resultAccount2 = getAccountByName('account2');
        System.assertEquals(1, resultAccount2.ContactCount__c);
    }

    /**
     * 201件テスト
     */
    @isTest
    static void Case005(){
        Account account1 = getAccountByName('account1');
        System.assertEquals(0, account1.ContactCount__c);

        List<Contact> contacts = new List<Contact>();
        for(Integer i=0; i < 201; i++){
            contacts.add(new Contact(
                LastName = 'bulk' + String.valueOf(i+1)
                ,AccountId = account1.Id
            ));
        }

        Test.startTest();
            insert contacts;

        Test.stopTest();

        // 期待値：account1:201
        Account resultAccount1 = getAccountByName('account1');
        System.assertEquals(201, resultAccount1.ContactCount__c);
    }
}