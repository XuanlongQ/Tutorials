---
marp: true
theme: cuhk
size: 16:9
paginate: true
footer: "SOCI 3238 · Digital Sociology · Tutorial 1"
---

<!-- _class: lead -->
<!-- _paginate: false -->

# R Programming & Syntax

**SOCI 3238 Digital Sociology · Tutorial 1**

Sep 28, 2026 (Mon) 12:30–14:00 · Sino Building 408B

[Your Name] (TA)

---

## Agenda

1. Why R for digital sociology?
2. RStudio & R scripts: the basics
3. Objects, vectors, and data frames
4. Control flow & functions
5. Hands-on: from data to a plot

---

## Why R?

- Open source and **free** — runs everywhere
- Purpose-built for **statistics and data analysis**
- Packages for digital sociology: `dplyr`, `ggplot2`, `igraph`, `quanteda`, `httr`…
- Great for **reproducible research** (scripts > clicks)

<!--
Speaker notes go in an HTML comment like this one.
Press "P" in the Marp VS Code preview to see them.
-->

---

## RStudio basics

<div class="columns">
<div>

**The four panes**

1. Source (scripts)
2. Console
3. Environment
4. Files / Plots / Help

Run the current line with `⌘ + Enter`

</div>
<div>

**Tips**

- Create an **R Project** per course
- Use relative paths: `read_csv("data/x.csv")`
- Never rely on `setwd()` in shared scripts

</div>
</div>

---

## Objects & vectors

```r
# everything is an object; <- is assignment
x <- c(2, 4, 6, 8, 10)

length(x)          # 5
mean(x)            # 6
x[x > 5]           # 6  8 10

# character and logical vectors
majors <- c("soci", "econ", "soci")
is_soci <- majors == "soci"
table(majors)      # counts by value
```

---

## Data frames

```r
library(dplyr)

users <- read_csv("data/users.csv")

users |>
  filter(age >= 18) |>
  group_by(education) |>
  summarise(
    n = n(),
    avg_income = mean(income, na.rm = TRUE)
  )
```

> **Key idea:** a data frame is a spreadsheet. Rows are observations, columns are variables.

---

## Control flow & functions

```r
# a tiny function
scale01 <- function(x) {
  (x - min(x, na.rm = TRUE)) /
    (max(x, na.rm = TRUE) - min(x, na.rm = TRUE))
}

users$age_std <- scale01(users$age)

# conditionals and loops
for (year in 2020:2026) {
  if (year %% 4 == 0) cat(year, "is a leap year\n")
}
```

---

<!-- _class: lead -->

# Hands-on

Data → table → plot (15 min)

---

## Hands-on: from data to a plot

1. Open `week1/hands-on.R` from the course repo
2. Load the data and inspect it: `glimpse()`, `summary()`
3. Answer:
   - How many observations? Any missing values?
   - What is the mean of your assigned variable by group?
4. Plot the group means with `ggplot2`

```r
ggplot(df, aes(group, value)) +
  geom_boxplot()
```

---

## Before next tutorial

- **Do:** the hands-on exercise end-to-end on your own machine
- **Install:** `tidyverse`, `igraph`, `tidygraph` — needed in Tutorial 2 (network analysis)
- **Ask:** post questions on the course forum — no question is too basic!

<!-- _footer: "" -->

---

<!-- _class: lead -->

# Thanks!

Slides & materials: course repo

Questions → course forum / email
