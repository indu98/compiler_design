# Mini Compiler for C

## Course Code: CO351

### Overview

This repository contains the design and implementation of various phases of a compiler for the subset of 'C' programming language. This subset includes a sufficiently rich collection of data types and control structures.

The following phases of Compiler Design are implemented:
#### Lexical Phase
This phase scans the source code as a stream of characters and converts it into meaningful lexemes.

#### Syntax Phase
It takes the token produced by lexical analysis as input and generates a parse tree (or syntax tree). In this phase, token arrangements are checked against the source code grammar.

#### Semantic Phase
Semantic analysis checks whether the parse tree constructed follows the rules of language. The semantic analyzer produces an annotated syntax tree as an output.

#### Intermediate Code Generation
It produces a program for some abstract machine. It is in between the high-level language and the machine language.
 
 Execution Instruction:
 ```
lex scanner.l
yacc parser.y
gcc y.tab.c -ll -ly -w
./a.out test1.c

 
 ```

### Team Members

- Naladala Indukala (15CO230)
- R. Aparna (15CO236)

