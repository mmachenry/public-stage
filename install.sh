sudo touch /boot/ssh
sudo apt-get install git mpd mpc python-mpd
sudo cp interfaces /etc/network/
sudo cp wpa_supplicant.conf /etc/wpa_supplicant/
git clone https://github.com/mmachenry/public-stage.git
sudo vi /etc/mpd.conf # change bind_to_address from "localhost" to "::"
crontab -e # add crontab.txt lines
sudo raspi-config # set timezone to eastern or whereever we set the schedule for
sudo vi /etc/rc.local # add /etc/init.d/cron start on last line
