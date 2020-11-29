#!/bin/bash
./erstellen < $1 > result.c
gcc -Wall -pedantic -std=c99 -o $2 result.c