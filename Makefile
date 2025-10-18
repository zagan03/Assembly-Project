# ===== Config =====
CC       := gcc
CFLAGS   := -m32 -no-pie -g -O0
BUILD    := build

SRC1     := src/unidimensional.s   # task1 = 1D
SRC2     := src/bidimensional.s    # task2 = 2D

BIN1     := $(BUILD)/task1
BIN2     := $(BUILD)/task2

# Setează aici calea către folderul cu checker-ul oficial (csa/project)
# Poți suprascrie din linia de comandă:  make grade TESTER_DIR=/cale/catre/csa/project
TESTER_DIR ?= ../csa/project
CHECKER     := $(TESTER_DIR)/checker.py

.PHONY: all task1 task2 run1 run2 test clean install_official grade show link_official

# ===== Build =====
all: $(BIN1) $(BIN2)

$(BUILD):
	mkdir -p $(BUILD)

$(BIN1): $(BUILD) $(SRC1)
	$(CC) $(CFLAGS) -o $@ $(SRC1)

$(BIN2): $(BUILD) $(SRC2)
	$(CC) $(CFLAGS) -o $@ $(SRC2)

# ===== Rulează local (cu inputurile tale) =====
run1: $(BIN1)
	./$(BIN1) < tests/input_sample.txt

run2: $(BIN2)
	./$(BIN2) < tests/input_sample.txt

test: all
	./$(BIN1) < tests/input_sample.txt   > $(BUILD)/out_task1_sample.txt
	./$(BIN2) < tests/input_sample.txt   > $(BUILD)/out_task2_sample.txt
	@echo "Outputs in $(BUILD)/"

# ===== Integrare cu testerul oficial =====
# Copiază executabilele lângă checker.py
install_official: all
	@test -f $(CHECKER) || (echo "ERROR: checker.py not found at: $(CHECKER). Set TESTER_DIR to the 'csa/project' path."; exit 1)
	cp $(BIN1) $(TESTER_DIR)/task1
	cp $(BIN2) $(TESTER_DIR)/task2
	chmod +x $(TESTER_DIR)/task1 $(TESTER_DIR)/task2
	@echo "Copied task1 & task2 to $(TESTER_DIR)"

# Rulează checkerul oficial
grade: install_official
	cd $(TESTER_DIR) && python3 checker.py

# Doar arată sumarul/cerințele
show:
	@test -f $(CHECKER) || (echo "ERROR: checker.py not found at: $(CHECKER). Set TESTER_DIR=..."; exit 1)
	cd $(TESTER_DIR) && python3 checker.py -s

# Alternativ la copiere: creează symlink-uri (nu mai copiezi după fiecare build)
link_official: all
	@test -f $(CHECKER) || (echo "ERROR: checker.py not found at: $(CHECKER). Set TESTER_DIR=..."; exit 1)
	ln -sf $(abspath $(BIN1)) $(TESTER_DIR)/task1
	ln -sf $(abspath $(BIN2)) $(TESTER_DIR)/task2
	@echo "Symlinks created in $(TESTER_DIR). Run:  cd $(TESTER_DIR) && python3 checker.py"

# ===== Clean =====
clean:
	rm -rf $(BUILD)
