SET client_encoding TO 'UTF8';
SET session_replication_role = replica;

/* Чеки */
TRUNCATE TABLE receipt_orderline CASCADE;
TRUNCATE TABLE receipt_receiptpayment CASCADE;
TRUNCATE TABLE receipt_order CASCADE;
TRUNCATE TABLE receipt_receipt CASCADE;

/* Платежи */
TRUNCATE TABLE finance_accountpayment CASCADE;

/* Смены */
TRUNCATE TABLE system_shift CASCADE;

/* Склад */
TRUNCATE TABLE warehouse_purchase CASCADE;
TRUNCATE TABLE warehouse_purchaseline CASCADE;
TRUNCATE TABLE warehouse_return CASCADE;
TRUNCATE TABLE warehouse_returnline CASCADE;
TRUNCATE TABLE warehouse_entry CASCADE;
TRUNCATE TABLE warehouse_entryline CASCADE;
TRUNCATE TABLE warehouse_writeoff CASCADE;
TRUNCATE TABLE warehouse_writeoffline CASCADE;
TRUNCATE TABLE warehouse_consumption CASCADE;
TRUNCATE TABLE warehouse_production CASCADE;
TRUNCATE TABLE warehouse_ingredientcostchange CASCADE;

/* Монитор очереди */
TRUNCATE TABLE receipt_qmonitororder CASCADE;

/* Сообщения телеграм */
TRUNCATE TABLE system_tgmessage CASCADE;

SET session_replication_role = DEFAULT;