TestSuite;
%% clear command line n
clc;
%% clear worspace's variables
clear;
%% close all figures
close all;
%% runs xUnit tests in "test" package
runtests test -verbose;