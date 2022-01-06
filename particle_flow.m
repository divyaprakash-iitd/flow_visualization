clear; clc; close all;

% Description: Plots streamlines, streaklines and pathlines

w = 2*pi;

u = @(x,y,t) 0.5 + 0.8*x;
v = @(x,y,t) 1.5 + 2.5*sin(w*t) - 0.8*y;

N = 10;
xmin = 0; xmax = 5;
ymin = -1; ymax = 5;
tmin = 0; tmax = 2;
x = linspace(xmin,xmax,N);
y = linspace(ymin,ymax,N);

[X,Y] = meshgrid(x,y);

% Pathline
x0 = 0.5; y0 = 0.5;
xp = x0; yp = y0;
plot(x0,y0,'rx')
dt = 0.01;

for t = tmin:dt:tmax
    
    U = u(X,Y,t); 
    V = v(X,Y,t);

    % Streamlines
    hold on
    startx = x;
    starty = ymin*ones(size(startx));
    streamline(X,Y,U,V,startx,starty)
    starty = y;
    startx = xmin*ones(size(starty));
    streamline(X,Y,U,V,startx,starty)
    startx = x;
    starty = ymax*ones(size(startx));
    streamline(X,Y,U,V,startx,starty)
    quiver(X,Y,U,V)
    
    % Pathline
    xTemp = x0 + interp2(X,Y,U,x0,y0)*dt;
    yTemp = y0 + interp2(X,Y,V,x0,y0)*dt;
    x0 = xTemp;
    y0 = yTemp;
    xp = [xp x0];
    yp = [yp y0];
    
    plot(x0,y0,'ko')
    plot(xp,yp,'r--')
    
    % Streakline
    xs = size(xp); ys = size(yp);
    for i = 1:length(xp)
        xs(i) = xp(i) + interp2(X,Y,U,xp(i),yp(i))*dt;
        ys(i) = yp(i) + interp2(X,Y,V,xp(i),yp(i))*dt;
    end
    plot(xs,ys,'g-')
    
    hold off
    set(gca,'xlim',[xmin, xmax])
    set(gca,'ylim',[ymin, ymax])
    pause(0.05)
    cla(gca)
end