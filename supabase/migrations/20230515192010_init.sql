CREATE INDEX refresh_token_session_id ON auth.refresh_tokens USING btree (session_id);

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION auth.email()
 RETURNS text
 LANGUAGE sql
 STABLE
AS $function$
  select 
  	coalesce(
		nullif(current_setting('request.jwt.claim.email', true), ''),
		(nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'email')
	)::text
$function$
;

CREATE OR REPLACE FUNCTION auth.role()
 RETURNS text
 LANGUAGE sql
 STABLE
AS $function$
  select 
  	coalesce(
		nullif(current_setting('request.jwt.claim.role', true), ''),
		(nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'role')
	)::text
$function$
;

CREATE OR REPLACE FUNCTION auth.uid()
 RETURNS uuid
 LANGUAGE sql
 STABLE
AS $function$
  select 
  	coalesce(
		nullif(current_setting('request.jwt.claim.sub', true), ''),
		(nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'sub')
	)::uuid
$function$
;

CREATE OR REPLACE FUNCTION public.user_id()
 RETURNS character varying
 LANGUAGE sql
 STABLE
AS $function$
  select
  nullif(
    coalesce(
      current_setting('request.jwt.claim.sub', true),
      (current_setting('request.jwt.claims', true)::jsonb ->> 'sub')
    ),
    ''
  )::varchar
$function$
;

create table "public"."activities" (
    "id" bigint generated by default as identity not null,
    "created_at" timestamp with time zone default now(),
    "hash" character varying,
    "type" character varying not null,
    "status" character varying not null,
    "timestamp" bigint,
    "metadata" jsonb,
    "user_id" character varying not null default user_id(),
    "chain_id" smallint not null
);


alter table "public"."activities" enable row level security;

create table "public"."categories" (
    "id" bigint generated by default as identity not null,
    "created_at" timestamp with time zone default now(),
    "name" character varying,
    "deposit" boolean not null default true,
    "withdrawal" boolean not null default true,
    "active" boolean not null default true,
    "description" text,
    "pool_id" uuid not null,
    "user_id" character varying
);


alter table "public"."categories" enable row level security;

create table "public"."invitations" (
    "id" uuid not null default uuid_generate_v4(),
    "created_at" timestamp with time zone default now(),
    "role" character varying not null default 'member'::character varying,
    "active" boolean not null default true,
    "status" character varying not null default 'pending'::character varying,
    "name" character varying not null,
    "email" character varying not null,
    "pool_name" character varying not null,
    "invited_by" character varying not null,
    "pool_id" uuid not null,
    "user_id" character varying not null default user_id()
);


alter table "public"."invitations" enable row level security;

create table "public"."members" (
    "role" character varying not null,
    "created_at" timestamp with time zone default now(),
    "is_owner" boolean not null default false,
    "active" boolean not null default true,
    "last_viewed_at" timestamp with time zone default now(),
    "pool_id" uuid not null,
    "user_id" character varying not null,
    "inactive_reason" character varying
);


alter table "public"."members" enable row level security;

create table "public"."pools" (
    "created_at" timestamp with time zone default now(),
    "name" character varying not null,
    "description" text,
    "chain_id" integer not null,
    "active" boolean not null default true,
    "gnosis_safe_address" character varying,
    "id" uuid not null default uuid_generate_v4(),
    "user_id" character varying not null default user_id(),
    "token_contract_address" character varying
);


alter table "public"."pools" enable row level security;

create table "public"."transactions" (
    "id" bigint generated by default as identity not null,
    "created_at" timestamp with time zone default now(),
    "memo" text,
    "hash" character varying,
    "type" character varying not null,
    "status" character varying not null,
    "timestamp" bigint,
    "category_id" bigint,
    "metadata" jsonb,
    "safe_tx_hash" character varying,
    "reject_safe_tx_hash" character varying,
    "safe_nonce" bigint,
    "pool_id" uuid not null,
    "user_id" character varying not null default user_id(),
    "transaction_data" jsonb,
    "threshold" integer not null default 0,
    "confirmations" integer not null default 1,
    "rejections" integer not null default 0
);


alter table "public"."transactions" enable row level security;

create table "public"."users" (
    "id" character varying not null,
    "created_at" timestamp with time zone default now(),
    "email" character varying not null,
    "name" character varying,
    "wallet" character varying not null,
    "last_pool_id" uuid,
    "username" character varying
);


alter table "public"."users" enable row level security;

CREATE UNIQUE INDEX activities_hash_key ON public.activities USING btree (hash);

CREATE UNIQUE INDEX activities_pkey ON public.activities USING btree (id);

CREATE UNIQUE INDEX categories_pkey ON public.categories USING btree (id);

CREATE UNIQUE INDEX invitations_pkey ON public.invitations USING btree (id);

CREATE UNIQUE INDEX members_pkey ON public.members USING btree (pool_id, user_id);

CREATE UNIQUE INDEX pools_pkey ON public.pools USING btree (id);

CREATE UNIQUE INDEX transactions_pkey ON public.transactions USING btree (id);

CREATE UNIQUE INDEX "transactions_safeTxHash_key" ON public.transactions USING btree (safe_tx_hash);

CREATE UNIQUE INDEX unique_safe_nonce ON public.transactions USING btree (pool_id, safe_nonce);

CREATE UNIQUE INDEX unique_transaction_hash ON public.transactions USING btree (hash);

CREATE UNIQUE INDEX unique_username ON public.users USING btree (username);

CREATE UNIQUE INDEX users_pkey ON public.users USING btree (id);

alter table "public"."activities" add constraint "activities_pkey" PRIMARY KEY using index "activities_pkey";

alter table "public"."categories" add constraint "categories_pkey" PRIMARY KEY using index "categories_pkey";

alter table "public"."invitations" add constraint "invitations_pkey" PRIMARY KEY using index "invitations_pkey";

alter table "public"."members" add constraint "members_pkey" PRIMARY KEY using index "members_pkey";

alter table "public"."pools" add constraint "pools_pkey" PRIMARY KEY using index "pools_pkey";

alter table "public"."transactions" add constraint "transactions_pkey" PRIMARY KEY using index "transactions_pkey";

alter table "public"."users" add constraint "users_pkey" PRIMARY KEY using index "users_pkey";

alter table "public"."activities" add constraint "activities_hash_key" UNIQUE using index "activities_hash_key";

alter table "public"."activities" add constraint "activities_user_id_fkey" FOREIGN KEY (user_id) REFERENCES users(id) not valid;

alter table "public"."activities" validate constraint "activities_user_id_fkey";

alter table "public"."categories" add constraint "categories_pool_id_fkey" FOREIGN KEY (pool_id) REFERENCES pools(id) not valid;

alter table "public"."categories" validate constraint "categories_pool_id_fkey";

alter table "public"."categories" add constraint "categories_user_id_fkey" FOREIGN KEY (user_id) REFERENCES users(id) not valid;

alter table "public"."categories" validate constraint "categories_user_id_fkey";

alter table "public"."invitations" add constraint "invitations_pool_id_fkey" FOREIGN KEY (pool_id) REFERENCES pools(id) not valid;

alter table "public"."invitations" validate constraint "invitations_pool_id_fkey";

alter table "public"."invitations" add constraint "invitations_user_id_fkey" FOREIGN KEY (user_id) REFERENCES users(id) not valid;

alter table "public"."invitations" validate constraint "invitations_user_id_fkey";

alter table "public"."members" add constraint "members_pool_id_fkey" FOREIGN KEY (pool_id) REFERENCES pools(id) not valid;

alter table "public"."members" validate constraint "members_pool_id_fkey";

alter table "public"."members" add constraint "members_user_id_fkey" FOREIGN KEY (user_id) REFERENCES users(id) not valid;

alter table "public"."members" validate constraint "members_user_id_fkey";

alter table "public"."pools" add constraint "pools_user_id_fkey" FOREIGN KEY (user_id) REFERENCES users(id) not valid;

alter table "public"."pools" validate constraint "pools_user_id_fkey";

alter table "public"."transactions" add constraint "transactions_category_id_fkey" FOREIGN KEY (category_id) REFERENCES categories(id) not valid;

alter table "public"."transactions" validate constraint "transactions_category_id_fkey";

alter table "public"."transactions" add constraint "transactions_pool_id_fkey" FOREIGN KEY (pool_id) REFERENCES pools(id) not valid;

alter table "public"."transactions" validate constraint "transactions_pool_id_fkey";

alter table "public"."transactions" add constraint "transactions_safeTxHash_key" UNIQUE using index "transactions_safeTxHash_key";

alter table "public"."transactions" add constraint "transactions_user_id_fkey" FOREIGN KEY (user_id) REFERENCES users(id) not valid;

alter table "public"."transactions" validate constraint "transactions_user_id_fkey";

alter table "public"."transactions" add constraint "unique_safe_nonce" UNIQUE using index "unique_safe_nonce";

alter table "public"."transactions" add constraint "unique_transaction_hash" UNIQUE using index "unique_transaction_hash";

alter table "public"."users" add constraint "unique_username" UNIQUE using index "unique_username";

alter table "public"."users" add constraint "users_last_pool_id_fkey" FOREIGN KEY (last_pool_id) REFERENCES pools(id) not valid;

alter table "public"."users" validate constraint "users_last_pool_id_fkey";

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.accept_invitation(invitation_id uuid)
 RETURNS void
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$

declare 
  poolId uuid;
begin

  IF EXISTS (select 1 from invitations where id = invitation_id and active = true) THEN

    poolId := (SELECT i.pool_id from invitations i where i.id = invitation_id);

    insert into members
    (user_id, pool_id, "role", is_owner )
    values
    (user_id(), poolId, 'member', false );

    update invitations set active=false, status='accepted' where id = invitation_id;

  ELSE
   RAISE EXCEPTION 'Invalid invitation'; 
  END IF;  

end;

$function$
;

CREATE OR REPLACE FUNCTION public.check_username(username character varying)
 RETURNS boolean
 LANGUAGE sql
 SECURITY DEFINER
AS $function$  
with u as (
  select id
  from  users
  where username = check_username.username
)
SELECT EXISTS (SELECT FROM u);
$function$
;

CREATE OR REPLACE FUNCTION public.create_pool(chain_id integer, name character varying, description text, token_contract_address character varying)
 RETURNS uuid
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$

declare 
  pool_id uuid;
begin
  insert into pools(chain_id, name, description, token_contract_address)
  values (create_pool.chain_id, create_pool.name, create_pool.description, create_pool.token_contract_address)
  returning id into pool_id;

  insert into members
  (user_id, pool_id, "role", is_owner )
  values
  (user_id(), pool_id, 'admin', true );

  -- update users
  update users set last_pool_id=pool_id where id = user_id();

  -- Create default categories
  insert into categories
  (name, pool_id )
  values
  ('Contribution', pool_id), 
  ('Withdrawal', pool_id), 
  ('Payments & Interests', pool_id),  
  ('Penalties and Fees', pool_id) ,
  ('Loan', pool_id);

  return pool_id;
end;

$function$
;

CREATE OR REPLACE FUNCTION public.create_pool(chain_id integer, name character varying, description text, token_id integer)
 RETURNS uuid
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$

declare 
  pool_id uuid;
begin
  insert into pools(chain_id, name, description, token_id)
  values (create_pool.chain_id, create_pool.name, create_pool.description, create_pool.token_id)
  returning id into pool_id;

  insert into members
  (user_id, pool_id, "role", is_owner )
  values
  (user_id(), pool_id, 'admin', true );

  -- update users
  update users set last_pool_id=pool_id where id = user_id();

  -- Create default categories
  insert into categories
  (name, pool_id )
  values
  ('Contribution', pool_id), 
  ('Withdrawal', pool_id), 
  ('Payments & Interests', pool_id),  
  ('Penalties and Fees', pool_id) ,
  ('Loan', pool_id);

  return pool_id;
end;

$function$
;

CREATE OR REPLACE FUNCTION public.get_co_members_for_authenticated_user()
 RETURNS SETOF character varying
 LANGUAGE sql
 STABLE SECURITY DEFINER
AS $function$
    select u.id from users u
    join members m on m.user_id = u.id
    where m.pool_id in( SELECT get_pools_for_authenticated_user() AS my_pools)
$function$
;

CREATE OR REPLACE FUNCTION public.get_invitation(invitation_id uuid)
 RETURNS SETOF invitations
 LANGUAGE sql
 SECURITY DEFINER
AS $function$  
  select *
  from  invitations
  where id = get_invitation.invitation_id
  
$function$
;

CREATE OR REPLACE FUNCTION public.get_my_pools()
 RETURNS SETOF record
 LANGUAGE sql
AS $function$  
  select sub.* from (
    select  p.*, json_agg(jsonb_build_object('username', u.username)) as members
    from pools p 
    join members m on m.pool_id = p.id
    join users u on u.id = m.user_id 
    where p.active = true 
    group by p.id
  ) sub
  join members m on m.pool_id=sub.id and m.user_id=user_id() 
  where m.active = true
  order by m.last_viewed_at desc  
$function$
;

CREATE OR REPLACE FUNCTION public.get_pools_for_authenticated_user()
 RETURNS SETOF uuid
 LANGUAGE sql
 STABLE SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
    select pool_id
    from members
    where user_id = user_id()
$function$
;

CREATE OR REPLACE FUNCTION public.get_pools_where_authenticated_user_is_admin()
 RETURNS SETOF uuid
 LANGUAGE sql
 STABLE SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
    select pool_id
    from members
    where user_id = user_id() and role = 'admin'
$function$
;

CREATE OR REPLACE FUNCTION public.get_total_per_category(pool_id uuid)
 RETURNS TABLE(name character varying, deposit double precision, withdrawal double precision)
 LANGUAGE plpgsql
AS $function$
begin
  return query
    select c.name ,
        SUM (CASE
            WHEN t.type = 'deposit'  THEN (metadata->'amount')::float
            ELSE 0
        END) AS deposit,
        SUM (CASE
            WHEN t.type = 'withdrawal'  THEN (metadata->'amount')::float
            ELSE 0
        END) AS withdrawal
    from transactions t
     join categories c on t.category_id=c.id
    where t.pool_id = get_total_per_category.pool_id and t.status='completed'
    group by category_id, c.name;

end;

$function$
;

CREATE OR REPLACE FUNCTION public.get_transactions_per_month(pool_id uuid)
 RETURNS TABLE(month date, deposit double precision, withdrawal double precision)
 LANGUAGE plpgsql
AS $function$
begin
  return query
    select date_trunc('month',created_at)::date as "month" ,
        SUM (CASE
            WHEN type = 'deposit'  THEN (metadata->'amount')::float
            ELSE 0
        END) AS deposit,
        SUM (CASE
            WHEN type = 'withdrawal'  THEN (metadata->'amount')::float
            ELSE 0
        END) AS withdrawal
    from transactions t
    where t.pool_id = get_transactions_per_month.pool_id and t.status='completed'
    group by date_trunc('month',created_at)::date
    order by date_trunc('month',created_at)::date;

end;

$function$
;

CREATE OR REPLACE FUNCTION public.get_transactions_stats(pool_id uuid)
 RETURNS TABLE(count bigint, deposit double precision, withdrawal double precision)
 LANGUAGE plpgsql
AS $function$
begin
  return query
    select count(*) ,
        SUM (CASE
            WHEN type = 'deposit'  THEN (metadata->'amount')::float
            ELSE 0
        END) AS deposit,
        SUM (CASE
            WHEN type = 'withdrawal'  THEN (metadata->'amount')::float
            ELSE 0
        END) AS withdrawal
    from transactions t
    where t.pool_id = get_transactions_stats.pool_id and t.status='completed';

end;

$function$
;

CREATE OR REPLACE FUNCTION public.get_user_activities()
 RETURNS SETOF record
 LANGUAGE sql
AS $function$  
  select * from 
  (select id, type, hash, status, timestamp, metadata, user_id, null as "pool_id", null as "name", chain_id  from activities
  union all
  select t.id, t.type, t.hash, t.status, t.timestamp, t.metadata, t.user_id, t.pool_id, p.name, p.chain_id from transactions t
  join pools p on p.id=t.pool_id
  where t.type='deposit'
  ) a
$function$
;

CREATE OR REPLACE FUNCTION public.get_user_activities(chain_id integer)
 RETURNS TABLE(id bigint, type character varying, hash character varying, status character varying, metadata jsonb, pool_id uuid, pool_name character varying, "timestamp" bigint, created_at character varying)
 LANGUAGE sql
AS $function$  
  select id , type , hash , status , metadata, pool_id, pool_name, timestamp, created_at  from 
  (select id, type, hash, status, timestamp, metadata, user_id, null as "pool_id", null as "pool_name", chain_id, created_at  from activities
  union all
  select t.id, 'transfer_out' as type, t.hash, t.status, t.timestamp, t.metadata, t.user_id, t.pool_id, p.name as "pool_name", p.chain_id, t.created_at from transactions t
  join pools p on p.id=t.pool_id
  where t.type='deposit'
  ) a
  where user_id=user_id() and chain_id=get_user_activities.chain_id
  order by created_at desc
$function$
;

CREATE OR REPLACE FUNCTION public.handle_new_notification()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE 
    member RECORD;
BEGIN
  IF NEW is NULL THEN RAISE EXCEPTION 'entry is null';
  end IF;
  for member in (select * from public.members where pool_id = NEW.pool_id and active = true and user_id != new.user_id) loop
    insert into public.notification_users (recipient_id, notification_id)
    values (member.user_id, NEW.id);
  end loop;
  return NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.join_pool(invitation_id uuid)
 RETURNS bigint
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$

begin

  IF EXISTS (select 1 from invitations where id = invitation_id and active = true) THEN

    insert into members
    (user_id, pool_id, "role", is_owner )
    values
    (user_id(), pool_id, 'member', false );

    update invitations set active=false, status='accepted' where id = invitation_id;

  END IF;  

end;

$function$
;

CREATE OR REPLACE FUNCTION public.report_users_stake(pool_id uuid)
 RETURNS TABLE(id character varying, username character varying, wallet character varying, total_deposit double precision, stake double precision)
 LANGUAGE plpgsql
AS $function$
begin
  return query
      WITH deposit_per_user AS (      
          select user_id as id, u.username,u.wallet,
          SUM (CASE
                WHEN t.type = 'deposit'  THEN (metadata->'amount')::float
                WHEN t.type = 'withdrawal'  THEN -(metadata->'amount')::float
                ELSE 0
            END) AS Balance
        from transactions t 
        join users u on t.user_id=u.id 
        where t.pool_id= report_users_stake.pool_id
        group by user_id, u.username, u.wallet
      ),

      total_deposits  as (
          SELECT SUM(balance) AS total_deposit
          FROM deposit_per_user
        )

      SELECT 
        deposit_per_user.id,
        deposit_per_user.username, 
        deposit_per_user.wallet,
        deposit_per_user.balance as total_deposit,
        (balance / total_deposits .total_deposit) * 100 AS stake
      FROM  
        deposit_per_user, total_deposits ;

end;

$function$
;


create policy "Enable insert for authenticated users only"
on "public"."activities"
as permissive
for insert
to public
with check (((user_id())::text = (user_id)::text));


create policy "Enable select for users based on user_id"
on "public"."activities"
as permissive
for select
to public
using (((user_id())::text = (user_id)::text));


create policy "Enable update for users based on user_id"
on "public"."activities"
as permissive
for update
to public
using (((user_id())::text = (user_id)::text))
with check (((user_id())::text = (user_id)::text));


create policy "Can Read is member"
on "public"."categories"
as permissive
for select
to public
using ((pool_id IN ( SELECT get_pools_for_authenticated_user() AS my_pools)));


create policy "Can insert if admin"
on "public"."categories"
as permissive
for insert
to public
with check ((pool_id IN ( SELECT get_pools_where_authenticated_user_is_admin() AS my_pools)));


create policy "Can update if admin"
on "public"."categories"
as permissive
for update
to public
using ((pool_id IN ( SELECT get_pools_for_authenticated_user() AS my_pools)))
with check ((pool_id IN ( SELECT get_pools_where_authenticated_user_is_admin() AS my_pools_admin)));


create policy "Can Read is member"
on "public"."invitations"
as permissive
for select
to public
using ((pool_id IN ( SELECT get_pools_for_authenticated_user() AS my_pools)));


create policy "Can insert if admin"
on "public"."invitations"
as permissive
for insert
to public
with check ((pool_id IN ( SELECT get_pools_where_authenticated_user_is_admin() AS my_pools)));


create policy "Enable update for users based on email"
on "public"."invitations"
as permissive
for update
to public
using ((auth.email() = (email)::text))
with check ((auth.email() = (email)::text));


create policy "Enable view for users based on email"
on "public"."invitations"
as permissive
for select
to public
using ((auth.email() = (email)::text));


create policy " can update members if they belong to the pool"
on "public"."members"
as permissive
for all
to public
using ((pool_id IN ( SELECT get_pools_for_authenticated_user() AS get_pools_for_authenticated_user)));


create policy "Can Read if member"
on "public"."pools"
as permissive
for select
to public
using (((user_id())::text IN ( SELECT members.user_id
   FROM members
  WHERE (members.pool_id = pools.id))));


create policy "Can read if owner"
on "public"."pools"
as permissive
for select
to public
using (((user_id())::text = (user_id)::text));


create policy "Can update if members"
on "public"."pools"
as permissive
for update
to public
using (((user_id())::text IN ( SELECT members.user_id
   FROM members
  WHERE (members.pool_id = pools.id))))
with check (((user_id())::text IN ( SELECT members.user_id
   FROM members
  WHERE (members.pool_id = pools.id))));


create policy "Enable insert for authenticated users only"
on "public"."pools"
as permissive
for insert
to authenticated
with check (true);


create policy "Only members can insert"
on "public"."transactions"
as permissive
for insert
to public
with check ((pool_id IN ( SELECT get_pools_for_authenticated_user() AS my_pools)));


create policy "Only members can update -  temp"
on "public"."transactions"
as permissive
for update
to public
using ((pool_id IN ( SELECT get_pools_for_authenticated_user() AS my_pools)))
with check ((pool_id IN ( SELECT get_pools_for_authenticated_user() AS my_pools)));


create policy "Only members can view"
on "public"."transactions"
as permissive
for select
to public
using ((pool_id IN ( SELECT get_pools_for_authenticated_user() AS my_pools)));


create policy "Can insert own data"
on "public"."users"
as permissive
for insert
to public
with check (((user_id())::text = (id)::text));


create policy "Can update own"
on "public"."users"
as permissive
for update
to public
using (((user_id())::text = (id)::text))
with check (((user_id())::text = (id)::text));


create policy "Can view own data"
on "public"."users"
as permissive
for select
to public
using (((user_id())::text = (id)::text));


create policy "Co-members can view"
on "public"."users"
as permissive
for select
to public
using (((id)::text IN ( SELECT get_co_members_for_authenticated_user() AS get_co_members_for_authenticated_user)));



drop trigger if exists "update_objects_updated_at" on "storage"."objects";

drop function if exists "storage"."can_insert_object"(bucketid text, name text, owner uuid, metadata jsonb);

drop function if exists "storage"."update_updated_at_column"();

alter table "storage"."buckets" drop column "allowed_mime_types";

alter table "storage"."buckets" drop column "avif_autodetection";

alter table "storage"."buckets" drop column "file_size_limit";

alter table "storage"."objects" drop column "version";


