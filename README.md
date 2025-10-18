# Low-level Storage Manager (x86 Assembly, AT&T)

Two small executables in x86 Assembly (AT&T) that simulate an OS-like storage module:

- **task1** – 1D storage (contiguous allocation, first-fit)
- **task2** – 2D storage (row-wise placement; defragmentation moves gaps bottom-right)

Supported commands (via STDIN): **ADD / GET / DELETE / DEFRAG**.  
Deterministic I/O using `scanf/printf` and input redirection (`./task < input.txt`).

---

## Project Structure

## Test it with the official tester

 1) clone the checker somewhere on disk

git clone https://github.com/iancuivasciuc/csa

 2) build this project

make

 3) copy binaries next to checker.py

make install_official TESTER_DIR=~/csa/project

 (equivalent to:)
 cp build/task1 ~/csa/project/task1

 cp build/task2 ~/csa/project/task2

 chmod +x ~/csa/project/task1 ~/csa/project/task2

 4) run the checker

make grade TESTER_DIR=~/csa/project

 or:

 cd ~/csa/project && python3 checker.py

 show summaries:

 python3 checker.py -s

 python3 checker.py -s task1
