---
marp: true
theme: cuhk
size: 16:9
paginate: true
footer: "SOCI 3238 · Digital Sociology · Tutorial 2"
---

<!-- _class: lead -->
<!-- _paginate: false -->

# Statistical Models & Network Analysis

**SOCI 3238 Digital Sociology · Tutorial 2**

Oct 12, 2026 (Mon) & Oct 16, 2026 (Fri) 12:30–14:00 · Sino Building 408B

Xuanlong QIN (Teaching Assistant)

---

## Agenda

1. Recap: from Tutorial 1 to Tutorial 2
2. Statistical Models in R
   - Hypothesis testing — t-test & chi-square
   - Linear regression — `lm()`
   - Logistic regression — `glm()`
3. Network Analysis in R
   - Why networks? Nodes & edges
   - Building & plotting graphs with `igraph`
   - Centrality — who is important?
   - Community detection
4. Hands-on

---

## Where are we?

**Tutorial 1** — the toolbox
- Variables, functions, data frames
- `plot()`, `mean()`, `summary()`

**Tutorial 2** — putting the toolbox to work
- Ask questions of data → test & model → networks
- Two families of answers:
  - *Statistical models*: attributes of individuals
  - *Network analysis*: relations between individuals

---

# Part I · Statistical Models

---

## From description to inference

**Descriptive statistics** — what does my data look like?
- `mean()`, `median()`, `summary()`, plots (Tutorial 1)

**Inferential statistics** — is the pattern real? What explains it?
- Hypothesis testing: is this difference / association real?
- Modeling: how does x relate to y?

> Both answer: "can I trust this pattern beyond my sample?"

---

## Hypothesis testing (1)

A formal way to decide whether an observed pattern is "real"

- **Null hypothesis (H0)**: nothing is going on (no difference, no association)
- **Alternative hypothesis (H1)**: something is going on
- **p-value**: probability of seeing data like this *if H0 is true*
- Convention: p < 0.05 → reject H0 ("statistically significant")

> p < 0.05 means "H0 looks unlikely", not "my theory is proven"

---

## Hypothesis testing (2): t-test

Compare the means of two groups

```r
t.test(mpg ~ am, data = mtcars)
```

- `am` = 0 (automatic) vs 1 (manual): is fuel efficiency different?
- Read the output: group means, t statistic, df, **p-value**

Digital sociology example: do verified accounts get more likes on average?

---

## Hypothesis testing (3): chi-square test

Test the association between two categorical variables

```r
tbl <- table(mtcars$cyl, mtcars$am)
chisq.test(tbl)
```

- H0: no association; p < 0.05 → associated
- Digital sociology example: is gender associated with platform choice?

---

## Linear regression (1)

Model how a numeric outcome depends on predictors

- Fit the line that best describes y ~ x
- y = a + b·x + error
- `lm(y ~ x, data = ...)`

```r
model <- lm(mpg ~ wt, data = mtcars)
summary(model)
```

(This is the line we drew in Tutorial 1's hands-on with `abline()`)

---

## Linear regression (2): reading the output

- **Estimate (b)**: a one-unit increase in x → b change in y
- **Pr(>|t|)**: is b significantly different from 0?
- **R²**: share of variation in y explained by the model (0–1)

Interpretation template:
> "A 1,000 lbs heavier car is associated with 5.3 mpg lower fuel efficiency (p < .001)"

---

## Linear regression (3): multiple predictors

```r
model2 <- lm(mpg ~ wt + hp, data = mtcars)
```

- Now b means "holding the other variables constant"
- Categorical predictors → make them factors first (Tutorial 1!)

```r
model3 <- lm(mpg ~ wt + factor(cyl), data = mtcars)
```

- Model comparison: does adding a variable help? (R², AIC)

---

## Logistic regression (1)

When the outcome is **binary** (0/1, yes/no)

- Digital sociology: retweet or not? follow back or not? purchase or not?
- Why not `lm()`? → predicted values can go outside [0, 1]

```r
model4 <- glm(am ~ wt + hp, data = mtcars, family = binomial)
summary(model4)
```

---

## Logistic regression (2): interpretation

- Output is in **log-odds** — hard to interpret directly
- Convert to **odds ratios**:

```r
exp(coef(model4))
```

- OR = 2 → the odds double per one-unit increase in x
- OR < 1 → negative association; OR > 1 → positive association

---

## Which model when?

| Your question | Test / model |
| ------------- | ------------ |
| Are two group means different? | t-test |
| Are two categorical variables associated? | chi-square |
| What predicts a numeric outcome? | linear regression `lm()` |
| What predicts a binary outcome? | logistic regression `glm()` |

> Rule of thumb: look at the outcome variable first

---

# Part II · Network Analysis

---

## Why networks?

Digital sociology studies **relations**, not only attributes

- Follows on Weibo/Twitter, retweets, replies, friendships
- Networks = individuals (**nodes**) + ties (**edges**)

Attribute view: who is this person? (age, gender, likes)
Network view: who is connected to whom? (position, influence, community)

---

## Graph basics

- **Nodes** (vertices) — people, accounts, organizations
- **Edges** — ties between them
- **Directed** — A follows B ≠ B follows A
- **Undirected** — friendship: mutual
- **Weighted** — number of messages, strength of tie

Data format: **edge list** — a table with two columns: from, to

---

## igraph: build & plot

```r
library(igraph)

g <- graph_from_data_frame(edges, directed = TRUE)
plot(g)
```

- `V(g)` — nodes, `E(g)` — edges
- Add attributes: `V(g)$name`, `V(g)$group`

Classic example built into igraph: **Zachary's karate club** (1977)

```r
make_graph("Zachary")
```

---

## Network measures (1): degree & density

- **Degree** — how many ties a node has
  - in-degree: followers; out-degree: following
  - Digital sociology: the influencer = high in-degree

```r
degree(g, mode = "in")
```

- **Density** — how connected the network is overall

```r
edge_density(g)
```

---

## Network measures (2): centrality

Who is "important" in the network?

- **Degree centrality** — most ties (popular, active)
- **Betweenness centrality** — on many shortest paths (bridges, gatekeepers)
- **Closeness centrality** — close to everyone else (information spreads fast)

```r
betweenness(g)
closeness(g)
```

> Different measures → different kinds of importance

---

## Community detection

Find groups that are densely connected within, sparsely between

- The karate club: members split into two clubs — can the algorithm find it?

```r
cm <- cluster_fast_greedy(g)
membership(cm)
plot(cm, g)
```

---

## A social media example

- Edge list of user accounts: `user_id` follows `followee_id`
- Find the influencers (top in-degree)
- Visualize the community structure

`igraph` works the same way for 34 karate members and 34 million users

---

# Hands-on

Part A · Statistical models (10 min)
Part B · Network analysis (10 min)

---

## Hands-on A: Statistical models

Dataset: `mtcars` (continuation of Tutorial 1)

1. **t-test** — does fuel efficiency differ between automatic and manual cars?
2. **Linear regression** — model `mpg` with `wt + hp`; interpret coefficients and R²
3. **Logistic regression** — model `am` (automatic = 0, manual = 1); compute odds ratios

---

## Hands-on B: Network analysis

1. **Build** the karate club network, **plot** it
2. Compute **degree & betweenness** — who are the top-3 most central?
3. Run **community detection** — compare with the real split
4. Load a small **social media edge list** (`data/social_edges.csv`) — find the top influencers and plot

---

<!-- _class: lead -->

# Thanks!

Slides & materials: course content on Blackboard or Download from [Github](https://github.com/XuanlongQ/Tutorials/blob/master/SOCI%203238/tutorial2/slides.pdf).

Questions → email (xuanlong@link.cuhk.edu.hk)
