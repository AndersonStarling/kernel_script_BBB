echo "Controling BBB pwm"

cd /sys/class/pwm/pwmchip0/
echo 0 > export
echo 1 > export

echo 1000000 > pwm0/period
echo 1000000 > pwm1/period

echo 500000 > pwm0/duty_cycle
echo 500000 > pwm1/duty_cycle

echo "normal" > pwm0/polarity
echo "normal" > pwm1/polarity

echo "Enable pwm"
echo 1 > pwm0/enable
echo 1 > pwm1/enable
