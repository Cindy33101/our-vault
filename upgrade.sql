-- 升級用：在「小倉庫」的 Supabase 專案 SQL Editor 執行一次（不會刪除既有資料）
alter table messages add column if not exists file_path text, add column if not exists file_name text, add column if not exists file_size bigint;
alter table items add column if not exists pinned boolean not null default false, add column if not exists tags text[] not null default '{}';
create policy "items update" on items for update to authenticated using (true) with check (true);
create table if not exists reads (user_id uuid primary key default auth.uid(), last_read timestamptz not null default now());
alter table reads enable row level security;
create policy "reads select" on reads for select to authenticated using (true);
create policy "reads insert" on reads for insert to authenticated with check (user_id = auth.uid());
create policy "reads update" on reads for update to authenticated using (user_id = auth.uid()) with check (user_id = auth.uid());
alter publication supabase_realtime add table reads;
