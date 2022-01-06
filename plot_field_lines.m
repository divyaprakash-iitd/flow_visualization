function plot_field_lines(u,v,x0,y0,xmin,xmax,ymin,ymax,N,tsim,dt)
%plot_field_lines: Plots field lines of fluid flow
% plot_field_lines(u,v,x0,y0,xmin,xmax,ymin,ymax,N,tsim,dt):
%   Plots field lines of fluid flow, Streamlines, Streaklines and Pathlines
%
% input: 
%   u       = A function handle for the x component of the velocity vector
%   v       = A function handle for the y component of the velocity vector
%   x0      = x-coordinate of the starting position of a particle
%   y0      = y-coordinate of the starting position of a particle
%   xmin    = Minimum value of x in the spatial domain to be plotted
%   xmax    = Maximum value of x in the spatial domain to be plotted
%   ymin    = Minimum value of y in the spatial domain to be plotted
%   ymax    = Maximum value of y in the spatial domain to be plotted
%   N       = No. of divisions along each of the 2 dimensions (x and y)
%   tsim    = Time upto which the lines are to be plotted
%   dt      = Time interval
% output:
%   A video file in which the lines represent the following.
%   1. Green solid line : Streakline
%   2. Red dotted line  : Pathline
%   3. Blue solid lines : Streamlines
%   4. Yellow vectors   : Velocity vector field
%
% Author: Divyaprakash
%         Mechanical Engineer
% e-mail: divyaprakash.poddar@gmail.com
% Date  : 06 January 2022

    x       = linspace(xmin,xmax,N);
    y       = linspace(ymin,ymax,N);
    [X,Y]   = meshgrid(x,y);
    xp = x0; yp = y0;
    t = 0;
    figure
    set(gcf,'Position',[1 1 1920 961])
    vid = VideoWriter('flow_lines.avi','Uncompressed AVI');
    open(vid);
    while ((t < tsim) && (xp(end) < (0.99*xmax)) && (yp(end) < (0.99*ymax))) 
        cla(gca)
        t = t + dt;
        U = u(X,Y,t); 
        V = v(X,Y,t);

        % Contour plot
        Umag = sqrt(U.^2+V.^2);
        colormap(gray)
        contourf(X,Y,Umag,N*5,'edgecolor','none')
        
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
        quiver(X,Y,U,V,'y')

        % Pathline
        xTemp = x0 + interp2(X,Y,U,x0,y0)*dt;
        yTemp = y0 + interp2(X,Y,V,x0,y0)*dt;
        x0 = xTemp;
        y0 = yTemp;
        xp = [xp x0];
        yp = [yp y0];

        plot(x0,y0,'ro','MarkerSize',10,'MarkerFaceColor','r')
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
        axis off
        pause(0.05)
        writeVideo(vid,getframe(gcf));
    end
    close(vid)
end