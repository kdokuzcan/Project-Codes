k = 16.6; % W/m-K
h = 10; % W/m^2-K
C = 515; % J/kg-K
rho = 7900; % kg/m^3

dx = 0.00635; % m
Lx = 0.3048; % m
Ly = 0.0254; % m

dt = 2.4;

Tinf = 300; % K
Ti = Tinf; 

q = 6098; % W/m^2
Bi = (h*dx)/k;
Fo = (k*dt)/(rho*C*dx.^2);

A = zeros(247); % N246 = Tinf, N247 = q 
A(246,246) = 1;
A(247,247) = 1;
Tp = zeros(247:1); % CONSTANTS MATRIX
for r = 1:245
    Tp(r,1) = Ti;
    Tp(246,1) = Tinf;
    Tp(247,1) = q;
end 

for r = 1:247
    for c = 1:247
		if r == c
			if (r >= 2) && (r <= 48) % FROM N2-N48               
				A(r,c) = 1 - 4*Fo - 2*Bi*Fo; 
				A(r, c + 49) = 2*Fo;
				A(r, c + 1) = Fo;
				A(r, c - 1) = Fo;
				A(r, 246) = 2*Bi*Fo; % Tinf term
                
			end
			if (r == 50) || (r == 99) || (r == 148) % N50, N99, N148
				A(r,c) = 1 - 4*Fo - 2*Bi*Fo;
                A(r, c + 49) = Fo;
				A(r, c - 49) = Fo;
				A(r, c + 1) = 2*Fo; 
				A(r, 246) = 2*Bi*Fo; % Tinf term
                
            end  
			if [(r >= 51) && (r <= 97)] || [(r >= 100) && (r <= 146)] || [(r >= 148) && (r <= 195)] % FROM N51-N97, N100-N146, N148-N195
				A(r,c) = 1 - 4*Fo; 
				A(r, c + 49) = Fo;
				A(r, c - 49) = Fo;
				A(r, c + 1) = Fo;
				A(r, c - 1) = Fo;
                
            end
            if (r == 98) || (r == 147) || (r == 196) % N98, N147, N196
                A(r,c) = 1 - 4*Fo;
                A(r,c - 49) = Fo;
                A(r,c + 49) = Fo;
                A(r,c - 1) = 2*Fo;
                                
            end
            if [(r >= 198) && (r <= 212)] || [(r >= 230) && (r <= 244)] % FROM N198-N212 AND N230-N244
				A(r,c) = 1 - 4*Fo;
				A(r, c - 49) = 2*Fo;
				A(r, c + 1) = Fo;
				A(r, c - 1) = Fo;
                
            end
             if [(r >= 214) && (r <= 228)] % FROM N214-N228
				A(r,c) = 1 - 4*Fo;
				A(r, c - 49) = 2*Fo;
				A(r, c + 1) = Fo;
				A(r, c - 1) = Fo;
				A(r, 247) = (2*dt)/(rho*C*dx); % q term
                
             end
            if r == 1 % UNIQUE
                A(r,c) = 1 - 4*Fo - 4*Bi*Fo;
                A(r,c + 49) = 2*Fo; 
                A(r,c + 1) = 2*Fo;
                A(r, 246) = 4*Bi*Fo; % Tinf term
                
            end 
            if r == 49 % UNIQUE
                A(r,c) = 1 - 4*Fo - 2*Bi*Fo;
                A(r,c + 49) = 2*Fo;
                A(r,c - 1) = 2*Fo;
                A(r, 246) = 2*Bi*Fo; % Tinf term
                
            end
            if r == 197 % UNIQUE
                A(r,c) = 1 - 4*Fo - 2*Bi*Fo;
                A(r,c - 49) = 2*Fo;
                A(r,c + 1) = 2*Fo;
                A(r, 246) = 2*Bi*Fo; % Tinf term
                
            end 
            if r == 213 % UNIQUE
                A(r,c) = 1 - 4*Fo;
                A(r,c - 49) = 2*Fo;
                A(r,c + 1) = Fo;
                A(r,c - 1) = Fo;
                A(r, 247) = (dt)/(rho*C*dx); % q term
                
            end 
            if r == 229 % UNIQUE
                A(r,c) = 1 - 4*Fo;
                A(r,c - 49) = 2*Fo;
                A(r,c + 1) = Fo;
                A(r,c - 1) = Fo;
                A(r, 247) = (dt)/(rho*C*dx); % q term
                
            end
            if r == 245 % UNIQUE
                A(r,c) = 1 - 4*Fo;
                A(r,c - 49) = 2*Fo;
                A(r,c - 1) = 2*Fo;
                
            end 
		end
    end
end

%%%% CORDINANTES %%%%
x = zeros(245,1);
y = zeros(245,1);
ctr = 1;
dy2 = dx*5 - dx;
for cx1 = 1:5;
    dx2 = 0;
    for cx2 = 1:49;
        x(ctr, 1) = dx2;
        if ctr > 196;
            y(ctr, 1) = 0;
        else
            y(ctr, 1) = dy2;
        end
        ctr = ctr + 1;
        dx2 = dx2 + dx;
    end
    dy2 = dy2 - dx;
end

PlotTp = zeros(5,49);
PlotX = zeros(5,49);
PlotY = zeros(5,49);
ctr = 1;
for r = 1:5
    for c = 1:49
        PlotTp(r,c) = Tp(ctr, 1);
        PlotX(r,c) = x(ctr,1);
        PlotY(r,c) = y(ctr,1);
        ctr = ctr + 1;
    end
end

%%% PLOT %%%
contourf(PlotX, PlotY, PlotTp);
set(gca,'DataAspectRatio',[1 1 1])
title(['Temp (K), n=0, t=0s'])
ylabel('Height (m)'), xlabel('Width (m)')
%colorbar('southoutside');
colorbar('Ticks', [300,325,350,375,400,425,450,475,500,525],'Location','southoutside');
caxis([300 525]);
colormap jet;
frame = getframe(1);
im{1} = frame2im(frame);
PlotTp1 = zeros(5,49);
i=1;

while Tp(1,1) < 0.95*481
    hold all
	Tp1 = A*Tp;
    ctr = 1;
    for r = 1:5
        for c = 1:49
            PlotTp1(r,c) = Tp1(ctr, 1);
            PlotX(r,c) = x(ctr,1);
            PlotY(r,c) = y(ctr,1);
            ctr = ctr + 1;
        end
    end
    title(['Temp (K), ', 'Time Step = ' num2str(i)  ,' , Time = ' num2str(dt*i) 's'])
    h = contourf(PlotX, PlotY, PlotTp1);
    drawnow
    frame = getframe(1);
    im{i+1} = frame2im(frame);
    Tp = Tp1;
    i = i+1;
end 

filename = 'TransientPlaneWall.gif'; % Specify the output file name
for k = 1:20820
    [A,map] = rgb2ind(im{k},256);
    if k == 1
        imwrite(A,map,filename,'gif','LoopCount',Inf,'DelayTime',.05);
    else
        imwrite(A,map,filename,'gif','WriteMode','append','DelayTime',.05);
    end
end
