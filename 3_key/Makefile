# Makefile for Verilog simulation with Icarus Verilog and GTKWave

# Define the source files
SRC_FILES = timer_start.v timer_start_tb.v

# Define the output file
OUTPUT_FILE = wave

# Define the waveform file
WAVEFORM_FILE = $(OUTPUT_FILE).vcd

# Define the simulation command
SIM_CMD = vvp -n $(OUTPUT_FILE) -lxt2

# Default target
all: simulate

# Simulate target
simulate: compile run_simulation view_waveforms

# Compile target
compile:
	iverilog -o $(OUTPUT_FILE) $(SRC_FILES)

# Run simulation target
run_simulation:
	$(SIM_CMD)

# View waveforms target
view_waveforms:
	gtkwave $(WAVEFORM_FILE)

# Clean target (remove generated files)
clean:
	rm -f $(OUTPUT_FILE) $(WAVEFORM_FILE) *.lxt

#Phony target (to prevent name collision)
.PHONY: all simulate compile run_simulation view_waveforms clean
