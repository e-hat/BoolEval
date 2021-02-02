# BoolEval
A Haskell program that evaluates postfix boolean expressions. It supports substitution of custom variable names into expressions.

I created this program as an introduction to the Haskell programming language and to explore the process of parsing.

To use this project, you must have `ghci` installed. To run the program, open the `ghci` console in the same folder as `main.hs` and type `:l main`. Then, run the `main` function. This allows you to type two lines of input. The first line is the definitions used in the program. They are of the form `variableName = [either T or F]`. On the next line, enter a post-fix boolean expression containing "T" or "F" to indicate True/False values, along with any variable names defined in the definitions section. Press `Enter` and the program will output the result of that expression.
