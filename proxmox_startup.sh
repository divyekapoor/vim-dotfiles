#!/bin/bash
echo "powersave" | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
