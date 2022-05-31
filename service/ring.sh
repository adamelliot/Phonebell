#! /bin/bash

relay_gpio=6

gpiofs=/sys/class/gpio
gpio_file=$gpiofs/gpio$relay_gpio

ring_on=0.66
ring_off=0.4
rings=4

if [ ! -d $gpiofs ]; then
    echo "GPIO not found, won't ring bell."
    exit
fi

if [ -f $gpio_file ]; then
    echo "Already ringing."
    sleep $(((ring_off + ring_on) * rings))
    echo $relay_gpio > $gpiofs/unexport

    exit
fi

echo $relay_gpio > $gpiofs/export
echo out > $gpio_file/direction

i=1
while [ $i -le $rings ]
do
    echo 1 > $gpio_file/value
    sleep $ring_on
    echo 0 > $gpio_file/value
    sleep $ring_off
    ((i++))
done

echo 0 > $gpio_file/value
echo in > $gpio_file/direction
echo $relay_gpio > $gpiofs/unexport
