clear all

path = '/project/agkarsch/Electrons/20161122';

shotsTape = 637:657;
shotsNoTape = 610:630;

shots = [shotsTape; shotsNoTape];

background = 2; % Shot No. 2


p = PointingCam(path);
p.setBackground(background);
p.CorrectBackground = true;

for i = 1:size(shots,1)
    for j = 1:size(shots,2)
        rp = p.getShot(shots(i,j));
        pCharge = rp.Charge;
        pImage = rp.Image{1};
        [mx, my]=meshgrid(1:size(pImage,2), 1:size(pImage,1));
        
        
        cpy = rp.Pointing.CentroidPixY;
        cpx = rp.Pointing.CentroidPixX;   
        pMask = (mx - cpx).^2 + (my - cpy).^2 < 70^2;
        
        im = double(pImage);
        im = im - mean(mean(im(1:100,1:100)));
        im(~pMask) = NaN;
        %pcolor(im); shading flat;
        
        
        pIm = double(pImage(find(pMask)));
        mxf = mx(find(pMask));
        myf = my(find(pMask));
        
        %% Fit: 'untitled fit 1'.
        [xData, yData, zData] = prepareSurfaceData( mxf, myf, pIm );
        
        % Set up fittype and options.
        ft = fittype( 'a*exp(-(x-x0)^2/(2*sx^2) - (y-y0)^2/(2*sy^2)) ', 'independent', {'x', 'y'}, 'dependent', 'z' );
        % For double Gauss: ft = fittype( 'a*exp(-(x-x0)^2/(2*sx^2) - (y-y0)^2/(2*sy^2)) + a2*exp(-(x-x02)^2/(2*sx2^2) - (y-y02)^2/(2*sy2^2)) + c', 'independent', {'x', 'y'}, 'dependent', 'z' );
        opts = fitoptions( ft );
        opts.Display = 'Off';
        opts.StartPoint = [max(max(pImage)) 15 15 rp.Pointing.CentroidPixX rp.Pointing.CentroidPixY];
         
        % Fit model to data.
        [fitresult, gof] = fit( [xData, yData], zData, ft, opts);
        
        sx(i,j) = fitresult.sx/size(shots,2);
        sy(i,j) = fitresult.sy/size(shots,2);
        s(i,j) = sqrt(fitresult.sx*fitresult.sy)/size(shots,2);
        a(i,j) = fitresult.a/size(shots,2);
        figure(2);
        imagesc(im);
        colorbar;
        
        fitSurface = feval(fitresult,mx,my);
        figure(1);
        im(isnan(im))=0;
        plot([sum(fitSurface,1); sum(im,1)]');
        hold on
        plot([sum(fitSurface,2) sum(im,2)]);
        hold off
    end
end

sigma = mean(s,2);
display(['No Tape: sigma = ' num2str(sigma(2))]);
display(['With tape: sigma = ' num2str(sigma(1))]); 
display(['Defocussing factor = ' num2str(sigma(1)/sigma(2))]);