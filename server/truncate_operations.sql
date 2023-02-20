SET session_replication_role = replica;

TRUNCATE TABLE receipt_orderline CASCADE;
TRUNCATE TABLE receipt_receiptpayment CASCADE;
TRUNCATE TABLE receipt_order CASCADE;
TRUNCATE TABLE receipt_receipt CASCADE;
TRUNCATE TABLE warehouse_purchase CASCADE;
TRUNCATE TABLE warehouse_purchaseline CASCADE;
TRUNCATE TABLE warehouse_consumption CASCADE;

SET session_replication_role = DEFAULT;