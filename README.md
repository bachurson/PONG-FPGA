# UEC2_PONG_PROJECT


# About the project PONG

Welcome to our GitHub repository for our classic Pong game project! In this project, we've taken the traditional Pong game and added several exciting new features to enhance the gameplay experience. Our implementation is written in SystemVerilog and utilizes the Basys 3 FPGA development board.

Project Highlights
Our project is centered around the classic Pong game but with a twist. We've designed three distinct gameplay modes, each offering a unique and engaging experience. Gameplay modes are set by 1-3 switches on board.

1. Single-Player Mode with challenging AI.
* The first gameplay mode features a single-player experience with a challenging AI opponent. We've crafted the AI to provide a tough challenge, yet it's beatable with skillful play. This mode is perfect for improving your Pong skills.

2. Multiplayer Mode for intense battles.
* In addition to the single-player mode, we've also implemented a thrilling multiplayer mode. Grab a friend who also has a Basys 3 FPGA board, and you can enjoy head-to-head Pong matches. Compete against each other to see who's the ultimate Pong champion!

3. Innovative racket control using distance sensor.
* One of the standout features of our game is the ability to control your racket using the HCSR04 distance sensor. As you move closer or farther from the sensor, your racket will respond accordingly. This unique control mechanism adds an extra layer of excitement and challenge to the game.

## Technical Details
We've ensured that our game not only delivers engaging gameplay but also incorporates interesting technical aspects:

UART Communication: Control of the rackets and transmission of match scores are facilitated through UART communication protocols.

Physics and Gameplay: The game physics are thoughtfully designed. Ball-to-wall collisions adhere to real-world physics principles, while ball-to-racket collisions are influenced by controlled randomness. By hitting the ball at the edge of the racket, players can increase the ball's speed and make its trajectory less predictable.

Winning the Match
The objective of the game is to reach a score of 9 points. Points are scored when the ball goes beyond the opponent's racket and hits the edge of the screen. Be strategic in your gameplay to outsmart your opponent and secure victory!

Visuals and Hardware Setup
The game's visuals are displayed on a monitor using a VGA connection, with a refresh rate of 60Hz and a resolution of 1024 x 768. To set up the hardware correctly, refer to the constraints and find .xdc file to connect to the appropriate port configurations for the Basys 3 board, as detailed in the Basys 3 Reference Manual. https://digilent.com/reference/_media/basys3:basys3_rm.pdf

## Video Demonstration (In Polish)
For a comprehensive demonstration of our project's functionality, we've prepared a video in the Polish language. In this video, you'll see the game in action and gain insights into its features and controls. You can watch the video by following the link here

.

# How to use the available scripts

## Cloning the Repository

```bash
git clone git@github.com:agh-riscv/uec2_lab1
```

**All commands should be executed from the main project folder** 

## Initializing the Environment

To start working with the project, open a terminal in the project folder and initialize the environment:

```bash
. env.sh
```

After that, while remaining in the main folder, you can execute available tools:

* `run_simulation.sh`
* `generate_bitstream.sh`
* `program_fpga.sh`
* `clean.sh`

These tools are described below.

## Running Simulations

Simulations are launched using the `run_simulation.sh`.


### Available Options for `run_simulation.sh`

* Display a list of available tests:

  ```bash
  run_simulation.sh -l
  ```

* Run simulations in text mode:

  ```bash
  run_simulation.sh -t <nazwa_testu>
  ```

* Run simulations in graphical mode:

  ```bash
  run_simulation.sh -gt <nazwa_testu>
  ```

* Run all simulations:

  ```bash
  run_simulation.sh -a
  ```

## Generating Bitstream

```bash
generate_bitstream.sh
```

This script initiates the generation of the bitstream, which will ultimately be located in the  `results` folder. It then checks synthesis and implementation logs for any warnings or errors and copies their content to the `results/warning_summary.log` file if they occur.

## Programming the Basys3 FPGA with Bitstream

```bash
program_fpga.sh
```

To successfully program the FPGA with a bitstream, the  `results` folder must contain **only one** file with the `.bit` extension.

## Cleaning the Project

```bash
clean.sh
```

The purpose of this script is to remove all temporary files generated by the tools. These files must be listed in `.gitignore`, and the project must have a initialized git repository (which is done by  `env.sh`).

Additionally, the simulation and bitstream generation scripts, whenever executed (assuming the project has a git repository initialized), delete the results of previous operations before launching new ones.

## Running the Project in Vivado GUI Mode

To open the built project in Vivado GUI mode (i.e., after executing `generate_bitstream.sh`), navigate to the `fpga/build` folder and execute the following command within it:

```bash
vivado <nazwa_projektu>.xpr
```

## In Case of Simulation or Bitstream Generation Failure

If simulation or bitstream generation fails, the reason can often be found by reading the terminal log, paying particular attention to lines containing ERROR. Often, the most valuable information can be found by looking for the first occurrence of an ERROR.

If, after executing a tool, you see the following in the terminal:

```bash
Vivado%
```

This indicates that the script has successfully launched Vivado in text mode. However, there may be an issue with source files or they might not be found. To exit Vivado, simply enter the following in the terminal:

```tcl
exit
```

If a thorough review of the logs did not yield a solution, you can try launching the graphical mode instead of closing Vivado. In this case, when you see `Vivado%` in the terminal, enter:

```tcl
start_gui
```

To interrupt a running process, you can use the <kbd>Ctrl</kbd>+<kbd>C</kbd> combination.

### Folder **fpga**

This folder contains files strictly related to the FPGA. The file  `fpga/rtl/top_pong_basys3.sv` contains an instance of the functional project's top (`rtl/top_pong.sv`) as well as FPGA-specific IP blocks. It also facilitates mapping functional project ports to physical connections on the PCB.

### Folder **rtl**

This is where the synthesizable project files are located, not directly related to the FPGA. Among them is the top-level module, which has a purely structural design (meaning it contains instances of submodules and connects them with wire connections).