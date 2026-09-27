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

Xuanlong QIN (Teaching Assistant)

---

## Agenda

1. Why R for digital sociology?
2. RStudio & R scripts: the basics and syntax
3. How to write codes? (The logistic of coding)
4. R Programming
5. Hands-on: from data to a plot

---

## Why R?

- **Open source** and free — runs everywhere
- Purpose-built for **statistics and data analysis**
  - Comparing with **Python**
- Packages for digital sociology: `dplyr`, `ggplot2`, `igraph`, `quanteda`, `httr`…
  - Public Package ([CRAN](https://cran.r-project.org/web/packages/available_packages_by_name.html))
- Great for **reproducible research** (scripts > clicks)

<!--
Python is also available for researcher; R is classic of Social Scientist. 
-->

---
## Before Coding

- I am also new to R programing
- Learn-by-doing
- Know `"Input"` and Read `"Output"` - My personal experience
- AI is a helpful tool (Encouraged) - The point is AI can help us writing code but you need to know what are they writing for you.

---
## RStudio basics (1)

**The four panes**

1. Source (scripts) - Rmd file vs. R file
2. Console
3. Environment
4. Files / Plots / Help 

Run the current line with `⌘ + Enter` or click `Run`

---
## RStudio basics (2)

**Tips**

- Create an **R Project** per course
- Use relative paths: `read_csv("data/x.csv")`
  - the difference between `Path` and `Relative Path`

- You can use the provided `.Rmd` file to follow the tutorial.

---
## 1. Learn R basics and syntax 

1. Input
2. Comment
   - Comments can be used to explain R code, and to make it more readable. 
   - It can also be used to prevent execution when testing alternative code.
   - Comments starts with a `#`. When executing code, R will ignore anything that starts with `#`.


---
### Work with R variables and data types
1. Variable
   - **Variables are containers for storing data values.**
2. Data Types
   - In programming, data type is an important concept.
   - **Variables can store data of different types, and different types can do different things.**
   - In R, variables do not need to be declared with any particular type, and can even change type after they have been set

---
### Work with R variables and data types
Basic Data Types
   - numeric - (10.5, 55, 787) - e.g., age, grade, income
   - integer - (1L, 55L, 100L, where the letter "L" declares this as an integer) -  e.g., educational level  
   - complex - (9 + 3i, where "i" is the imaginary part) - e.g., Common in mathmatics
   - character (a.k.a. **string** more common) - ("k", "R is exciting", "FALSE", "11.5") - e.g., tweets..
   - logical (a.k.a. **boolean** more common) - (TRUE or FALSE) - e.g., gender..


---
### Work with R variables and data types
Type Conversion
   - as.numeric()
   - as.integer()
   - as.complex()

Why we need convert types?
- In R, you can use operators to perform common mathematical operations on numbers.

---
### Work with R variables and data types
Operators
- Addition, Subtraction, Multiplication, Division, Exponent, Modulus (Remainder from division), Integer Division - for number-related variables

Logistic variable
- In programming, you often need to know if an expression is true or false.
- When you compare two values, the expression is evaluated and R returns the logical answer


---
## 2. R Operators and Control structures (if, while, for)
### R Operators
R divides the operators in the following groups:
- Arithmetic operators - numeric values (e.g., + - * / )
- Assignment operators - assign values to variables (<-)
- Comparison operators - compare two values (`==`, `!=`, `>`, `<`)
- Logical operators -  combine conditional statements (e.g., `&`, `|`, `!`)
- Miscellaneous operators - manipulate data (e.g., `:` )


---
### Controal Structures
The if Statement
- An "if statement" is written with the if keyword, and it is used to specify a block of code to be executed if a condition is TRUE.
- If, else if, else..
- or 

---
### Controal Structures
While Loop
- With the while loop we can execute a set of statements as long as a condition is TRUE
- With the break statement, we can stop the loop even if the while condition is TRUE:

For Loop
- A for loop is used for iterating over a sequence.

---
## 3. Create and use functions in R
A function is a block of code which only runs when it is called.
  - Why we need a function?

You can pass data, known as parameters, into a function.
- To create a function, use the **function()** keyword

A function can return data as a result.
- return something

---
## 4. Work with data structures
Why we need structures?

R provides many built-in data structures. Each is used to handle data in different ways:
- Vectors ; Same type
- Lists; No
- Matrices (2D); Same type
- Arrays (Multiple dimensions); Same type
- Data Frames; No

---
## 5. Make plots and visualize data (line, scatter, pie, bar)

plot() function can solve most visualizaton issue.
- ggplot2() - another package

You can use AI to help enhance your images. - Generally, it is better than human.

---
## 6. Perform basic statistics (mean, median, mode)
Statistics is the science of analyzing, reviewing and conclude data.

The R language was developed by two statisticians. 
- It has many built-in functionalities (Variance,Standard Devation, Probability distributions, etc.)
- In addition to libraries for the exact purpose of statistical analysis. (Regression models, advanced techniques.. we will use them in following tutorials.)

---


# Hands-on

Data → table → plot (5 -10 mins)

---

## Hands-on: from data to a plot

1. Task:
   - Visualize the relationship between vehicle weight and fuel consumption in the `mtcars` dataset;
2. The code is at the end of `Titorial_1.Rmd` file (Hands-on: from data to a plot part)

**Do:** the hands-on exercise end-to-end on your own machine


<!-- _footer: "" -->

---

<!-- _class: lead -->

# Thanks!

Slides & materials: course content on Blackboard or Download from [Github](https://github.com/XuanlongQ/Tutorials/blob/master/SOCI%203238/tutorial1/slides.pdf).

Questions → email (xuanlong@link.cuhk.edu.hk)
