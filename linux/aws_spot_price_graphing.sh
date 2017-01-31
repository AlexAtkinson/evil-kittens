#!/bin/bash
# Generates graphs for spot-price histories.
# Requires the spot price history file(s).
# Spot price history files are generated with...


for file in spot_price*.csv ;
do
  output="$(echo "$file" | sed 's/.csv//g').png"
  type=$(echo "$file" | sed 's/.csv//g' | cut -d'_' -f4)
  od_price=$(grep "$type" instance_od_prices.list | cut -d ',' -f3)
  gnuplot <<- EOF
    set autoscale xfix
    set datafile separator ","
    set terminal png size 2000,800
    set title "Spot Bid Price History"
    set ylabel "Price"
    set xlabel "Time"
    set xdata time
    set timefmt "%Y-%m-%dT%H:%M:%S.000Z"
    set format x "%Y-%m-%d"
    set key left top
    set grid
    set arrow from graph 0,first "${od_price}" to graph 1,first "${od_price}"  nohead lc rgb "#000000" front
    set output "${output}"
    plot "${file}" using 1:2 with histeps  smooth frequency title "${type}"
EOF
done
