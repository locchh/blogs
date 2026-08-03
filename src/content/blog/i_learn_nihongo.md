---
title: "I learn Nihongo!"
description: "Some thoughts about Nihongo"
pubDate: "2026-08-03"
author: "locchh"
tags: ["languages", "ai", "llm"]
draft: false
---

## Overview

### Fundamentals

Before comparing scripts I had to get the vocabulary straight, because I kept
using "letter," "character," and "symbol" as if they meant the same thing. They
don't.

#### First, what language is made of

A script has to encode *something*. Before you can say what, you need the three
units — each one is the smallest piece of something different:

| Unit | Smallest unit of | Example |
| --- | --- | --- |
| **Phoneme** | sound that changes meaning | `cat` = /k/ /æ/ /t/ — swap /k/ for /b/ and you get `bat` |
| **Syllable** | pronunciation, built around a vowel | `water` = wa·ter, two beats of the mouth |
| **Morpheme** | meaning | `cats` = `cat` + plural `-s`, two pieces of meaning |

A phoneme is not "a sound." It is a sound *that makes a difference in this
language*. The p in `pin` and the p in `spin` are physically different — hold
your hand to your mouth and only the first one puffs — but English treats them
as one phoneme, because no English word changes meaning when you swap them. In
other languages that same difference is two phonemes. So the inventory is
language-specific, which is why Japanese hears English `l` and `r` as one thing.

One word measured all three ways:

```
cats  →  4 phonemes    k · æ · t · s
      →  1 syllable    cats
      →  2 morphemes   cat + plural
```

Notice the numbers don't line up, and they never do. Phonemes and syllables
measure **sound**; morphemes measure **meaning**. Two different axes, not one
ladder.

#### What a script picks to encode

Now the types. Every writing system picks one of those units as its main target,
and the choice is what the whole script is built around:

| Type | One symbol = | Vowels | Example |
| --- | --- | --- | --- |
| **Logography** | a morpheme — meaning | n/a | 山 → "mountain" |
| **Syllabary** | a syllable (in Japanese, a mora) | built in | か → "ka" |
| **Abjad** | a consonant | not written | Arabic, Hebrew |
| **Abugida** | a consonant with a default vowel | marks on the consonant | Devanagari, Thai |
| **Alphabet** | a phoneme | own letters | k + a → "ka" |
| **Featural** | a piece of *how the sound is made* | own letters | Hangul |

The middle two are the ones I'd never heard named. An **abjad** writes only
consonants and expects you to supply the vowels from context — Arabic and Hebrew
still work this way. An **abugida** gives each consonant a built-in vowel and
changes it with a mark, so one symbol is a consonant-plus-vowel bundle. Both
names were coined by the linguist Peter T. Daniels, from the opening letters of
the Arabic and Ge'ez orders.

Two of these are worth a second look.

The **alphabet** was invented once. Greeks borrowed the Phoenician abjad around
the 8th century BC, found they had consonant signs for sounds Greek didn't use,
and repurposed them as vowels. Every European alphabet, and Vietnamese quốc
ngữ, and romaji, descends from that one edit.

**Featural** is the newest idea and the rarest. Korean Hangul, commissioned by
King Sejong in the 1440s, builds each consonant's shape out of the position of
your tongue and mouth when you say it. Related sounds look related on the page.
Nothing else in wide use does this.

And no script is purely one type. Chinese characters look like the definition of
logography, but the large majority are **phono-semantic compounds** — one part
for meaning, one part for sound:

```
媽  mā  "mother"  =  女  woman (meaning)  +  馬  mǎ, horse (sound only)
```

So the honest label for Chinese is *logosyllabic*, not logographic. Japanese
goes further and runs four scripts at once, which is genuinely unusual.

#### The trade every script makes

Once you see what a script encodes, the cost follows. Every one of them trades
an **entry fee** against a **running cost**:

- **Entry fee** — symbols you must memorize before you can read anything at all.
  Paid once.
- **Running cost** — symbols it takes to write one word. Paid on every word,
  forever.

| Type | Entry fee | Running cost |
| --- | --- | --- |
| Alphabet | 26 shapes | high — many letters per word |
| Syllabary | 92 shapes (both kana) | medium |
| Logography | 2,136 shapes (jōyō kanji) | low — 1–2 characters per word |

A cheaper entry fee means a higher running cost. The same Japanese word in two
scripts — not two languages:

```
katakana  →  k-a-t-a-k-a-n-a   8 letters  (alphabet)
          →  カ タ カ ナ         4 kana     (syllabary)
```

The entry fee buys recognition speed: a fluent reader sees 図書館 as a shape and
the meaning arrives with no sounding-out in between.

This also explains why kanji alone cannot write Japanese. Kanji encode meaning,
and Japanese grammar is all endings and particles — sound with no meaning of its
own to hang a character on. Something had to encode sound instead. That is the
job kana was invented for.

#### Grapheme, character, letter

Three words I was using interchangeably, from widest to narrowest:

| Term | Means | Note |
| --- | --- | --- |
| **Grapheme** | the smallest meaningful unit *of a writing system* | English `sh` is one grapheme written with two letters |
| **Character** | any written symbol | the safe general word |
| **Letter** | one symbol in an alphabet or abjad | not used for kanji or kana |

**Grapheme** is the one worth adding to your vocabulary, because it is the
writing-side twin of *phoneme*. Phoneme is to speech what grapheme is to script.
And they don't map one-to-one, which is exactly where spelling gets hard: `sh` is
two letters, one grapheme, one phoneme.

| Symbol | Term |
| --- | --- |
| 漢字 kanji | character (logograph) |
| ひらがな, カタカナ | character (syllabogram) |
| a–z romaji | letter |

#### How regular is the spelling?

The last term, and the one that turned out to matter most to me: **orthographic
depth** — how reliably the written form predicts the spoken one.

A **shallow** orthography is regular. See it, say it. Vietnamese, Spanish, and
Japanese kana are all shallow. A **deep** orthography is full of exceptions, and
English is the standard example: `through`, `though`, `tough`, `thought` share
four letters and rhyme with nothing.

Depth is not the same as script type. Both Vietnamese and English are alphabets,
and they sit at opposite ends. That is a property of the *spelling rules*, not of
the symbols — and it is why sounding out a new word works so well in one and so
badly in the other.

### History

Japanese had no writing at all until Chinese characters arrived. Every script
below exists to patch the mismatch between a writing system built for Chinese
and a language shaped nothing like it.

| When | What | How |
| --- | --- | --- |
| ~5th c. | **Kanji** arrive from China, via the Korean peninsula | Imported wholesale. Scribes first wrote in Classical Chinese — a foreign language — the way medieval Europe wrote in Latin. |
| ~8th c. | **Man'yōgana** | The key invention: use a kanji for its *sound* only, discarding its meaning, so Japanese grammar could finally be written. Named for the *Man'yōshū*, c. 759. |
| ~9th c. | **Hiragana**, **Katakana** | Man'yōgana worn down into simpler shapes by two different shortcuts. |
| 16th c. | **Romaji** | European missionaries transcribing Japanese by ear into Latin letters. |

Nobody invented the kana — they eroded out of man'yōgana over roughly two
centuries of scribes cutting corners. Two habits, two results, often from the
same source character:

```
            加  ("add", read ka)
           ╱                  ╲
   written fast,          left piece
   whole, cursive          clipped off
        ↓                       ↓
        か                      カ
    hiragana                katakana
```

Cursive whole → round and flowing; clipped fragment → angular. That is the
entire visual difference between the two kana sets. Hiragana is associated with
the Heian court women who wrote the era's major literature in it (*The Tale of
Genji*, c. 1000) while Chinese remained the prestige script for men — hence its
old name 女手 *onnade*, "women's hand." Katakana came instead from Buddhist
monks, as clipped margin notes for reading Chinese sutras aloud in Japanese.

The split bought something nobody planned: dense shapes carry content, sparse
shapes carry grammar. A reader parses the structure of a sentence before reading
any word in it — which is how Japanese manages without spaces between words.

**Kanji carry two kinds of reading**, because Japan already had spoken words
before the characters arrived:

| | 山 | 水 | Source |
| --- | --- | --- | --- |
| **on'yomi** | san | sui | approximated Chinese pronunciation |
| **kun'yomi** | yama | mizu | the native Japanese word that already existed |

**Romaji sits at a different level** from the other three — it is how Japanese is
*transcribed*, not how it is written. The mapping is clean because nearly every
mora is consonant+vowel, but it works in one direction only: kana cannot write
consonant clusters (`strengths` → ストレングス). Jesuit-era romanization spells
日本 as *Nifon*, freezing a 16th-century pronunciation of は closer to /fa/.

The competing modern systems disagree because they optimize for opposite things.
Hepburn (1867) is built around English pronunciation and collapses じ/ぢ to `ji`;
Nihon-shiki (1885) and Kunrei-shiki (1937) are built around the kana grid and
keep them as `zi`/`di`. The same split makes し・ち・つ・ふ read *shi, chi, tsu,
fu* in Hepburn but *si, ti, tu, hu* in Kunrei.

### The four scripts

| Script | Type | Shapes | Carries |
| --- | --- | --- | --- |
| **Hiragana** | Syllabary | 46 | native words, and all grammar — particles, verb endings |
| **Katakana** | Syllabary | 46 | loanwords, onomatopoeia, emphasis |
| **Kanji** | Logography | 2,136 jōyō | content words — nouns, verb and adjective stems |
| **Romaji** | Alphabet | 26 | transcription, and typing: `nihongo` → にほんご → 日本語 |

#### Kana: the mora and the 46

Kana is not strictly syllabic. Its unit is the **mora** — a unit of timing.
Every kana is one mora, except the small ゃゅょ, which merge with the preceding
kana into a single mora. っ and ん are each a mora of their own.

Morae and syllables do not count the same:

| Word | Morae | Syllables |
| --- | --- | --- |
| にほん Nihon | 3 — に・ほ・ん | 2 |
| きって kitte | 3 — き・っ・て | 2 |
| とうきょう Tōkyō | 4 — と・う・きょ・う | 2 |

Japanese rhythm is counted in morae: haiku's 5-7-5 counts morae, not syllables.
Romaji flattens this — "Tokyo" hides four beats.

Both kana sets number 46 because they render this same inventory: あ↔ア, か↔カ,
all the way down. The count comes from the 五十音 *gojūon* grid, 5 vowels × 10
consonant rows:

| | a | i | u | e | o |
| --- | --- | --- | --- | --- | --- |
| — | あ ア | い イ | う ウ | え エ | お オ |
| k | か カ | き キ | く ク | け ケ | こ コ |
| s | さ サ | し シ | す ス | せ セ | そ ソ |
| t | た タ | ち チ | つ ツ | て テ | と ト |
| n | な ナ | に ニ | ぬ ヌ | ね ネ | の ノ |
| h | は ハ | ひ ヒ | ふ フ | へ ヘ | ほ ホ |
| m | ま マ | み ミ | む ム | め メ | も モ |
| y | や ヤ | — | ゆ ユ | — | よ ヨ |
| r | ら ラ | り リ | る ル | れ レ | ろ ロ |
| w | わ ワ | — | — | — | を ヲ |

```
 50  grid slots
 −5  sounds that do not exist (yi, ye, wi, wu, we)
 +1  ん, which has no vowel and sits outside the grid
 ───
 46
```

(ゐ *wi* and ゑ *we* did exist; both were retired in the 1946 spelling reform.)

Past those 46 shapes, the remaining sounds come from **rules**, not from new
characters:

| Rule | Effect | Adds |
| --- | --- | --- |
| ゛ dakuten | voices it — か→が, は→ば | 20 |
| ゜ handakuten | は row → ぱ row | 5 |
| small ゃゅょ | き + ゃ → きゃ | 33 |

So the entry fee is 46 shapes plus 3 rules per set — not 104 separate characters.

#### Hiragana or katakana?

The two kana are 1:1 twins over the same 46 sounds. Which set a word takes is a
property of the word itself, not of its position in the sentence.

That is where the tempting comparison to uppercase and lowercase breaks. It
holds for the shapes, but not for the usage. You can recase an English word
freely — cat, Cat, CAT are all still the same correct word. You cannot re-kana
one: コーヒー written as こーひー is not a style choice, it looks broken. For
usage the closer analogy is *italics*, which English also reserves for foreign
words. The exception is emphasis, where the two line up exactly — だめ → ダメ
works like "no" → "NO".

#### Borrowing into katakana

Romaji and katakana are mirror images — each projects one sound system onto the
other's script. What they produce differs. Romaji writes Japanese in foreign
clothes: `nihongo` is not an English word. Katakana does the opposite, and
naturalizes foreign words into Japanese. コンピューター is not English written
in kana; it is a Japanese word, with Japanese morae, used by Japanese speakers
speaking Japanese.

A foreign word enters Japanese by being forced through the mora system. Three
rules:

1. **Use the sound, not the spelling** — `knife` → ナイフ, the silent k vanishes.
2. **Give every stranded consonant a vowel** — `u` by default, but `o` after t
   and d, because *tu* and *du* would distort into *tsu* and *zu*.
3. **Swap the sounds Japanese does not have:**

| English | Becomes | Example |
| --- | --- | --- |
| l and r | r | light, right → both ライト |
| v | b | video → ビデオ |
| th | s or z | three → スリー |

```
strike  →  s · t · r+ai · k  →  ストライク    one syllable in, five morae out
```

This decodes katakana reliably; it does **not** reliably generate it. Established
loanwords are conventional and often clipped — スマホ (smartphone), パソコン
(personal computer) — and many are 和製英語 *wasei-eigo*, English-shaped words
that are not English: マンション is an apartment, バイキング is a buffet.

So katakana teaches Japanese vocabulary, not English. Learn "computer" as
コンピューター and an English speaker may not recognize it — a problem common
enough to have its own name, カタカナ英語.

## Terms

Four languages, three kinds of script, one comparison worth making: Vietnamese,
English, Japanese, Chinese.

Vietnamese and English are both alphabets. Japanese writes with kana, a
syllabary, next to kanji, a logography. Chinese writes only in logography —
no alphabet or syllabary sitting underneath it.

Vietnamese has something close to a national teaching method built into its
script: **đánh vần**, literally "sounding out the rhyme." You say the pieces of
a syllable one at a time — the initial consonant, the vowel, the tone — and
blend them out loud until they snap together into the word. Because quốc ngữ
spelling is close to fully regular, the blend is smooth almost every time. Get
the pieces right and the syllable falls out on its own.

English has the same idea under a different name — phonics, sounding out
c-a-t into "cat" — so đánh vần isn't unique to Vietnamese, just cleaner.
English spelling is riddled with exceptions, so the blend often doesn't land:
you can move your mouth through the right sounds and still land on the wrong
word.

Japanese kana can't blend at all, because there's nothing smaller to blend.
か is already one mora, one shape, one sound — you don't build it out of "k"
plus "a" the way an alphabet would. The mouth moves correctly because there's
only one way to say it. There's no assembly step to be smooth or rough about.

Chinese has no real equivalent. A character's shape doesn't tell you its
sound, so there's nothing to sound out from the page. The closest thing
history produced was **fanqie**, a method from the 3rd century that spliced
two characters together — the initial sound of one, the rest of the sound
from another — to point at how a third, unfamiliar character was pronounced.
That was a scholar's tool for dictionaries and commentary, not something an
ordinary reader does on sight the way a Vietnamese child sounds out a new
word.

I think sound is the oldest form of human language — older than any writing
system, maybe older than the first drawn sign. It was the first way people
found to take a thing they couldn't see, a concept, and hand it to someone
else anyway.

## Nihongo

Romaji is a trap, the same way pinyin is a trap for Chinese. It's easy to
lean on it forever — typing sounds in Latin letters instead of ever reading
the real script — right up until you notice you've learned to type Japanese
sounds, not to read Japanese.

The trap runs both ways. Romaji is the trap for a foreigner learning
Japanese; katakana is the trap for a Japanese person learning English. Both
put a familiar system between you and the real sounds. They are not equally
bad, though. Romaji is optional — drop it after a few weeks and it's gone.
Katakana can't be dropped, because it isn't a study aid, it's part of
Japanese: コンピューター is a word you need in order to read a newspaper. And
the damage lands deeper. Japanese has a single flap sound where English has
both /r/ and /l/, so
[both English sounds get filed under that one native category](https://pmc.ncbi.nlm.nih.gov/articles/PMC3472521/),
and telling them apart stays hard after years of English study. That is not
a pronunciation problem — it is not hearing the difference at all. Training
fixes it, but only training aimed straight at it. In exchange, katakana
hands over thousands of half-known words, which romaji never does for me.
It's a better bridge and a worse crutch.

Back on my side of it, the right order runs the other way: image to sound,
sound to word. See the
thing, hear the word for it, then meet the word on the page — image, sound,
and word forming one small loop, each piece pointing to the next. That's
close to what 19th-century language teachers called the direct method: tie
meaning straight to the sound of the target language, with no translation
sitting in between. And it's how Japanese speakers learned before romaji ever
existed.

That's the idea behind [my-nihongo-rho.vercel.app](https://my-nihongo-rho.vercel.app/),
a small site I built for myself. Mazii and the other big Japanese learning
tools test you on everything they know, whether you've learned it yet or
not. Mine tests you on what I actually know. If I've only learned 15
hiragana, the flashcards and quizzes stay inside those 15 — no katakana, no
kanji sprung on me early. The test follows my learning state, not the
dictionary's.

The other piece is looping. Learning is cheap the first time and expensive
every time after, if the gap between reviews grows too long. Spend an hour
learning five characters and never touch them again, and you'll spend
another hour relearning them later. Come back the next day for just fifteen
minutes instead, and the same five characters stick for far longer. Hermann
Ebbinghaus mapped this in 1885 and called it the **forgetting curve**: memory
drops fastest right after learning, and each well-timed review flattens the
drop a little more. Building the site let me carry that loop everywhere — a
phone in a waiting room is enough.

I think the next step for apps like this is real personalization: not just
spaced repetition, but tracking what a learner has actually been taught, in
a real class, from a real teacher, and only testing and reviewing that. Log
in after a lesson and the app already knows what was covered, and only asks
you to loop on that. It makes the discipline of coming back every single day
much easier to keep.

**Entry fee, running cost** — the same trade from the Overview above applies
to *learning* the script, not just writing it. Every hiragana you learn is
paid once; every word you read with it afterward gets cheaper, and stays
cheaper, forever.

## LLM

Months into paying that entry fee — memorizing hiragana, then katakana, then a
slow trickle of kanji — I noticed the same trade shows up one level down,
inside the models I use every day. It's not just that I pay to learn
Japanese. Every request an LLM handles in Japanese pays too, and the
currency is tokens.

Modern tokenizers are built the way modern models are trained: mostly on
English text. In UTF-8, an English letter costs one byte, and most
Japanese, Chinese, Thai, or Hindi characters cost three — and the
vocabulary a byte-pair tokenizer learns from English-heavy data ends up
shaped the same way, short common tokens for English words, thin fragments
for everything else. The effect has a name,
[**token fertility**](https://tianpan.co/blog/2026-04-20-multilingual-token-tax-llm-production) —
tokens needed per word. Japanese runs about 2.1× English on average, and
individual sentences can hit 8×. Chinese sits lower, around 1.76×, because
one character often becomes one token even while paying three bytes for
it. Arabic, Hindi, and Burmese commonly run 3–4×. None of that is a
language being "hard." It's a vocabulary built for one language, charging
rent to every other one.

If that sounds familiar, it should — katakana does the same job, pointed
the other way. It takes a foreign word and forces it through a fixed
inventory it can't extend: `strike` goes in as one syllable and comes out
as ストライク, five morae, because there is no other way to spell it. Sounds
Japanese doesn't have get mapped onto the nearest one it does. What gets
lost never comes back, which is exactly why the rules above decode katakana
reliably but can't generate it reliably. An English-trained tokenizer
meeting a Japanese sentence is doing the same thing with the arrow
reversed: a fixed vocabulary, no room made for the guest, and a bill for
the mismatch.

I used to read the quality gap between English and Japanese output as
proof the model didn't really "understand" Japanese underneath — that
whatever it does with meaning wasn't the same for every language. The
research says otherwise: multilingual models build a
[shared semantic space](https://arxiv.org/html/2406.13229v1) in their
middle layers, where a sentence and its translation land close together no
matter which language either was written in, closer to a lingua franca
than sealed-off understandings per language. The performance gap is real,
but the cause is duller than "no real understanding." Tokenization
inflates the cost of some languages before a single weight gets touched,
and those same languages were seen far less often during training. Cost
and data volume are doing the damage, not comprehension.

So a growing thread of research attacks the cost side directly, by shaping
the vocabulary around the language instead of importing one built for
English.
[Swallow](https://swallow-llm.github.io/swallow-llama.en.html), a Japanese
model out of Tokyo Institute of Technology, took an existing tokenizer and
added over 11,000 Japanese subwords to it, shortening the average sequence
and speeding up generation without training from nothing.
[Typhoon](https://arxiv.org/pdf/2312.13951), built for Thai, reports a
tokenizer roughly 2.6× more token-efficient than the general-purpose one
it replaced. Neither one starts over. Both extend what already exists,
aimed at a single language.

That's the same trade from the Overview, in different clothes. A bigger
vocabulary is a bigger **entry fee** — more subwords stored, a wider
embedding matrix, more parameters, paid once, at training time. In return
it buys a lower **running cost** — fewer tokens per sentence, paid on
every request after that, forever. It's the same shape as 2,136 kanji
buying one or two characters per word instead of ten. Only one thing
moved: who holds the bill. With kanji, the same learner pays both the
entry fee and the running cost. With a tokenizer, a lab pays the entry fee
once, and everyone who ever sends that model a Japanese sentence pays the
running cost after them.

> **Lesson:** learn Japanese — it makes your salary go up :))) 💰
