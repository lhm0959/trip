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

-- 공유 코드 원문은 저장하지 않고 bcrypt 해시만 저장합니다.
insert into public.trip_access (trip_id, code_hash)
values ('europe-2026', '$2a$12$mVoCP5kGAyIsOpJHtDGfQekVViZr0TwvUt1hysEjyfmnZHBU10Scy')
on conflict (trip_id) do update
set code_hash = excluded.code_hash, updated_at = now();

alter table public.trip_checks enable row level security;
alter table public.trip_access enable row level security;

-- 이전 이메일 로그인 정책을 제거합니다.
drop policy if exists "trip members can read checks" on public.trip_checks;
drop policy if exists "trip members can insert checks" on public.trip_checks;
drop policy if exists "trip members can update checks" on public.trip_checks;

-- 테이블 직접 접근은 모두 막고, 아래 RPC만 공개합니다.
revoke all on public.trip_checks from anon, authenticated;
revoke all on public.trip_access from anon, authenticated;

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
