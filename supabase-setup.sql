-- 동유럽 여행 공동 편집용 Supabase 초기 설정
-- Supabase Dashboard > SQL Editor > New query 에서 한 번 실행하세요.

create table if not exists public.trip_checks (
  trip_id text not null,
  check_id text not null,
  checked boolean not null default false,
  updated_by text not null,
  updated_at timestamptz not null default now(),
  primary key (trip_id, check_id)
);

alter table public.trip_checks enable row level security;

drop policy if exists "trip members can read checks" on public.trip_checks;
create policy "trip members can read checks"
on public.trip_checks for select
to authenticated
using (
  lower(auth.jwt() ->> 'email') in (
    'devjjinny@gmail.com',
    'lhm0959@gmail.com'
  )
  and trip_id = 'europe-2026'
);

drop policy if exists "trip members can insert checks" on public.trip_checks;
create policy "trip members can insert checks"
on public.trip_checks for insert
to authenticated
with check (
  lower(auth.jwt() ->> 'email') in (
    'devjjinny@gmail.com',
    'lhm0959@gmail.com'
  )
  and lower(updated_by) = lower(auth.jwt() ->> 'email')
  and trip_id = 'europe-2026'
);

drop policy if exists "trip members can update checks" on public.trip_checks;
create policy "trip members can update checks"
on public.trip_checks for update
to authenticated
using (
  lower(auth.jwt() ->> 'email') in (
    'devjjinny@gmail.com',
    'lhm0959@gmail.com'
  )
  and trip_id = 'europe-2026'
)
with check (
  lower(updated_by) = lower(auth.jwt() ->> 'email')
  and trip_id = 'europe-2026'
);

create or replace function public.set_trip_check_updated_at()
returns trigger
language plpgsql
security invoker
set search_path = ''
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists set_trip_check_updated_at on public.trip_checks;
create trigger set_trip_check_updated_at
before update on public.trip_checks
for each row execute function public.set_trip_check_updated_at();

-- 실시간 공동 편집 이벤트를 활성화합니다.
do $$
begin
  if not exists (
    select 1
    from pg_publication_tables
    where pubname = 'supabase_realtime'
      and schemaname = 'public'
      and tablename = 'trip_checks'
  ) then
    alter publication supabase_realtime add table public.trip_checks;
  end if;
end
$$;

grant select, insert, update on public.trip_checks to authenticated;
