-- 동유럽 여행 공유 코드 공동 편집용 Supabase 설정
-- Supabase Dashboard > SQL Editor에서 전체를 다시 실행하세요.

create extension if not exists pgcrypto with schema extensions;

create table if not exists public.trip_checks (
  trip_id text not null,
  check_id text not null,
  checked boolean not null default false,
  updated_by text not null,
  updated_at timestamptz not null default now(),
  primary key (trip_id, check_id)
);

create table if not exists public.trip_access (
  trip_id text primary key,
  code_hash text not null,
  updated_at timestamptz not null default now()
);

create table if not exists public.trip_expenses (
  trip_id text not null,
  expense_id text not null,
  category text not null,
  amount numeric not null check (amount > 0),
  currency text not null check (currency in ('KRW','EUR','HUF','CZK')),
  payment_method text not null default 'card' check (payment_method in ('card','cash')),
  memo text not null default '',
  spent_on date not null default current_date,
  updated_by text not null default 'shared-device',
  updated_at timestamptz not null default now(),
  primary key (trip_id, expense_id)
);

alter table public.trip_expenses add column if not exists payment_method text not null default 'card';

create table if not exists public.trip_notes (
  trip_id text not null,
  note_id text not null,
  content text not null default '',
  updated_by text not null default 'shared-device',
  updated_at timestamptz not null default now(),
  primary key (trip_id, note_id)
);

-- 공유 코드 원문은 저장하지 않고 bcrypt 해시만 저장합니다.
insert into public.trip_access (trip_id, code_hash)
values ('europe-2026', '$2a$12$mVoCP5kGAyIsOpJHtDGfQekVViZr0TwvUt1hysEjyfmnZHBU10Scy')
on conflict (trip_id) do update
set code_hash = excluded.code_hash, updated_at = now();

alter table public.trip_checks enable row level security;
alter table public.trip_access enable row level security;
alter table public.trip_expenses enable row level security;
alter table public.trip_notes enable row level security;

-- 이전 이메일 로그인 정책을 제거합니다.
drop policy if exists "trip members can read checks" on public.trip_checks;
drop policy if exists "trip members can insert checks" on public.trip_checks;
drop policy if exists "trip members can update checks" on public.trip_checks;

-- 테이블 직접 접근은 모두 막고, 아래 RPC만 공개합니다.
revoke all on public.trip_checks from anon, authenticated;
revoke all on public.trip_access from anon, authenticated;
revoke all on public.trip_expenses from anon, authenticated;
revoke all on public.trip_notes from anon, authenticated;

create or replace function public.get_trip_checks(p_trip_id text, p_code text)
returns table (check_id text, checked boolean)
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_hash text;
begin
  select a.code_hash into v_hash
  from public.trip_access as a
  where a.trip_id = p_trip_id;

  if v_hash is null or extensions.crypt(p_code, v_hash) <> v_hash then
    raise exception using errcode = '28000', message = 'invalid access code';
  end if;

  return query
  select c.check_id, c.checked
  from public.trip_checks as c
  where c.trip_id = p_trip_id
  order by c.check_id;
end;
$$;

create or replace function public.set_trip_check(
  p_trip_id text,
  p_check_id text,
  p_checked boolean,
  p_code text,
  p_device text default 'shared-device'
)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_hash text;
begin
  select a.code_hash into v_hash
  from public.trip_access as a
  where a.trip_id = p_trip_id;

  if v_hash is null or extensions.crypt(p_code, v_hash) <> v_hash then
    raise exception using errcode = '28000', message = 'invalid access code';
  end if;

  insert into public.trip_checks (trip_id, check_id, checked, updated_by, updated_at)
  values (p_trip_id, p_check_id, p_checked, left(p_device, 120), now())
  on conflict (trip_id, check_id) do update
  set checked = excluded.checked,
      updated_by = excluded.updated_by,
      updated_at = now();
end;
$$;

revoke all on function public.get_trip_checks(text, text) from public;
revoke all on function public.set_trip_check(text, text, boolean, text, text) from public;
grant execute on function public.get_trip_checks(text, text) to anon, authenticated;
grant execute on function public.set_trip_check(text, text, boolean, text, text) to anon, authenticated;

drop function if exists public.get_trip_expenses(text,text);
create or replace function public.get_trip_expenses(p_trip_id text, p_code text)
returns table (
  expense_id text, category text, amount numeric, currency text,
  payment_method text, memo text, spent_on date, updated_at timestamptz
)
language plpgsql
security definer
set search_path = ''
as $$
declare v_hash text;
begin
  select a.code_hash into v_hash from public.trip_access as a where a.trip_id = p_trip_id;
  if v_hash is null or extensions.crypt(p_code, v_hash) <> v_hash then
    raise exception using errcode = '28000', message = 'invalid access code';
  end if;
  return query
  select e.expense_id,e.category,e.amount,e.currency,e.payment_method,e.memo,e.spent_on,e.updated_at
  from public.trip_expenses as e where e.trip_id=p_trip_id
  order by e.spent_on desc,e.updated_at desc;
end;
$$;

drop function if exists public.save_trip_expense(text,text,text,numeric,text,text,date,text,text);
create or replace function public.save_trip_expense(
  p_trip_id text, p_expense_id text, p_category text, p_amount numeric,
  p_currency text, p_payment_method text, p_memo text, p_spent_on date, p_code text,
  p_device text default 'shared-device'
)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare v_hash text;
begin
  select a.code_hash into v_hash from public.trip_access as a where a.trip_id = p_trip_id;
  if v_hash is null or extensions.crypt(p_code, v_hash) <> v_hash then
    raise exception using errcode = '28000', message = 'invalid access code';
  end if;
  insert into public.trip_expenses
    (trip_id,expense_id,category,amount,currency,payment_method,memo,spent_on,updated_by,updated_at)
  values
    (p_trip_id,left(p_expense_id,120),left(p_category,200),p_amount,p_currency,p_payment_method,left(coalesce(p_memo,''),500),
     p_spent_on,left(p_device,120),now())
  on conflict (trip_id,expense_id) do update
  set category=excluded.category,amount=excluded.amount,currency=excluded.currency,payment_method=excluded.payment_method,
      memo=excluded.memo,spent_on=excluded.spent_on,updated_by=excluded.updated_by,updated_at=now();
end;
$$;

create or replace function public.delete_trip_expense(p_trip_id text,p_expense_id text,p_code text)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare v_hash text;
begin
  select a.code_hash into v_hash from public.trip_access as a where a.trip_id = p_trip_id;
  if v_hash is null or extensions.crypt(p_code, v_hash) <> v_hash then
    raise exception using errcode = '28000', message = 'invalid access code';
  end if;
  delete from public.trip_expenses as e where e.trip_id=p_trip_id and e.expense_id=p_expense_id;
end;
$$;

revoke all on function public.get_trip_expenses(text,text) from public;
revoke all on function public.save_trip_expense(text,text,text,numeric,text,text,text,date,text,text) from public;
revoke all on function public.delete_trip_expense(text,text,text) from public;
grant execute on function public.get_trip_expenses(text,text) to anon, authenticated;
grant execute on function public.save_trip_expense(text,text,text,numeric,text,text,text,date,text,text) to anon, authenticated;
grant execute on function public.delete_trip_expense(text,text,text) to anon, authenticated;

create or replace function public.get_trip_notes(p_trip_id text,p_code text)
returns table (note_id text,content text,updated_at timestamptz)
language plpgsql security definer set search_path=''
as $$
declare v_hash text;
begin
  select a.code_hash into v_hash from public.trip_access as a where a.trip_id=p_trip_id;
  if v_hash is null or extensions.crypt(p_code,v_hash)<>v_hash then
    raise exception using errcode='28000',message='invalid access code';
  end if;
  return query select n.note_id,n.content,n.updated_at from public.trip_notes as n where n.trip_id=p_trip_id;
end;
$$;

create or replace function public.save_trip_note(
  p_trip_id text,p_note_id text,p_content text,p_code text,p_device text default 'shared-device'
)
returns void language plpgsql security definer set search_path=''
as $$
declare v_hash text;
begin
  select a.code_hash into v_hash from public.trip_access as a where a.trip_id=p_trip_id;
  if v_hash is null or extensions.crypt(p_code,v_hash)<>v_hash then
    raise exception using errcode='28000',message='invalid access code';
  end if;
  insert into public.trip_notes(trip_id,note_id,content,updated_by,updated_at)
  values(p_trip_id,left(p_note_id,160),left(coalesce(p_content,''),2000),left(p_device,120),now())
  on conflict(trip_id,note_id) do update
  set content=excluded.content,updated_by=excluded.updated_by,updated_at=now();
end;
$$;

create or replace function public.delete_trip_note(p_trip_id text,p_note_id text,p_code text)
returns void language plpgsql security definer set search_path=''
as $$
declare v_hash text;
begin
  select a.code_hash into v_hash from public.trip_access as a where a.trip_id=p_trip_id;
  if v_hash is null or extensions.crypt(p_code,v_hash)<>v_hash then
    raise exception using errcode='28000',message='invalid access code';
  end if;
  delete from public.trip_notes as n where n.trip_id=p_trip_id and n.note_id=p_note_id;
end;
$$;

revoke all on function public.get_trip_notes(text,text) from public;
revoke all on function public.save_trip_note(text,text,text,text,text) from public;
revoke all on function public.delete_trip_note(text,text,text) from public;
grant execute on function public.get_trip_notes(text,text) to anon,authenticated;
grant execute on function public.save_trip_note(text,text,text,text,text) to anon,authenticated;
grant execute on function public.delete_trip_note(text,text,text) to anon,authenticated;
