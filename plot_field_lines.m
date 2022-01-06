function plot_field_lines(u,v,x0,y0,xmin,xmax,ymin,ymax,N,tsim,dt)
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
        quiver(X,Y,U,V,'m')

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