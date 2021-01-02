# first-fit-algorithm
Implementation of Genetic Algorithm to optimize the solution of First Fit Algorithm in Bin Packing Problem

Introduction

In the bin packing problem, objects of different volumes must be packed into a finite number of bins or containers each of volume V which is greater than the largest volume in the object in a way that minimizes the number of bins used. In computational complexity theory, it is a combinatorial NP-hard problem. The decision problem (deciding if objects will fit into a specified number of bins) is NP-complete.

There are many variations of this problem, such as 2D packing, linear packing, packing by weight, packing by cost, and so on. They have many applications, such as filling up containers, loading trucks with weight capacity constraints, creating file backups in media and technology mapping in Field-programmable gate array semiconductor chip design.

First Fit algorithm is one of the many algorithms proposed to find solution to bin packing problem, which provides a fast but often non-optimal solution. In First Fit algorithm, first item is taken and placed into the bin, the algorithm then searches within the whole objects to find any object that fit into the remaining space. If no any object fit into the bin or the bin is tightly packed the bin is then closed and new bin is opened for the remaining objects. This is continued until every object is placed into the bin. Though the algorithm itself was proposed to solve the bin packing problem it can often provide non-optimal result.

In Theory, least number of bins required =  (sum of all individual  volume)/(volume of the bin)

Genetic Algorithms are commonly used to generate high quality solutions to optimization problems. In this project Genetic Algorithm is combined with First Fit algorithm to provide a sufficiently optimized solution to bin packing problem.


Problem Description

Bin Packing Problem is applicable in many applications. One particular example taken in this problem is described here. Consider a cassette tape can hold 60 minutes of recording time and the recordings to be stored in minutes are 12, 16, 23, 31, 25, 27, 9, 11, 15, 7, 52, 48, 25, 43, 26, 4, 4, 5, 5, 7, 7, 34, and 32. The problem now is to find the lowest number of these cassettes which can accommodate all the recordings.


Solution

Genetic Algorithm to find optimal solution of this problem is applied as follows. The recordings to be stored are encoded in an array and population is initialized as numbers from 1 to 23. Each representing an element (recording duration) stored in the array. The fitness is calculated from First Fit algorithm which provides the number of bins required for each individual, lower the number of bins required higher fit the individual is. Reproduction is done and PMX operator is used to generate offspring. The fitness of the offspring is computed and replaces the parents with lower fitness. The process is then repeated until the stopping criteria is met.
