# Ahorcado

El juego del ahorcado en español, en vivo con amigos. A Spanish-learning Hangman game for phones, played live with friends.

## How to play

- **Crear sala** creates a room with a code like `TACO·42`. Share the code or the link.
- **Unirse con código** joins a friend's room.
- **Practicar solo** is single-player practice.

## Settings

- **Levels:** Fácil (8 tries), Medio (6) or Difícil (5).
- **What to guess:** single words, several words (expressions) or full sentences. Longer content gets 1–2 extra tries.
- **Modes:**
  - **Carrera:** everyone races on the same word.
  - **Por turnos:** one letter each, taking turns, 20 seconds per turn.
  - **Uno elige:** a rotating player writes the word and an English clue.

## Scoring

- **Letters:** 10 points for each correct letter, multiplied by how many times it appears in the word.
- **Solving:** 100 points for solving the word.
- **First to finish:** in Carrera and Uno elige, the first person to complete the word gets +50 and the round ends for everyone, moving on to the next word.
- **Uno elige:** the word setter gets +30 for each player who guesses their word.

## How it works

- **Files:** it's a static web app (`index.html` and `words.js`), hosted on GitHub Pages.
- **Live play:** it uses Supabase Realtime. Presence shows who is in the room, and broadcast carries game moves. No database tables are needed.
- **Host:** the player who has been in the room longest runs the game. If they leave, the next player takes over automatically.
- **Supabase key:** the key in `index.html` is Supabase's *publishable* key, which is meant to be public.

## Test mode

Add `?local` to the URL to play between browser tabs on one computer, with no network needed.

## Editing words

Edit `words.js`. Each entry is `[spanish, english clue, example ES, example EN]`; the examples are optional.
