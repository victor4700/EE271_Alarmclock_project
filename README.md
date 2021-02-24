# Alarm_Clock_EE271

This is a simple alarm clock includes normal mode (display time) -> alarm mode -> timer mode (count down) -> stopwatch mode (count up). The hardware components used in this project are arduino uno board, arduino LCD display, and DE10-Lite FPGA (Intel).


**Arduino Code is in Arduino Foler**


Schematics:

<p align="left">
  <img src="https://github.com/chyavanphadke/Alarm_Clock_EE221/blob/main/Documents/configuration.png" width="700" title="hover text">
</p>


Operations:


Buttons | Meaning
------------ | -------------
SW[9] = set | Minutes Increament
SW[0] = min| Hours Increament
SW[1] = hour| Minutes Increament
.|.
KEY[0]   (Push button 0)| Mode
KEY[1]   (Push button 1)| Reset






**State 0 =>  Reset state (Timer Display)**
<ul>
<li> To Change minutes SET == HIIGH SW[0] == HIGH and press Mode Button</li>
<li> To Change hours SET == HIIGH SW[1] == HIGH and press Mode Button</li>
</ul>


**State 1 =>  Alarm state (Alarm Display)**
<ul>
<li> To Change minutes SET == HIIGH SW[0] == HIGH and press Mode Button</li>
<li> To Change hours SET == HIIGH SW[1] == HIGH and press Mode Button</li>
</ul>



**State 2 =>  Timer state (Countdown timer Display)**
<ul>
<li> To Change minutes SET == HIIGH SW[0] == HIGH and press Mode Button</li>
<li> To Change hours SET == HIIGH SW[1] == HIGH and press Mode Button</li>
</ul>


**State 3 =>  Stopwatch state (Alarm Display)**
<ul>
<li> To Start timer  SW[0] == HIIGH</li>
<li> To Start timer  SW[1] == LOW</li>
</ul>

YouTube Demo Link : https://youtu.be/p9FxwnSk0FI
