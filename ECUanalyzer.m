%  Name(s): (of BOTH students if working in a group!): Samuel Masten -- no partner
%  Email(s): samasten@ncsu.edu
%  Date: 09-09-21
%  Lab Section # (make sure to include both section #s if different): 001
%  Project 1: Engine Control Unit Analyzer, Fall 2021
clc ; clear ; close;

%% 2.2

%using input function to ask the user to choose a csv file
FileChosen = input('File to Analyze\n    (1) test01.csv\n    (2) test02.csv\n    (3) test03.csv\nEnter Option: ');


%using readmatrix to load each of the csv files
Test01 = readmatrix('test01.csv');
Test02 = readmatrix('test02.csv');
Test03 = readmatrix('test03.csv');

%using an if/elseif statement to choose the csv file based on which one they picked
if FileChosen == 1
    FileToUse = Test01; %If they chose 1 we set the FileToUse equal to the csv file for 1
    FileCSV = 'test01.csv'; %for the printf function below
elseif FileChosen == 2
    FileToUse = Test02;
    FileCSV = 'test02.csv';
else %if they didnt choose 1 or 2 we know they chose 3, no need to specify 3
    FileToUse = Test03;
    FileCSV = 'test03.csv';
end %need to end the if/elseif statement

%% 2.3

%assigning variables to each column from the table
Time = FileToUse(:,1);
RPM = FileToUse(:,2);
FuelFlow = FileToUse(:,3);
Coolant = FileToUse(:,4);
Battery = FileToUse(:,5); %making sure to suppress output with a semicolon
OilPressure = FileToUse(:,6);
FuelPressure = FileToUse(:,7);
PedalPosition = FileToUse(:,8); %column 8 is pedal position so we extract all rows from column 8

fprintf('***********************************************\nAnalyzing file %s\n***********************************************\n',FileCSV)
%printing the analyzing display using an fprintf functiona and referencing the variable FileCSV

% A.

[MaxRPM,IndexRPM] = max(RPM); %finding the max RPM and its index (spot)
TimeRPM = Time(IndexRPM); %using the index to find the time for the max RPM
fprintf('\t     Max RPM %10.4f, at %.2f seconds\n',MaxRPM,TimeRPM); %printing the info to the command window

%B.

[MaxCoolant,IndexCoolant] = max(Coolant); %using max function again but this time for the coolant
TimeCoolant = Time(IndexCoolant); %indexing for the time of the max coolant
fprintf('  Max Coolant Temp(F) %9.4f at %.2f seconds\n',MaxCoolant,TimeCoolant); %printing max coolant and time of max coolant

%C.

[MinOil,IndexOil] = min(OilPressure); %to find the minimum oil pressure we use the min function instead of max
TimeOil = Time(IndexOil); %we can index the time same as we did with the maximums
fprintf('Min Oil Pressure(PSI) %9.4f at %.2f seconds\n',MinOil,TimeOil); %referencing the MinOil and TimeOil variables and displaying them

%D.

AvgCoolant = mean(Coolant); %using the mean function to find the mean coolant temp
fprintf('  Avg Coolant Temp(F) %9.4f\n',AvgCoolant); %printing the Average Coolant to the window

%E.

AvgBattery = mean(Battery); %finding the average battery voltage using the mean function
fprintf(' Avg Battery Volatage %9.4f\n',AvgBattery); %printing AvgBattery below AvgCoolant

%F.

TimeSec = FileToUse(end,1); %finding the very last data point in the Time column
TotalTimeMins = TimeSec/60; %converting the time to minutes by dividing by 60
fprintf('\n\tTest Duration %.2f minutes.\n',TotalTimeMins);

%% 2.4

%A.

RawPedalPos = (PedalPosition/100).*1024;
%calculating the Raw Pedal Position using the formula

figure(1)
plot(Time,RawPedalPos,'r-'); %plotting x and y and making red line
title('Raw Pedal Position vs. Time');
xlabel('Time (sec)'); %adding an x label
ylabel('Raw Pedal Position');
grid on; %turning on the grid

%B.

figure(2) 
%need to start a new plot so we don't overwrite the first one

CoolantCels = (Coolant-32)*(5/9); %converting Coolant Temps to Celsius
subplot(2,2,1); %first of 4 subplots
plot(Time, CoolantCels,'g-'); %plotting x and y and making a green line graph
title('Coolant Temperature vs. Time');
xlabel('Time (sec)');
ylabel('Coolant Temperature ({\circ}C)'); %using /circ to insert a degree symbol
grid on;

subplot(2,2,2);
plot(Time,OilPressure,'m-'); %plotting a straight magenta line
title('Oil Pressure vs. Time');
xlabel('Time (sec)');
ylabel('Oil Pressure (psi)');
grid on %turning on grid

subplot(2,2,3); %using the third subplot spot
plot(Time,Battery,'c-'); %plotting a cyan line
title('Battery Voltage vs. Time');
xlabel('Time (sec)');
ylabel('Battery Voltage (volts)'); %setting y label
grid on %setting grid to on

subplot(2,2,4);
plot(Time,FuelPressure,'k-'); %setting the plot as a black line
title('Fuel Pressure vs. Time'); %putting a title on the plot
xlabel('Time (sec)'); %labeling the x
ylabel('Fuel Pressure (psi)'); %labeling the y
grid on %turning on grid 

%C.

vec = PedalPosition'; %turning the column into a row vector

vecIdle = vec <= 0.05; %finding which are true for being in idle
SumIdle = sum(vecIdle); %taking the sum since all true values will be 1

vecFull = vec >= 0.95;
SumFull = sum(vecFull); %adding up all the logical true values for being in Full

vecBetween = vec < 0.95 & vec > 0.05;
SumBetween = sum(vecBetween); %adding up all the logical true values for being in between

y = [SumIdle SumFull SumBetween]; %creating a vector of the sums to enter into bar(y) function

figure(3) %creating a third figure as to not overwrite the pervious 2
bar(y,'r'); %plotting the y vector and adding color red
title('Pedal Position Bar Graph');
ylabel('Time (sec)'); %adding a label on the y-axis
grid on; %leaving grid on
set(gca, 'XTickLabel', {'Idle','InBetween','Full'});




