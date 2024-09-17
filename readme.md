
# Lukas Square Pyramid Problem Solver 
This project solves the Lukas Square Pyramid problem using the actor model in Pony. The goal is to find sequences of consecutive numbers where the sum of their squares is a perfect square. The program is designed to run on multi-core machines for optimal performance.


**Instructions to run the code**:


## INSTALLATION
```bash
git clone https://github.com/sahith01-bennett/DOSP_Project1.git
```
## Usage
To compile: (make sure you are in the same directory as the pony file)
```bash
ponyc 
```
To run the compiled binary:
 ```bash
./<binary-name> --lucas <N> <k>
```



## Code Overview

The project consists of three main actors:
- **Worker**: Responsible for calculating whether a sequence of consecutive numbers (within a specified range) forms a perfect square.
- **Boss**: Manages a group of workers by dividing the work into subproblems, distributing them to the workers, and collecting the results.
- **Main**: Handles input parsing and program setup.

The **Utilities** class provides helper functions, including:
- `sqrt`: A binary search algorithm which returns a square root of given number.
## Work Unit Size and Optimization

### Size of the Work Unit
The size of the work unit (number of sub-problems assigned to each worker) plays a crucial role in the overall performance of the program. After testing with different problem sizes and worker distributions, we determined that splitting the total range evenly among the available workers was the best option.
**Explanation**:
- Each worker receives a segment of the problem defined by the range of consecutive numbers they need to process. The range is divided by the total number of workers (let’s say 10 workers).
- The work unit size is calculated as `N / total_workers` (where `N` is the upper limit provided by the user).

### Example:
- For an input of `lukas 1000000 4`, the work unit is split into chunks of `1000000 / 10 = 100000`(here 10 is equal to no of workers). Each worker processes a block of 100,000 consecutive starting numbers. This ensures efficient use of multi-core processors.

## Results for `lukas 1000000 4`

### Output
The program was run with the command  `./DOSP_Project1 --lucas 1000000 4` or `./DOSP_Project1 -L 1000000 4`, which checks sequences of 24 consecutive numbers starting from 1 up to 1000000. Below is an excerpt of the results:

There are no sequence of 4 numbers whose sum of squares is equal to a perfect square in the given range.

### Running Time

The command `time ./DOSP_Project1 --lucas 1000000 4` (this command works only on MacOS) was used to measure the running time of the program. The output of the `time` command is as follows:

./project-1 --lukas 1000000 4  0.21s user 0.01s system 670% cpu 0.032 total

```
real    0.032s   (This is the actual wall-clock time or the real time that the program took to run from start to finish.)
user    0.21s    (This represents the amount of CPU time spent executing user-level code)
sys     0.01s    (This is the amount of CPU time the program spent executing system-level code, which includes kernel-level operations like file I/O, memory allocation, and other operating system services.)
CPU     670%     (This shows how efficiently the CPU was used. The percentage can go above 100% because it reflects parallelism (the number of CPU cores being utilized)). 
```

**CPU to Real Time Ratio**:
```
(user time + sys time)  / real time = 0.22sec / 0.032sec = 6.875 ≈ CPU usage percentage (670%)
```

This means that the program achieved parallelism and it is indicative of good multi-core usage.

## Largest Problem Solved

The largest problem I managed to solve with this implementation was ` ./DOSP_Project1 --lucas 10000000000 24`. This tested sequences of 24 consecutive numbers up to 10000000000. The running time for this was approximately 3 minutes on an 10-core machine, and the program effectively utilized all available cores.

### Output
The program was run with the command  `./DOSP_Project1 --lucas 10000000000 24` or `./DOSP_Project1 -L 10000000000 24`, which checks sequences of 24 consecutive numbers starting from 1 up to 10000000000. Below is an excerpt of the results:


(base) bunny@Sahiths-MacBook-Pro project-1 % time ./project-1 10000000000 24
 
Result format = `<sequence starting number> s = <square root of sum of square of all numbers in the sequence>`
1 s = 70
9 s = 106
20 s = 158
25 s = 182
44 s = 274
76 s = 430
…
…
…

29991872 s = 146929622
34648837 s = 169743998
52422128 s = 256814986
82457176 s = 403956070
196231265 s = 961332998
7828087407 s = 1050833933
All workers completed
./project-1 10000000000 24  1795.27s user 4.82s system 967% cpu 3:06.09 total

### Running Time

The command `time ./DOSP_Project1 --lucas 10000000000 24`(this command works only on MacOS) was used to measure the running time of the program. The output of the `time` command is as follows:

./project-1 10000000000 24  1795.27s user 4.82s system 967% cpu 3:06.09 total
```
real    3m:06s   (This is the actual wall-clock time or the real time that the program took to run from start to finish.)
user    1795.27s (This represents the amount of CPU time spent executing user-level code)
sys     4.82s    (This is the amount of CPU time the program spent executing system-level code, which includes kernel-level operations like file I/O, memory allocation, and other operating system services.)
CPU     967%     (This shows how efficiently the CPU was used. The percentage can go above 100% because it reflects parallelism (the number of CPU cores being utilized). A value of 967% means that, 10 cores were used to execute the program out of the total available cores(10))
```

**CPU to Real Time Ratio**:
```
(user time + sys time) / real time = 1800.09 sec / 186.09 sec = 9.67 ≈ CPU usage percentage (967%)
```

### Performance Results 

N = 10^8 and k = 24

| No. of Worker Actors | Real Time (s) | User time + system time(s) | Ratio ({User + system time} / Real Time) |
|----------------------|---------------|---------------|-------------------------------|
| 10                   | 1.693         | 15.80 + 0.05     | 9.36                          |
| 100                  | 1.650         | 15.93 + 0.04     | 9.67                          |
| 1000                 | 1.647         | 15.89 + 0.05     | 9.67                          |
| 10000                | 1.717         | 16.32 + 0.12     | 9.57                          |
| 100000               | 2.397         | 19.95 + 0.57     | 8.56                          |
| 1000000              | 52.105        | 73.17 + 86.98    | 3.07                          |
                         
We can clearly see that as the number of actors increases from 100,000 to 1,000,000, the system time (which represents the amount of CPU time the program spent executing system-level code, including kernel-level operations like file I/O, memory allocation, and other operating system services) increases significantly. This dramatic rise in system time suggests that the operating system’s overhead in managing such a large number of actors becomes substantial. The scheduler is increasingly burdened with context switching, resource allocation, and managing the communication between actors.

As a result, instead of improving performance, the excessive number of actors leads to inefficiencies, causing the system to spend more time on administrative tasks rather than on executing the actual program logic.

## Conclusion

This implementation of the Lukas Square Pyramid problem uses the actor model to distribute work efficiently across multiple cores. By using a mathematical formula to calculate the sum of squares, we avoid costly loops and ensure the solution scales well with large inputs.
The work unit size split based on the total number of workers (for example, 10 workers). The size of each work unit is determined by N / total_workers, where N is the upper limit given by the user. 

### Future Improvement
- **Utilizing another machine**: Use remote actors and run our program on 2+ machines. Use our solution to solve a really large instance.