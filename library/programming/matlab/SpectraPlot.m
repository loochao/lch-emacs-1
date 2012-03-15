function  Spectra = SpectraPlot(data)

CalSpec = load('HeNe_G1120_10ms_WVLength_Only.txt'); %1x1340 the corresponding wavelength for each pixel

xAxis = CalSpec(1,:);
[r,c] = size(xAxis); % [r,c]=[1, 1340]

time = ['0604'];
for Pressure = 475:25:500 %Pressure (Unit:mbar)
  for Power800 = 475:25:500 %The power of 800 (Unit:uJ)
    for Power1080 = 30:10:6000 %The power of 1.08 (Unit:nJ)
        SpecFile = [time '_He' num2str(Pressure) 'mbar_800nm' num2str(Power800) 'uJ+1.08um8ns' num2str(Power1080) 'nJ_G1590S80um_FEL900+Si_30msx10.txt'];
        a = exist(SpecFile,'file');
        if a == 2 %file exists
           SpecArray = load(SpecFile);% 1x1342 matrix, the first two is not data, but heeding
           SpecArray = SpecArray(:,3:1342);
           h = plot(xAxis, SpecArray);
           fname = ['.\' num2str(time) '_He' num2str(Pressure) 'mbar_800nm' num2str(Power800) 'uJ+1.08um8ns' num2str(Power1080) 'nJ_G1590S80um_FEL900+Si_30msx10.png' ]
           ftitle1 = ['2010' num2str(time) '\_He' num2str(Pressure) 'mbar' '\_800nm' num2str(Power800) 'uJ\_1.08um' num2str(Power1080) 'nJ'];
           ftitle2 = ['G1590S80um\_FEL900+Si\_30msx10'];
           ftitle = [{ftitle1; ftitle2}]
           title(ftitle);
           saveas(gcf, fname, 'png'); %save file
           xlabel('wavelength(nm)');
           ylabel('Signal');
        end
    end
  end
end

close all;




