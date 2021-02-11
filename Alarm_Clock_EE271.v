module Alarm_Clock_EE271 (
	clk, 
	pushBtn, 
	switches, 
	led,
	buzzer,
	ps,
	seg0, seg1, 
	seg2, seg3, 
	seg4, seg5,
	segDecimalPoint
);

// Switches
input [9:0] switches;

// Push button
input [1:0] pushBtn;

// Clock
input clk;

// LED's
output reg [9:0] led;
output reg buzzer;
output reg [3:0] ps;

output reg [7:0] seg0;
output reg [7:0] seg1;
output reg [7:0] seg2;
output reg [7:0] seg3;
output reg [6:0] seg4;
output reg [7:0] seg5;
output reg segDecimalPoint;

reg [1:0] currentState;

reg [24:0]counter_pressed, counter_not_pressed;
reg button_state = 1'b1;

reg alarmflag;
reg timerFlag;
reg buzzerFlag;

initial begin
currentState <= 2'b0;
counter_pressed <= 25'b0;
counter_not_pressed <= 25'b0;
end

initial begin
  seg0 = 8'b11_11_11_11;
  seg1 = 8'b11_11_11_11;
  seg2 = 8'b11_11_11_11;
  seg3 = 8'b11_11_11_11;
  seg4 = 7'b1_11_11_11;
  seg5 = 8'b11_11_11_11;
  alarmflag = 0;
  timerFlag = 0;
end

// Global Variables to keep count
reg [25:0] count = 0;
reg [7:0] hours = 0;
reg [7:0] seconds = 0;
reg [7:0] minutes = 0;

reg [7:0] alarm_hours = 0;
reg [7:0] alarm_minutes = 0; // alarm initially set at 1 minute.

reg [7:0] timer_hours = 0;
reg [7:0] timer_minutes = 0;
reg [7:0] timer_seconds = 25'd2;

reg [7:0] stopwatch_hours = 0;
reg [7:0] stopwatch_minutes = 0;
reg [7:0] stopwatch_seconds = 0;

reg [7:0] display_hours = 0;
reg [7:0] display_seconds = 0;
reg [7:0] display_minutes = 0;
//....................................................................................

reg switch_old = 0;

always @ (posedge clk) begin


if(!pushBtn[1]) begin
	hours <= 0;
	minutes <= 0;
	seconds <= 0;
	
	alarm_hours <= 0;
	alarm_minutes <= 0;

	timer_hours <= 0;
	timer_minutes <= 0;
	timer_seconds <= 25'd2;

	stopwatch_hours <= 0;
	stopwatch_minutes <= 0;
	stopwatch_seconds <= 0;
	alarmflag = 0;
	timerFlag = 0;
	segDecimalPoint = 0;
end

else begin
	if((switches[9] == 1'b0)) begin
		if(count == ( 26'b10111110101111000010000000 - 1'b1)) begin // 50 Mhz clock
			count <= 0; // One Second
			
			if(seconds == 6'd59) begin
				seconds <= 0; // Reset to 0
				
				if(minutes == 6'd59) begin
					minutes <= 0; // Reset to 0
					
					if(hours == 6'd23) begin //figure out hour
						hours <= 0; // Reset to 0
					end
					else begin
						hours <= hours + 1;
					end
					
				end
				else begin
					minutes <= minutes + 1;
				end
				
			end
			else begin
				seconds <= seconds + 1;
			end
			
			// ..........
			if(timer_seconds == 6'd00 && timer_minutes != 0) begin
				timer_seconds <= 6'd59;
				
				if(timer_minutes == 6'd00) begin
					timer_minutes <= 0;
					
					if(timer_hours == 6'd00) begin 
						timer_hours <= 0;
					end
					else begin
						timer_hours <= timer_hours - 1;
					end
					
					end
				else begin
					timer_minutes <= timer_minutes - 1;
				end
				
			end
			else begin
			if (timer_seconds != 0) begin
				timer_seconds <= timer_seconds - 1;
				end
			end
			//...........
			// Stopwatch
			// ..........
			if (currentState ==3 && switches[0] == 1) begin
				if(stopwatch_seconds == 6'd00 && stopwatch_minutes != 0) begin
					stopwatch_seconds <= 6'd59;
					
					if(stopwatch_minutes == 6'd59) begin
						stopwatch_minutes <= 0;
						
						if(stopwatch_hours == 6'd23) begin 
							stopwatch_hours <= 0;
						end
						else begin
							stopwatch_hours <= stopwatch_hours + 1;
						end
						
					end
					else begin
						stopwatch_minutes <= stopwatch_minutes + 1;
					end
					
				end
				else begin
					stopwatch_seconds <= stopwatch_seconds + 1;
				end
			end
			//...........
			
		end
		else begin
			count <= count + 1;
			if(count > 26'b01011111010111100001000000) begin
				segDecimalPoint <= 1;
				if ((buzzerFlag && alarmflag) || (buzzerFlag && timerFlag)) begin
					buzzer <= 1;
				end 
				end
			else begin
				segDecimalPoint <= 0;
				buzzer <= 0;
			end
		end
	end

    // Clock Time modification


    if(currentState == 0 && switch_old != pushBtn[0] && !pushBtn[0]) begin
        if(switches[9] == 1'b1)
            if(switches[0] == 0 && switches[1] == 1) begin
                if(hours == 6'd23) begin
						hours <= 0;
					end
					else begin
						hours <= hours + 1;
					end
            end
            else if(switches[0] == 1 && switches[1] == 0) begin
                if(minutes == 6'd23) begin
						minutes <= 0;
					end
					else begin
						minutes <= minutes + 1;
					end
            end
    end
    else if(currentState == 1 && switch_old != pushBtn[0] && !pushBtn[0]) begin
        if(switches[9] == 1'b1)
            if(switches[0] == 0 && switches[1] == 1) begin
                if(alarm_hours == 6'd23) begin
						alarm_hours <= 0;
					end
					else begin
						alarm_hours <= alarm_hours + 1;
						alarmflag <=1;
					end
            end
            else if(switches[0] == 1 && switches[1] == 0) begin
                if(alarm_minutes == 6'd23) begin
						alarm_minutes <= 0;
					end
					else begin
						alarm_minutes <= alarm_minutes + 1;
						alarmflag <=1;
					end
            end
    end
	 else if(currentState == 2 && switch_old != pushBtn[0] && !pushBtn[0]) begin
        if(switches[9] == 1'b1)
            if(switches[0] == 0 && switches[1] == 1) begin
                if(timer_hours == 6'd23) begin
						timer_hours <= 0;
					end
					else begin
						timer_hours <= timer_hours + 1;
						timerFlag <= 1;
					end
            end
            else if(switches[0] == 1 && switches[1] == 0) begin
                if(timer_minutes == 6'd23) begin
						timer_minutes <= 0;
					end
					else begin
						timer_minutes <= timer_minutes + 1;
						timerFlag <= 1;
					end
            end
    end
	 
end

switch_old  <= pushBtn[0];
end

//....................................................................................

always @ (posedge clk or negedge pushBtn[1])
begin
	if(!pushBtn[1])
		begin
		currentState <= 2'b0;
		counter_pressed<= 25'b0;
		counter_not_pressed<= 25'b0;
		end
	
	else
		begin
	
		if(!pushBtn[0] & !button_state)
			begin
			counter_pressed <= counter_pressed + 1'b1;
			end

		else
			begin
			counter_pressed <= 25'b0;
			end

		if(counter_pressed == 25'd2000000)
			begin
			if (switches[9] == 1'b0) begin
				currentState = currentState + 1'b1;
				end
			counter_pressed <= 25'b0;
			button_state = 1'b1;
			end

		if(pushBtn[0] & button_state)
			begin
			counter_not_pressed <= counter_not_pressed + 1'b1;		
			end

		else
			begin
			counter_not_pressed <= 25'b0;
			end

		if(counter_not_pressed == 25'd2000000)
			begin
			counter_not_pressed <= 25'b0;
			button_state = 1'b0;
			end
		end
end


always @ (posedge clk) begin
		if((hours == alarm_hours) && (minutes == alarm_minutes) && (alarmflag == 1) || (0 == timer_minutes) && (0 == timer_seconds) && (timerFlag == 1)) begin
			led = 10'b1111111111;
			buzzerFlag <= 1;
		end
		else begin
			led = 10'b0000000000;
			buzzerFlag <= 0; 
		end
end

always @ (currentState) begin
	case(currentState)
		0: begin 
			display_hours = hours;
			display_minutes = minutes;
			display_seconds = seconds;
			
			if (switches[9] == 1'b1) begin
				ps = {switches[0],switches[1], 1'b0,1'b0};
			end
			else begin
				ps = 4'b0000;
			end
			
			end
		1: begin 
			display_hours = alarm_hours;
			display_minutes = alarm_minutes;
			display_seconds = 0;
			
			if (switches[9] == 1'b1) begin
				ps = {switches[0],switches[1], 1'b0,1'b1};
			end
			else begin
				ps = 4'b0001;
			end
			
			end
		2: begin 
			display_hours = timer_hours;
			display_minutes = timer_minutes;
			display_seconds = timer_seconds;
			
			if (switches[9] == 1'b1) begin
				ps = {switches[0],switches[1], 1'b1,1'b0};
			end
			else begin
				ps = 4'b0010;
			end
			
			end
		3: begin 
			display_hours = stopwatch_hours;
			display_seconds = stopwatch_seconds;
			display_minutes = stopwatch_minutes;
			
			if (switches[0] == 1'b1) begin
				ps = {switches[0],switches[1], 1'b1,1'b1};
			end
			else begin
				ps = 4'b0011;
			end
			
			end
	endcase
end

// 7 seg
always @ (display_hours, display_minutes, display_seconds) begin
  case(display_hours)
		0: {seg5,seg4} =  {8'b11_00_00_00,7'b1_00_00_00};
		1: {seg5,seg4} =  {8'b11_00_00_00,7'b1_11_10_01};
		2: {seg5,seg4} =  {8'b11_00_00_00,7'b0_10_01_00};
		3: {seg5,seg4} =  {8'b11_00_00_00,7'b0_11_00_00};
		4: {seg5,seg4} =  {8'b11_00_00_00,7'b0_01_10_01};
		5: {seg5,seg4} =  {8'b11_00_00_00,7'b0_01_00_10};
		6: {seg5,seg4} =  {8'b11_00_00_00,7'b0_00_00_10};
		7: {seg5,seg4} =  {8'b11_00_00_00,7'b1_11_10_00};
		8: {seg5,seg4} =  {8'b11_00_00_00,7'b0_00_00_00};
		9: {seg5,seg4} =  {8'b11_00_00_00,7'b0_01_00_00};
		10: {seg5,seg4} = {8'b11_11_10_01,7'b1_00_00_00};
		11: {seg5,seg4} = {8'b11_11_10_01,7'b1_11_10_01};
		12: {seg5,seg4} = {8'b11_11_10_01,7'b0_10_01_00};
		13: {seg5,seg4} = {8'b11_11_10_01,7'b0_11_00_00};
		14: {seg5,seg4} = {8'b11_11_10_01,7'b0_01_10_01};
		15: {seg5,seg4} = {8'b11_11_10_01,7'b0_01_00_10};
		16: {seg5,seg4} = {8'b11_11_10_01,7'b0_00_00_10};
		17: {seg5,seg4} = {8'b11_11_10_01,7'b1_11_10_00};
		18: {seg5,seg4} = {8'b11_11_10_01,7'b0_00_00_00};
		19: {seg5,seg4} = {8'b11_11_10_01,7'b0_01_00_00};
		20: {seg5,seg4} = {8'b10_10_01_00,7'b1_00_00_00};
		21: {seg5,seg4} = {8'b10_10_01_00,7'b1_11_10_01};
		22: {seg5,seg4} = {8'b10_10_01_00,7'b0_10_01_00};
		23: {seg5,seg4} = {8'b10_10_01_00,7'b0_11_00_00};
		24: {seg5,seg4} = {8'b10_10_01_00,7'b0_01_10_01};
  endcase

  case(display_minutes)
		0: {seg3,seg2} =  {8'b11_00_00_00,8'b11_00_00_00};
		1: {seg3,seg2} =  {8'b11_00_00_00,8'b11_11_10_01};
		2: {seg3,seg2} =  {8'b11_00_00_00,8'b10_10_01_00};
		3: {seg3,seg2} =  {8'b11_00_00_00,8'b10_11_00_00};
		4: {seg3,seg2} =  {8'b11_00_00_00,8'b10_01_10_01};
		5: {seg3,seg2} =  {8'b11_00_00_00,8'b10_01_00_10};
		6: {seg3,seg2} =  {8'b11_00_00_00,8'b10_00_00_10};
		7: {seg3,seg2} =  {8'b11_00_00_00,8'b11_11_10_00};
		8: {seg3,seg2} =  {8'b11_00_00_00,8'b10_00_00_00};
		9: {seg3,seg2} =  {8'b11_00_00_00,8'b10_01_00_00};
		10: {seg3,seg2} = {8'b11_11_10_01,8'b11_00_00_00};
		11: {seg3,seg2} = {8'b11_11_10_01,8'b11_11_10_01};
		12: {seg3,seg2} = {8'b11_11_10_01,8'b10_10_01_00};
		13: {seg3,seg2} = {8'b11_11_10_01,8'b10_11_00_00};
		14: {seg3,seg2} = {8'b11_11_10_01,8'b10_01_10_01};
		15: {seg3,seg2} = {8'b11_11_10_01,8'b10_01_00_10};
		16: {seg3,seg2} = {8'b11_11_10_01,8'b10_00_00_10};
		17: {seg3,seg2} = {8'b11_11_10_01,8'b11_11_10_00};
		18: {seg3,seg2} = {8'b11_11_10_01,8'b10_00_00_00};
		19: {seg3,seg2} = {8'b11_11_10_01,8'b10_01_00_00};
		20: {seg3,seg2} = {8'b10_10_01_00,8'b11_00_00_00};
		21: {seg3,seg2} = {8'b10_10_01_00,8'b11_11_10_01};
		22: {seg3,seg2} = {8'b10_10_01_00,8'b10_10_01_00};
		23: {seg3,seg2} = {8'b10_10_01_00,8'b10_11_00_00};
		24: {seg3,seg2} = {8'b10_10_01_00,8'b10_01_10_01};
		25: {seg3,seg2} = {8'b10_10_01_00,8'b10_01_00_10};
		26: {seg3,seg2} = {8'b10_10_01_00,8'b10_00_00_10};
		27: {seg3,seg2} = {8'b10_10_01_00,8'b11_11_10_00};
		28: {seg3,seg2} = {8'b10_10_01_00,8'b10_00_00_00};
		29: {seg3,seg2} = {8'b10_10_01_00,8'b10_01_00_00};
		30: {seg3,seg2} = {8'b10_11_00_00,8'b11_00_00_00};
		31: {seg3,seg2} = {8'b10_11_00_00,8'b11_11_10_01};
		32: {seg3,seg2} = {8'b10_11_00_00,8'b10_10_01_00};
		33: {seg3,seg2} = {8'b10_11_00_00,8'b10_11_00_00};
		34: {seg3,seg2} = {8'b10_11_00_00,8'b10_01_10_01};
		35: {seg3,seg2} = {8'b10_11_00_00,8'b10_01_00_10};
		36: {seg3,seg2} = {8'b10_11_00_00,8'b10_00_00_10};
		37: {seg3,seg2} = {8'b10_11_00_00,8'b11_11_10_00};
		38: {seg3,seg2} = {8'b10_11_00_00,8'b10_00_00_00};
		39: {seg3,seg2} = {8'b10_11_00_00,8'b10_01_00_00};
		40: {seg3,seg2} = {8'b10_01_10_01,8'b11_00_00_00};
		41: {seg3,seg2} = {8'b10_01_10_01,8'b11_11_10_01};
		42: {seg3,seg2} = {8'b10_01_10_01,8'b10_10_01_00};
		43: {seg3,seg2} = {8'b10_01_10_01,8'b10_11_00_00};
		44: {seg3,seg2} = {8'b10_01_10_01,8'b10_01_10_01};
		45: {seg3,seg2} = {8'b10_01_10_01,8'b10_01_00_10};
		46: {seg3,seg2} = {8'b10_01_10_01,8'b10_00_00_10};
		47: {seg3,seg2} = {8'b10_01_10_01,8'b11_11_10_00};
		48: {seg3,seg2} = {8'b10_01_10_01,8'b10_00_00_00};
		49: {seg3,seg2} = {8'b10_01_10_01,8'b10_01_00_00};
		50: {seg3,seg2} = {8'b10_01_00_10,8'b11_00_00_00};
		51: {seg3,seg2} = {8'b10_01_00_10,8'b11_11_10_01};
		52: {seg3,seg2} = {8'b10_01_00_10,8'b10_10_01_00};
		53: {seg3,seg2} = {8'b10_01_00_10,8'b10_11_00_00};
		54: {seg3,seg2} = {8'b10_01_00_10,8'b10_01_10_01};
		55: {seg3,seg2} = {8'b10_01_00_10,8'b10_01_00_10};
		56: {seg3,seg2} = {8'b10_01_00_10,8'b10_00_00_10};
		57: {seg3,seg2} = {8'b10_01_00_10,8'b11_11_10_00};
		58: {seg3,seg2} = {8'b10_01_00_10,8'b10_00_00_00};
		59: {seg3,seg2} = {8'b10_01_00_10,8'b10_01_00_00};
		60: {seg3,seg2} = {8'b10_00_00_10,8'b11_00_00_00};
  endcase
  
  case(display_seconds)
		0: {seg1,seg0} =  {8'b11_00_00_00,8'b11_00_00_00};
		1: {seg1,seg0} =  {8'b11_00_00_00,8'b11_11_10_01};
		2: {seg1,seg0} =  {8'b11_00_00_00,8'b10_10_01_00};
		3: {seg1,seg0} =  {8'b11_00_00_00,8'b10_11_00_00};
		4: {seg1,seg0} =  {8'b11_00_00_00,8'b10_01_10_01};
		5: {seg1,seg0} =  {8'b11_00_00_00,8'b10_01_00_10};
		6: {seg1,seg0} =  {8'b11_00_00_00,8'b10_00_00_10};
		7: {seg1,seg0} =  {8'b11_00_00_00,8'b11_11_10_00};
		8: {seg1,seg0} =  {8'b11_00_00_00,8'b10_00_00_00};
		9: {seg1,seg0} =  {8'b11_00_00_00,8'b10_01_00_00};
		10: {seg1,seg0} = {8'b11_11_10_01,8'b11_00_00_00};
		11: {seg1,seg0} = {8'b11_11_10_01,8'b11_11_10_01};
		12: {seg1,seg0} = {8'b11_11_10_01,8'b10_10_01_00};
		13: {seg1,seg0} = {8'b11_11_10_01,8'b10_11_00_00};
		14: {seg1,seg0} = {8'b11_11_10_01,8'b10_01_10_01};
		15: {seg1,seg0} = {8'b11_11_10_01,8'b10_01_00_10};
		16: {seg1,seg0} = {8'b11_11_10_01,8'b10_00_00_10};
		17: {seg1,seg0} = {8'b11_11_10_01,8'b11_11_10_00};
		18: {seg1,seg0} = {8'b11_11_10_01,8'b10_00_00_00};
		19: {seg1,seg0} = {8'b11_11_10_01,8'b10_01_00_00};
		20: {seg1,seg0} = {8'b10_10_01_00,8'b11_00_00_00};
		21: {seg1,seg0} = {8'b10_10_01_00,8'b11_11_10_01};
		22: {seg1,seg0} = {8'b10_10_01_00,8'b10_10_01_00};
		23: {seg1,seg0} = {8'b10_10_01_00,8'b10_11_00_00};
		24: {seg1,seg0} = {8'b10_10_01_00,8'b10_01_10_01};
		25: {seg1,seg0} = {8'b10_10_01_00,8'b10_01_00_10};
		26: {seg1,seg0} = {8'b10_10_01_00,8'b10_00_00_10};
		27: {seg1,seg0} = {8'b10_10_01_00,8'b11_11_10_00};
		28: {seg1,seg0} = {8'b10_10_01_00,8'b10_00_00_00};
		29: {seg1,seg0} = {8'b10_10_01_00,8'b10_01_00_00};
		30: {seg1,seg0} = {8'b10_11_00_00,8'b11_00_00_00};
		31: {seg1,seg0} = {8'b10_11_00_00,8'b11_11_10_01};
		32: {seg1,seg0} = {8'b10_11_00_00,8'b10_10_01_00};
		33: {seg1,seg0} = {8'b10_11_00_00,8'b10_11_00_00};
		34: {seg1,seg0} = {8'b10_11_00_00,8'b10_01_10_01};
		35: {seg1,seg0} = {8'b10_11_00_00,8'b10_01_00_10};
		36: {seg1,seg0} = {8'b10_11_00_00,8'b10_00_00_10};
		37: {seg1,seg0} = {8'b10_11_00_00,8'b11_11_10_00};
		38: {seg1,seg0} = {8'b10_11_00_00,8'b10_00_00_00};
		39: {seg1,seg0} = {8'b10_11_00_00,8'b10_01_00_00};
		40: {seg1,seg0} = {8'b10_01_10_01,8'b11_00_00_00};
		41: {seg1,seg0} = {8'b10_01_10_01,8'b11_11_10_01};
		42: {seg1,seg0} = {8'b10_01_10_01,8'b10_10_01_00};
		43: {seg1,seg0} = {8'b10_01_10_01,8'b10_11_00_00};
		44: {seg1,seg0} = {8'b10_01_10_01,8'b10_01_10_01};
		45: {seg1,seg0} = {8'b10_01_10_01,8'b10_01_00_10};
		46: {seg1,seg0} = {8'b10_01_10_01,8'b10_00_00_10};
		47: {seg1,seg0} = {8'b10_01_10_01,8'b11_11_10_00};
		48: {seg1,seg0} = {8'b10_01_10_01,8'b10_00_00_00};
		49: {seg1,seg0} = {8'b10_01_10_01,8'b10_01_00_00};
		50: {seg1,seg0} = {8'b10_01_00_10,8'b11_00_00_00};
		51: {seg1,seg0} = {8'b10_01_00_10,8'b11_11_10_01};
		52: {seg1,seg0} = {8'b10_01_00_10,8'b10_10_01_00};
		53: {seg1,seg0} = {8'b10_01_00_10,8'b10_11_00_00};
		54: {seg1,seg0} = {8'b10_01_00_10,8'b10_01_10_01};
		55: {seg1,seg0} = {8'b10_01_00_10,8'b10_01_00_10};
		56: {seg1,seg0} = {8'b10_01_00_10,8'b10_00_00_10};
		57: {seg1,seg0} = {8'b10_01_00_10,8'b11_11_10_00};
		58: {seg1,seg0} = {8'b10_01_00_10,8'b10_00_00_00};
		59: {seg1,seg0} = {8'b10_01_00_10,8'b10_01_00_00};
		60: {seg1,seg0} = {8'b10_00_00_10,8'b11_00_00_00};
  endcase
end

endmodule 
