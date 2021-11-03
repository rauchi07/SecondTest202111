/**
 * 取引先責任者トリガ
 * @param  insert   insert description
 * @param  update   update description
 * @param  delete   delete description
 * @param  undelete undelete description
 * @return          return description
 */
trigger ContactTrigger on Contact (after insert,after update,after delete,after undelete) {
	System.TriggerOperation triggerEvent = Trigger.operationType;

    // 取引先責任者トリガハンドラ
	ContactTriggerHandler handler = new ContactTriggerHandler();
	switch on triggerEvent {
		when AFTER_INSERT {
            // 取引先責任者件数を取引先に積み上げる処理
            handler.updateRecordCount(Trigger.oldMap,Trigger.newMap);

        }when AFTER_UPDATE {
            // 取引先責任者件数を取引先に積み上げる処理
            handler.updateRecordCount(Trigger.oldMap, Trigger.newMap);

        }when AFTER_DELETE {
            // 取引先責任者件数を取引先に積み上げる処理
            handler.updateRecordCount(Trigger.oldMap, Trigger.newMap);

        }when AFTER_UNDELETE {
            // 取引先責任者件数を取引先に積み上げる処理
            handler.updateRecordCount(Trigger.oldMap, Trigger.newMap);

		}
	}


}