clear; clc; close all;

% Description: Plots streamlines, streaklines and pathlines

%% Define the velocity vector components
w = 2*pi;
u = @(x,y,t) 0.5 + 0.8*x;
v = @(x,y,t) 1.5 + 2.5*sin(w*t) - 0.8*y;

%% Define the domain for visualization
xmin    = 0; 
xmax    = 3;
ymin    = 0; 
ymax    = 3;
N       = 10;

%% Time span for visualization
tmin = 0; 
tmax = 2;
dt = 0.01;

%% Starting position of particle
x0 = 0.5; y0 = 0.5;


%% Plot Streamlines, Streaklines and Pathlines
plot_field_lines(u,v,x0,y0,xmin,xmax,ymin,ymax,N,tmax,dt)