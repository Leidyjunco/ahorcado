-- Ahorcado · database for the play-in-your-own-time modes (Reto, Duelo, Palabra del día)
-- Paste this whole file into Supabase → SQL Editor → New query, then click Run. Safe to run more than once.

-- Retos: a set of words everyone plays before a deadline
create table if not exists public.challenges (
  id           text primary key,
  created_at   timestamptz not null default now(),
  creator_id   text not null,
  creator_name text not null,
  creator_face int  not null default 0,
  settings     jsonb not null,
  items        jsonb not null,
  expires_at   timestamptz not null
);

create table if not exists public.results (
  id           bigint generated always as identity primary key,
  created_at   timestamptz not null default now(),
  challenge_id text not null references public.challenges(id) on delete cascade,
  player_id    text not null,
  player_name  text not null,
  face         int  not null default 0,
  score        int  not null,
  detail       jsonb,
  unique (challenge_id, player_id)
);

-- Duelos: two players set words for each other
create table if not exists public.duels (
  id         text primary key,
  created_at timestamptz not null default now(),
  a_id       text not null,
  a_name     text not null,
  a_face     int  not null default 0,
  b_id       text,
  b_name     text,
  b_face     int  not null default 0
);

create table if not exists public.duel_turns (
  id          bigint generated always as identity primary key,
  created_at  timestamptz not null default now(),
  duel_id     text not null references public.duels(id) on delete cascade,
  setter_id   text not null,
  setter_name text not null,
  es          text not null,
  en          text,
  solver_id   text,
  solver_name text,
  solved      boolean,
  miss        int,
  pts         int,
  answered_at timestamptz
);
create index if not exists duel_turns_duel_idx on public.duel_turns (duel_id);

-- Palabra del día: one result per player, per day, per group
create table if not exists public.daily_results (
  id          bigint generated always as identity primary key,
  created_at  timestamptz not null default now(),
  day         date not null,
  group_code  text not null,
  player_id   text not null,
  player_name text not null,
  face        int  not null default 0,
  score       int  not null,
  solved      boolean not null,
  miss        int  not null,
  unique (day, group_code, player_id)
);

-- Amigos: each phone's player gets a short friend code; a friendship is saved once and works both ways
create table if not exists public.players (
  id         text primary key,
  created_at timestamptz not null default now(),
  code       text not null unique,
  name       text not null,
  face       int  not null default 0
);

create table if not exists public.friends (
  id         bigint generated always as identity primary key,
  created_at timestamptz not null default now(),
  a_id       text not null,
  a_name     text not null,
  a_face     int  not null default 0,
  b_id       text not null,
  b_name     text not null,
  b_face     int  not null default 0,
  unique (a_id, b_id)
);

-- Finding a player's own games quickly
create index if not exists duels_a_idx        on public.duels (a_id);
create index if not exists duels_b_idx        on public.duels (b_id);
create index if not exists friends_a_idx      on public.friends (a_id);
create index if not exists friends_b_idx      on public.friends (b_id);
create index if not exists challenges_creator on public.challenges (creator_id);
create index if not exists results_player     on public.results (player_id);

-- Access rules: the app can read and add rows; a duel's second player can join once,
-- a duel turn can be answered once, and a player can change their name and face (never their code).
-- Nothing can be deleted from the app.
alter table public.challenges    enable row level security;
alter table public.results       enable row level security;
alter table public.duels         enable row level security;
alter table public.duel_turns    enable row level security;
alter table public.daily_results enable row level security;
alter table public.players       enable row level security;
alter table public.friends       enable row level security;

do $$
declare t text;
begin
  foreach t in array array['challenges','results','duels','duel_turns','daily_results','players','friends'] loop
    execute format('drop policy if exists "read" on public.%I', t);
    execute format('create policy "read" on public.%I for select to anon, authenticated using (true)', t);
    execute format('drop policy if exists "add" on public.%I', t);
    execute format('create policy "add" on public.%I for insert to anon, authenticated with check (true)', t);
  end loop;
end $$;

drop policy if exists "join once" on public.duels;
create policy "join once" on public.duels for update to anon, authenticated using (b_id is null) with check (true);

drop policy if exists "answer once" on public.duel_turns;
create policy "answer once" on public.duel_turns for update to anon, authenticated using (answered_at is null) with check (true);

drop policy if exists "rename" on public.players;
create policy "rename" on public.players for update to anon, authenticated using (true) with check (true);

grant select, insert on public.challenges, public.results, public.daily_results, public.players, public.friends to anon, authenticated;
grant select, insert, update on public.duels, public.duel_turns to anon, authenticated;
revoke update on public.players from anon, authenticated;
grant update (name, face) on public.players to anon, authenticated;
