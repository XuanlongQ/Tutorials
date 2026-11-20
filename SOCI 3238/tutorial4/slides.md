---
marp: true
theme: cuhk
size: 16:9
paginate: true
footer: "SOCI 3238 · Digital Sociology · Tutorial 4"
style: |
  /* Slightly smaller type + tighter vertical padding so dense slides fit */
  section {
    font-size: 26px;
    padding: 56px 78.5px;
  }
  pre, code {
    font-size: 0.75em;
  }
  table {
    font-size: 0.72em;
  }
---

<!-- _class: lead -->
<!-- _paginate: false -->

# Text Analysis: From Dictionaries to LLMs

**SOCI 3238 Digital Sociology · Tutorial 4**

Nov 23, 2026 (Mon) 12:30–14:00 · Sino Building 408B

Xuanlong QIN (Teaching Assistant)

---

## Agenda

1. Where are we? Text is data — but how do we *read* it?
2. Part I · Dictionary methods — counting words on a list
   - The document-feature matrix (`quanteda`)
   - Sentiment with the Lexicoder dictionary
3. Part II · Topic modelling — let the data find the topics
   - Latent Dirichlet Allocation (LDA)

---

## Agenda

4. Part III · Embeddings — words as meaning vectors
   - Cosine similarity, nearest neighbours, analogies
   - Bias inside embeddings
5. Part IV · LLMs — prompt a model to read for you
   - Zero-shot classification with `ellmer`
   - Validation, cost & ethics
6. Hands-on · the four methods on one corpus

---

## Where are we?

**Tutorial 1** — the R toolbox
**Tutorial 2** — models, tests, networks
**Tutorial 3** — collecting data from the web (APIs, scraping)

Today: **Tutorial 4** — analysing text
- The web pages, tweets, papers and headlines you collected are *text*
- Numbers are easy for computers; text needs a translation step

> A research pipeline: collect → clean → turn text into numbers → analyse

---

## Four ways to read text with machines

| | Dictionary | Topic model | Embeddings | LLM |
|---|---|---|---|---|
| Where do categories come from? | you write them | learned from data | none needed | your prompt |
| Output | word counts | topic shares | distances / similarity | free text |
| Transparency | high | medium | low | low |
| Cost | free | free | free | API fees |

- We move from **transparent & rigid** → **flexible & opaque**
- They are *complements*, not rivals — a modern paper often uses several

---

## The core idea: text as data

Computers only do numbers — so first we count:

```r
library(quanteda)                 # install.packages("quanteda")

corp <- data_corpus_inaugural     # built-in: 60 US presidential inaugurals
corp
docvars(corp)                     # Year, President, Party per speech

tok <- tokens(corp, remove_punct = TRUE)   # split into words
dfm_t <- dfm(tok)                          # document-feature matrix
dfm_t                                     # 60 docs × 9,573 word types
```

- Each **document** is a row; each **word** is a column
- Cell = how many times that word appears in that document
- Every method today starts from this matrix (or a variant of it)

---

# Part I · Dictionary Methods

---

## The oldest trick in the book

**Dictionary method** = count how often words from a *predefined list* appear

- The classic social-science content analysis (Berelson 1952) — updated for computers
- You decide what matters, then let R count:
  - Sentiment: Lexicoder, LIWC ("happy", "sad", "angry" …)
  - Topics: protest words, economic words, moral-foundations words
- Works in **any language** — just translate the word list

```r
mini <- dictionary(list(
  war     = c("war", "battle", "military", "soldiers"),
  peace   = c("peace", "harmony", "friendship"),
  economy = c("economy", "tax", "trade", "industry")
))

counts <- dfm_lookup(dfm_t, mini)   # count list words in each speech
counts                              # 60 docs × 3 categories
```

---

## A real dictionary: Lexicoder Sentiment (LSD)

Young & Soroka (2012) — built by political scientists, used in sociology too

```r
pos_neg <- dictionary(list(
  positive = data_dictionary_LSD2015$positive,   # ~1,700 words
  negative = data_dictionary_LSD2015$negative    # ~2,900 words
))

sent <- dfm_lookup(dfm_t, pos_neg)               # 60 × 2 counts

tab <- cbind(docvars(corp), convert(sent, to = "data.frame"))
tab$score <- with(tab, (positive - negative) / (positive + negative))
```

- `score` = net sentiment: −1 (all negative) to +1 (all positive)
- From 60 speeches to 60 numbers → now *any* analysis tool applies

---

## Sentiment of inaugurals, 2005–2025

| Year | President | Party | score |
|------|-----------|-------|-------|
| 2005 | Bush | Republican | 0.423 |
| 2009 | Obama | Democratic | 0.239 |
| 2013 | Obama | Democratic | 0.368 |
| 2017 | Trump | Republican | 0.447 |
| 2021 | Biden | Democratic | 0.208 |
| 2025 | Trump | Republican | 0.356 |

```r
plot(tab$Year, tab$score, pch = 19, col = as.numeric(factor(tab$Party)),
     xlab = "Year", ylab = "sentiment score")
```

- All positive — inaugurals are optimistic by genre
- But *how* positive varies → something to explain (era? party? crisis?)

---

## Strengths & limits of dictionaries

**Strengths**
- Transparent & reproducible: anyone can read the word list
- Fast, free, works on any corpus size, any language
- Great for *validation*: a known construct measured the same way everywhere

**Limits**
- Words carry different meanings in context ("not happy" ≠ happy; "bank")
- Dictionary must *already* contain the right words — new slang/terms are missed
- Counting ≠ meaning: "economy" can be praised or attacked

> Dictionaries measure **presence** of topics — not **how** they are discussed
> Rule of thumb: good for known constructs; too rigid for open questions

---

# Part II · Topic Modelling

---

## Let the data define the topics

- Dictionary: *you* bring the categories
- **Topic model**: the algorithm *discovers* themes from word co-occurrence
- Intuition — a newspaper has sections (politics, sports, business):
  - each article is a **mixture** of topics
  - each topic is a **distribution** over words
- Words that travel together ("goal, match, coach") signal a latent topic

> LDA (Latent Dirichlet Allocation, Blei et al. 2003) is the workhorse
> Bag of words — order is ignored, counts still matter

---

## LDA in R

```r
library(topicmodels)

# clean: drop stopwords ("the", "of" ...) — they dominate otherwise
dfm_clean <- dfm(tokens_remove(tok, stopwords("en")))
dfm_clean <- dfm_trim(dfm_clean, min_docfreq = 5)  # rare words out

set.seed(2026)                                   # reproducibility!
lda <- LDA(convert(dfm_clean, to = "topicmodels"),
           k = 5, control = list(seed = 2026))

terms(lda, 8)          # top 8 words per topic
topics(lda)            # most likely topic for each speech
posterior(lda)$topics  # 60 × 5 matrix: share of each topic per speech
```

- `k` = how many topics to look for — **your** choice
- `set.seed()` — LDA is random; a seed makes results repeatable

---

## Reading the topics (k = 5)

What the model found in 60 inaugurals:

| Topic | Top words | Your label? |
|-------|-----------|-------------|
| 1 | government, people, country, shall, public | ? |
| 2 | government, states, union, great, every | ? |
| 3 | us, america, nation, world, people, new | ? |
| 4 | people, upon, government, states, constitution, congress | ? |
| 5 | world, must, peace, nations, great | ? |

- The model only gives **word lists** — *you* name the topics
- Topic 5 (peace/nations) peaks after WWII; Topic 2 (union) in the 1800s

```r
topics(lda)[56:60]    # last five speeches → which topic wins?
```

---

## Topics over time

```r
tab2 <- cbind(docvars(corp), top = topics(lda))
table(tab2$Year, tab2$top)          # topic × year counts

share <- posterior(lda)$topics      # 60 × 5 probabilities
barplot(t(share[, 1:2]), col = c("steelblue", "tomato"))
```

- Topics have a **history**: wars, depressions, new technology shift the mix
- For sociology: do parties / eras talk differently? (add covariates → STM)
- In sociology, the upgrade is the **STM** (Structural Topic Model, Roberts et al.) — topics + document metadata together

---

## Strengths & limits of topic models

**Strengths**
- No prior categories needed — *discovery*, not confirmation
- Scales to millions of documents
- Comparable across corpora & time

**Limits**
- `k` is a choice — try several, judge by interpretability (and coherence)
- Results vary run to run (fix the seed!)
- Output still needs **your interpretation** — "garbage in, garbage out"
- Bag of words ignores word order & context

> Topic models *propose* structure; researchers must still read the texts

---

# Part III · Embeddings

---

## From counting words to meaning

- So far: each word is a column — "war" and "battle" are as different as "war" and "banana"
- **Embeddings** = each word becomes a dense vector of ~50–300 numbers
- Trained on the idea: *similar words appear in similar contexts*
  - "You shall know a word by the company it keeps" — Firth (1957)
- **Word2vec / GloVe**: predict neighbours in huge corpora (Wikipedia…)
- Result: words with similar meanings land near each other in vector space

```
war  →  [ 0.12, −0.34, 0.08, ... 50 numbers ]
```

---

## Loading word vectors & measuring similarity

```r
glove <- readRDS("glove_top30k.rds")   # cached: top 30k words, 50-dim
dim(glove)                             # 29999 × 50
glove["democracy", ]                   # one row = one word

cos_sim <- function(a, b) sum(a * b) / sqrt(sum(a^2) * sum(b^2))
cos_sim(glove["war", ], glove["peace", ])        # 0.644
cos_sim(glove["war", ], glove["battlefield", ])  # 0.636
```

- **Cosine similarity**: 1 = same direction, 0 = unrelated, −1 = opposite
- (These vectors: Stanford GloVe, trained on 6 billion tokens — cached in the materials folder so the class works offline)

---

## Nearest neighbours: words as *meaning*, not strings

```r
nearest <- function(word, n = 8) {
  sims <- apply(glove, 1, function(r) cos_sim(glove[word, ], r))
  sort(sims, decreasing = TRUE)[2:(n + 1)]
}

nearest("democracy")
```

| Query | Neighbours |
|-------|------------|
| democracy | freedom .82, independence .80, peaceful .78, movement .77, unity .76, struggle .76 |
| immigration | laws .79, enforcement .79, immigrants .77, legislation .76, restrictions .75, policy .74 |
| inequality | disparities .80, disparity .78, societal .76, gender .66, racial .64 |

- The model learned *sociological* associations from 6B tokens of text

---

## The famous analogy trick

Word vectors support **arithmetic**: king − man + woman ≈ ?

```r
target <- glove["king", ] - glove["man", ] + glove["woman", ]
sort(apply(glove, 1, function(r) cos_sim(target, r)),
     decreasing = TRUE)[1:6]
```

```
    king     queen  daughter    prince    throne  princess
   0.886     0.861     0.768     0.764     0.763     0.751
```

- The "gender direction" is captured as a vector difference
- Same idea: `paris − france + china ≈ beijing`
- **Why it matters for sociology**: concepts become *measurable positions*, not just keyword matches

---

## Static → contextual embeddings

- GloVe gives **one** vector per word — but "bank" differs in "river bank" vs "bank account"
- **Contextual models** (BERT, 2019 → LLMs) read the sentence and produce a vector *for this occurrence*
- Sentence/document embeddings: one vector per text → compare documents, measure concepts
- Packages for social science:
  - `text` — sentence embeddings in R (HuggingFace models)
  - `conText` — embedding *regression*: how contexts change word meaning (Rodriguez, Spirling & Stewart)

> Embeddings let you ask "how similar is text A to text B" — the basis of modern search & recommendation, and increasingly of measurement in sociology

---

## Bias is baked in

Embeddings learn from real text — so they inherit its stereotypes

- Bolukbasi et al. (2016): in Google News word2vec, man − woman + programmer ≈ *computer programmer*; woman − man + doctor ≈ *nurse*
- Garg et al. (2018, PNAS): 100 years of word vectors → gender & ethnic stereotypes track occupational census data
- Gender direction can be measured (and the difference *used* in research — e.g. measuring how much a job ad leans "masculine")

> Embeddings are **mirrors of the corpus** — treat them as data about society, not neutral facts

---

# Part IV · LLMs

---

## What LLMs changed

- Older tools: count, cluster, compare vectors
- **LLMs** (GPT, Claude, DeepSeek, Llama…): *read* text and answer instructions
  - Classify, extract, summarise, translate — with **zero examples** (or a few)
  - They act as *annotators*: coding text at scale
- Research evidence: ChatGPT can match crowd workers for annotation tasks (Gilardi et al. 2023, PNAS)
- In sociology: coding interviews, protest events, frames, moral language …

> The skill that matters is now **prompt design + validation**, not only model fitting

---

## The LLM workflow

```
1. Design the task   →  "Classify each headline into Economy/Politics/Culture/Technology"
2. Write the prompt  →  role + task + output format + examples
3. Call the API      →  for each text
4. Validate          →  human-codes a sample, compare, fix the prompt
```

- **Never** trust the first answer: check a sample yourself (inter-rater logic)
- Cheap baseline: run your **dictionary** on the same texts — the two should roughly agree; disagreements are findings or bugs
- Log the model, version, prompt & date — reviewers will ask

---

## LLMs in R: ellmer

```r
# install.packages("ellmer")
library(ellmer)

chat <- chat_openai(
  system_prompt = "You are a sociology research assistant. Classify each news headline into ONE topic: Economy, Politics, Culture, or Technology. Reply with only the topic name.",
  base_url = "https://api.deepseek.com",     # any OpenAI-compatible API
  api_key = Sys.getenv("DEEPSEEK_API_KEY")   # never hard-code keys!
)

chat$chat("Hong Kong stock market falls sharply amid global trade concerns")
## [1] "Economy"
```

- `chat_openai()` also works for ChatGPT (`OPENAI_API_KEY`); same code, different `base_url`
- **Free & private option** — run a local model:

```r
chat_local <- chat_ollama(model = "deepseek-r1:7b")   # ollama.com
chat_local$chat("Local community organizes a volunteer day to clean up the harbour")
## [1] "Culture"
```

---

## Example output (made with deepseek-r1:7b locally)

From `llm_example.json` in the materials folder:

| Headline (shortened) | Topic | Agree? |
|---|---|---|
| HK government announces a new tax policy to boost innovation… | Economy | ✓ |
| Local community organizes a volunteer day to clean up the harbour | Culture | ✓ |
| CUHK researchers publish a study on social inequality and mental health | Politics | **?** |
| HK stock market falls sharply amid global trade concerns | Economy | ✓ |
| HK students win gold medals at the International Film Festival | Culture | ✓ |

- Model answers are **proposals to verify** — the third one is debatable: a study of inequality is not "politics" (would *you* accept it?)
- This is exactly why step 4 (validation) exists

---

## Cost, privacy & ethics

- **Keys & cost**: API calls are cheap but not free; keep keys out of shared scripts
- **Privacy**: don't send confidential / personal data to a cloud API — local models (ollama) stay on your laptop; check university policy
- **Disclosure**: journals increasingly require stating LLM use (which model, what for)
- **Bias**: LLMs inherit training-data biases; verify, don't assume neutrality
- **Reproducibility**: record model + version + prompt + temperature; results *will* drift

> Use LLMs as a *scalable first coder*, not as the final judge

---

## Four methods, one pipeline

| | Dictionary | Topic model | Embeddings | LLM |
|---|---|---|---|---|
| Task | measure known constructs | discover themes | similarity / concepts | complex coding |
| Categories | fixed by you | learned | not needed | prompted |
| Interpretation | easy | medium | hard | easy (but hidden) |
| Cost | free, offline | free, offline | free, offline | fees / hardware |
| Typical role | validation, replication | exploration at scale | measurement, bias | annotation at scale |

**They stack**: dictionary for a baseline → topic model to map the corpus → embeddings to measure a concept → LLM to code the hard cases

---

# Hands-on

One corpus — the 60 inaugural speeches — four methods (≈ 5 min each)

---

## Hands-on A · Dictionary

1. Count your own mini-dictionary words across speeches
2. Compute the LSD sentiment score per speech
3. Plot sentiment over time, coloured by party

Questions:
- Which president was most positive? most negative?
- Any pattern by party or era? (Try `tapply(tab$score, tab$Party, mean)`)

---

## Hands-on B · Topic model

1. Fit LDA with `k = 4` and `k = 6` (seed = 2026)
2. Print the top words — label the topics in your own words
3. Which topic dominates Trump 2017? Biden 2021?

```r
posterior(lda)$topics["2017-Trump", ]   # topic shares of one speech
```

- Which `k` gives topics you can actually *name*?

---

## Hands-on C · Embeddings

1. `nearest("democracy")`, then your own words: try "gender", "protest", "internet"
2. The analogy: `king - man + woman`, then try `paris - france + china`
3. Plot word vectors in 2-D:

```r
words <- c("democracy","freedom","war","peace","economy","tax",
           "family","education","science","internet","immigration",
           "inequality","government","rights","market","religion")
pca <- prcomp(glove[words, ], scale. = TRUE)
plot(pca$x[, 1], pca$x[, 2], type = "n")
text(pca$x[, 1], pca$x[, 2], labels = words, cex = 0.9)
```

---

## Hands-on D · LLM

1. Copy the `chat_openai()` code — set your key (DeepSeek, ChatGPT, or local `chat_ollama`)
2. Classify these three headlines yourself **first** (human coder!), then with the model:

```
"Hong Kong announces measures to support first-time home buyers"
"City orchestra wins international award for contemporary music"
"Unemployment rate drops to a 10-year low"
```

3. Compare: where do you and the model disagree?
4. No API access? Read `llm_example.json` — check every label: would you accept all five?

---

## That's the whole course!

- T1 · the R toolbox → T2 · models & networks → T3 · collecting data → T4 · analysing text
- You now have a complete **pipeline**: collect → clean → quantify → model → interpret
- Text is the biggest dataset in digital sociology — you know four ways in

---

## Materials for your references

- Grimmer & Stewart (2013), *Text as Data* (the manifesto): https://www.cambridge.org/core/journals/political-analysis/article/text-as-data-the-promise-and-pitfalls-of-automatic-content-analysis-methods-for-political-texts/F7AAC8B2909441603FEB25C156448F20
- `quanteda` docs: https://quanteda.io · STM: https://www.structuraltopicmodel.com
- `conText` (embedding regression): https://github.com/prodriguezsosa/conText
- Bolukbasi et al. (2016), *Man is to Computer Programmer as Woman is to Homemaker*: https://arxiv.org/abs/1607.06520
- Gilardi et al. (2023), *ChatGPT outperforms crowd workers*: https://www.pnas.org/doi/10.1073/pnas.2305016120
- `ellmer` docs: https://ellmer.tidyverse.org · Local models: https://ollama.com

---

<!-- _class: lead -->

# Thanks!

Slides & materials: course content on Blackboard or download from [Github](https://github.com/XuanlongQ/Tutorials/blob/master/SOCI%203238/tutorial4/slides.pdf).

Questions → email (xuanlong@link.cuhk.edu.hk)
