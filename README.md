# Ahorcado

El juego del ahorcado en español, para jugar con amigos, en vivo o cada uno a su ritmo. A Spanish-learning Hangman game for phones.

## Ways to play

- **En vivo:** a fast live room. Everyone plays at the same time with a room code like `TACO·42`.
- **Reto:** the same 3, 5 or 10 words for everyone, played whenever you like before a deadline (24 hours, 3 days or 1 week), with a shared leaderboard.
- **Duelo:** two players set Spanish words, each with an English clue, for each other, taking turns at their own pace.
- **Palabra del día:** one word a day, the same for your whole group. You get one try, and there's a group leaderboard and a streak.
- **Practicar solo:** single-player practice.
- **Amigos:** each player has a friend code like `SOL·4821`. Add someone once, by code or with their `?amigo=` link, and after that duels you set for them and retos you create show up on their home screen, with no links. Anyone you've had a duel with becomes a friend automatically.

**Tus partidas** on the home screen lists your duels and retos, plus your friends' retos. Anything waiting for you moves to the top. Tap **Editar** to clear it: ending a duel closes it for both players, and removing a reto only hides it from your own list. Each duel also has **Terminar duelo** at the bottom.

**Unirse con código** accepts any live room, reto, duelo, group or friend code. Links work too: `?sala=`, `?reto=`, `?duelo=`, `?grupo=`, `?amigo=`.

## Install it on your phone

- **iPhone:** open the site in Safari, tap **Share** (on newer iOS, tap **···** first), then **Add to Home Screen**.
- **Android:** tap **Instala la app** on the home screen, or use Chrome's **Install app**.

After that, Ahorcado opens full screen from its own icon and loads even without signal; Practicar solo works offline.

On iPhone, Safari and the home-screen app keep separate saved data. So when an invite link opens in Safari, the game first offers to install, and shows the code to type into the app under **Unirse con código**. That box also accepts a pasted invite link.

## Live room settings

- **Levels:** Fácil (8 tries), Medio (6) or Difícil (5).
- **What to guess:** single words, several words (expressions) or full sentences. Longer content gets 1–2 extra tries.
- **Modes:**
  - **Carrera:** everyone races on the same word.
  - **Por turnos:** one letter each, taking turns, 20 seconds per turn.
  - **Uno elige:** a rotating player writes the word and an English clue.

## Scoring

Live rooms:
- **Letters:** 10 points for each correct letter, multiplied by how many times it appears in the word.
- **Solving:** 100 points for solving the word.
- **First to finish:** in Carrera and Uno elige, the first person to complete the word gets +50 and the round ends for everyone, moving on to the next word.
- **Uno elige:** the word setter gets +30 for each player who guesses their word.

Reto, Duelo and Palabra del día:
- **Letters:** 10 points for each correct letter, multiplied by how many times it appears in the word.
- **Solving:** 100 points.
- **Accuracy:** +10 for each try you have left.
- **Speed:** a bonus of up to +50, which drops the longer you take.

## Setup (once)

The play-in-your-own-time modes save results in Supabase. Open Supabase → **SQL Editor** → **New query**, paste all of `setup.sql`, and click **Run**. Live rooms don't need this.

## How it works

- **Files:** it's a static web app (`index.html` and `words.js`), hosted on GitHub Pages.
- **Live play:** it uses Supabase Realtime. Presence shows who is in the room, and broadcast carries game moves.
- **Host:** in a live room, the player who has been in the room longest runs the game. If they leave, the next player takes over automatically.
- **Saved games:** retos, duelos, daily results, players and friendships are kept in seven tables (see `setup.sql`). Each phone gets a saved player ID, so nobody needs an account.
- **Supabase key:** the key in `index.html` is Supabase's *publishable* key, which is meant to be public. The tables let the app read and add rows but not delete them.

## Test mode

Add `?local` to the URL to play between browser tabs on one computer, with no network needed. Add `&pid=x` to act as a different player.

## Editing words

Edit `words.js`. Each entry is `[spanish, english clue, example ES, example EN]`; the examples are optional.
