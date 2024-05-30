create table "public"."name_alias" (
    "id" bigint generated by default as identity not null,
    "alias" text not null,
    "recipe_id" int,
    "product_id" int,
    "company_id" bigint not null
);

alter table "public"."name_alias" enable row level security;

CREATE UNIQUE INDEX name_alias_recipe_id_product_id_alias_key ON public.name_alias USING btree (recipe_id, product_id, alias);
CREATE UNIQUE INDEX name_alias_id_key ON public.name_alias USING btree (id);

alter table "public"."name_alias" add constraint public_name_alias_company_id_fkey foreign key (company_id) references company (id) on update cascade on delete cascade;

alter table "public"."name_alias" add constraint name_alias_recipe_id_fkey foreign key (recipe_id) references recipe (id) on update cascade on delete cascade;
alter table "public"."name_alias" add constraint name_alias_product_id_fkey foreign key (product_id) references product (id) on update cascade on delete cascade;

alter table "public"."name_alias" add constraint chk_product_id_recipe_id check (
      (recipe_id is null and product_id is not null) or
      (recipe_id is not null and product_id is null)
      );
alter table "public"."name_alias" add constraint name_alias_alias_check check ((length(alias) < 100));


create policy "Admin can do anything within company"
on "public"."name_alias"
as permissive
for all
to authenticated
using ((( SELECT worker_for_current_user.is_admin
   FROM worker_for_current_user) AND ( SELECT (worker_for_current_user.company_id = name_alias.company_id)
   FROM worker_for_current_user)));

CREATE POLICY "Non-admin can select on name_alias, within company"
ON "public"."name_alias"
AS PERMISSIVE
FOR SELECT
TO authenticated
USING (
  (SELECT (worker_for_current_user.company_id = name_alias.company_id)
   FROM worker_for_current_user)
);

CREATE POLICY "Non-admin can insert on name_alias, within company"
ON "public"."name_alias"
AS PERMISSIVE
FOR INSERT
TO authenticated
WITH CHECK (
  (SELECT (worker_for_current_user.company_id = name_alias.company_id)
   FROM worker_for_current_user)
);

CREATE POLICY "Non-admin can update on name_alias, within company"
ON "public"."name_alias"
AS PERMISSIVE
FOR UPDATE
TO authenticated
USING (
  (SELECT (worker_for_current_user.company_id = name_alias.company_id)
   FROM worker_for_current_user)
);

GRANT ALL PRIVILEGES ON TABLE "public"."name_alias" TO "authenticated";
GRANT ALL PRIVILEGES ON TABLE "public"."name_alias" TO "service_role";

INSERT INTO "public"."name_alias" (alias, product_id, company_id)
SELECT alias, product_id, company_id FROM "public"."product_name_alias";

drop table "public"."product_name_alias";