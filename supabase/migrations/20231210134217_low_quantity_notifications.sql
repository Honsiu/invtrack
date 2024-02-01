ALTER TABLE "public"."product" ADD COLUMN "notification_threshold" numeric NOT NULL DEFAULT 0;

-- the WITH clause makes the view apply the underlying table's RLS policy
DROP VIEW IF EXISTS "public"."low_quantity_product_records_view";
CREATE OR REPLACE VIEW "public"."low_quantity_product_records_view" WITH (security_invoker) AS
SELECT "name",
    "notification_threshold",
    "quantity",
    "company_id",
    "inventory_id",
    "id" AS "product_record_id",
    "unit"
FROM (
    SELECT "product"."name",
        "product"."notification_threshold",
        "product"."unit",
        "product"."company_id",
        "product_record"."quantity",
        "product_record"."inventory_id",
        "product_record"."id",
        ROW_NUMBER() OVER (PARTITION BY "product_record"."product_id" ORDER BY "inventory"."date" DESC) AS row_num
    FROM "public"."product_record"
    LEFT JOIN "public"."product" ON "product_record"."product_id" = "product"."id"
    JOIN "public"."inventory" ON "product_record"."inventory_id" = "inventory"."id"
) AS ranked_records
WHERE row_num = 1
    AND "quantity" <= "notification_threshold";

