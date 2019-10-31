#!/bin/bash
timestamp() {
  date -u +%Y-%m-%d-%H:%M:%S
}
timefile=$(timestamp)
echo $(timestamp)
echo $timefile

read -p "Operation complete. Press ENTER to exit"

