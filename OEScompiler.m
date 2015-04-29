%this program looks at a list of ASCII data with similar file names (ending
%in numerically) from the Mcpherson monochrometer that has
%wavelength in the first column and counts in the second (765x2), compiles
%it by wavelength, OES counts and separated by a column of zeroes the
%background cts. It is then analyzed to find the average OES cts and
%background cts (separated from background cts by a column of zeroes) and
%subtracts the 2 after scaling and outputs it as another ASCII file. Output
%files give:
% 1st column: wavelength
% next set of columns: OES cts
% after first column of zeroes: bkg cts
% after 2nd column of zeroes: analyzed data, 
    %1st column = averaged OES cts
    %2nd column = avereaged bkg cts
    %3rd column = scaled difference between bkg cts and OES cts.
%
% additionally, the code outputs the intensity vs. Energy (IvE) data and 
% peak data for each of the emission into their own files.
%
%Note: to use this code you will need to update the calibration lamp
%equations on or near line 190 and it currently only works for the Ar
%paschen lines listed in the peakfinder.m file.  You can add additional
%lines if appropriate

clear
clc

Thematrix = 0;
peak = 0;
IvE =0;

% user inputs
filehead = 'plot'; %OES file name
filenumlow = 135; %the first number in the file ending numerics for OES data
filenumhigh = 176; %the last number in the file ending numerics for OES data

bkgfilehead = 'plot'; %bkg data file name
bkgfilenumlow = 177; %the first number in the file ending numerics for bkg data
bkgfilenumhigh = 206; %the last number in the file ending numerics for bkg data

filerows = 765; % number of rows in each file to be analyzed

Ar1inttime = 10;
Ar1scans = 2;

Ar2inttime = 30;
Ar2scans = 15;

O2inttime = 30;
O2scans = 10;

runavenum = 5; %must be odd

% Reads in and compiles the OES data points by wavelength into Thematrix
for filenumber = filenumlow : 1 : filenumhigh
    % reading in the files
    filestr = filenamer(filenumber, filehead);
    
    folderfiles = ls(filestr);
    
    % if the file is empty, don't load any data.
    if isempty(folderfiles) > 0
    else
        file = dlmread(filestr);
        
        % finds whether the starting wavelength of the input file matches a
        % wavelength in the main data array
        [X,Y] = find(Thematrix == file(1,1));
        
        matrixsize = size(Thematrix);
        filesize = size(file);
        
        % if there is no matching starting wavelength it appends the new
        % wavelength data to the bottom of the main data array
        if isempty(X) > 0
            if matrixsize(1) == 1
                Thematrix = file;
                datacounter = 1;
            else
                for row = 1 : 1 : filesize(1)
                    Thematrix(matrixsize(1) + row,1) = file(row,1);
                    Thematrix(matrixsize(1) + row,2) = file(row,2);
                end
                datacounter = datacounter+1;
            end
        % if there is a matching starting wavelength it adds the new values
        % to the main data array in the next column
        else
            J = 2;
            while J <= matrixsize(2)
                if Thematrix(X,J) == 0
                    for G = 1:1:filesize(1)
                        Thematrix(X(1) + G - 1 ,J) = file(G,2);
                    end
                    J = matrixsize(2);
                elseif J == matrixsize(2)
                    for G = 1:1:filesize(1)
                        Thematrix(X(1) + G - 1 ,J+1) = file(G,2);
                    end
                end
                J=J+1;
            end
        end
    end
end

%reads in and compiles the bkg counts, adding it to the Thematrix
for bkgfilenumber = bkgfilenumlow : 1 : bkgfilenumhigh
    
    bkgfilestr = filenamer(bkgfilenumber, bkgfilehead);
    
    bkgfolderfiles = ls(bkgfilestr);
    
    if isempty(bkgfolderfiles) > 0
    else
        bkgfile = dlmread(bkgfilestr);
        
        % finds whether the starting wavelength of the bkg data file matches a
        % wavelength in the main data array
        bkgfirstvalue = bkgfile(1,1);
        [X,Y] = find(Thematrix == bkgfirstvalue);
        matrixsize = size(Thematrix);
        
        % sends an error if the background data doesn't align with any of
        % the other data files.
        if isempty(X) > 0
            fprintf('no corresponding data for %s',bkgfilestr)
        % the background data is appended to the main data array by wavelength.
        % The background and data values are separated by a column of 0s.
        else
            J = 2;
            while J <= matrixsize(2)
                if Thematrix(X(1),J) == 0
                    if J == matrixsize(2)
                        for G = 1:1:filesize(1)
                            Thematrix(X(1) + G -1,J+1) = bkgfile(G,2);
                        end
                    else
                        Q =J+1;
                        while Q <= matrixsize(2)
                            if Thematrix(X(1),Q) == 0
                                for G = 1:1:filesize(1)
                                    Thematrix(X(1)+G-1, Q) = bkgfile(G,2);
                                end
                                Q = matrixsize(2);
                            elseif Q == matrixsize(2)
                                for G = 1:1:filesize(1)
                                    Thematrix(X(1)+G-1, Q+1) = bkgfile(G,2);
                                end
                                Q = matrixsize(2);
                            end
                            Q = Q + 1;
                        end
                    end
                    J = matrixsize(2)+1;
                elseif J == matrixsize(2)
                    for G = 1:1:filesize
                        Thematrix(X(1)+G-1 ,J+2) = bkgfile(G,2);
                    end
                    J = matrixsize(2)+1;
                else
                end
                J=J+1;
            end
        end
    end
end

for F = 1:1:datacounter
    %separating the data by wavelength
    savedata = Thematrix((F-1)*filerows+1 : F*filerows,:);
    sdsize = size(savedata);
    R =2;
    while R <= sdsize(2)
        if savedata(1,R) == 0
            if R+1 > sdsize(2)
                finsavedata = savedata(:,1:(R-1));
            elseif savedata(1,R+1) == 0
                finsavedata = savedata(:,1:(R-1));
                R = sdsize(2);
            end
        elseif R == sdsize(2)
            finsavedata = savedata;
        end
        R=R+1;
    end
    
    %calculating the calibration lamp calibration, the values herein are
    %based on calibration lamp data obtained during experiments.
    if finsavedata(1,1) < 596
        lampscaling = -6.552200E-11*finsavedata(:,1).^5 + 1.793346E-07*finsavedata(:,1).^4 - 1.960272E-04*finsavedata(:,1).^3 + 1.069969E-01*finsavedata(:,1).^2 - 2.917315E+01*finsavedata(:,1) + 3.180233E+03;
        if finsavedata(1,1) >= 596
            fprintf('The data using %f nm is near the crossover point between calibration curves, accuracy may fall', finsavedata(1,1))
        end
    elseif finsavedata(1,1) > 600 && finsavedata(1,1) < 830
        lampscaling = -7.122170E-12*finsavedata(:,1).^5 + 2.586077E-08*finsavedata(:,1).^4 - 3.748223E-05*finsavedata(:,1).^3 + 2.711116E-02*finsavedata(:,1).^2 - 9.787102E+00*finsavedata(:,1) + 1.410877E+03;
        if finsavedata(1,1) >= 826
            fprintf('The data using %f nm is near the crossover point between calibration curves, accuracy may fall', finsavedata(1,1))
        end
    else
        lampscaling = -8.809468E-14*finsavedata(:,1).^6 + 4.708891E-10*finsavedata(:,1).^5 - 1.046568E-06*finsavedata(:,1).^4 + 1.238009E-03*finsavedata(:,1).^3 - 8.220876E-01*finsavedata(:,1).^2 + 2.905521E+02*finsavedata(:,1) - 4.269916E+04;
    end
    
    %scaling the OES data to lamp calibration data
    
    counter = 1;
    J = 2;
    finsdsize = size(finsavedata);
    
    while J <= finsdsize(2)
        if finsavedata(1,J) ~= 0
            counter = counter+1;
        else
            J = finsdsize(2);
        end
        J = J+1;
    end
    
    OES = finsavedata(:,2:counter);
    
    for G = 1 : 1 : counter - 1
        OES(:,G) = OES(:,G).*lampscaling;
    end
    
    %calculating bkg values, if they exist
    bkgcounter = counter+2;
    if bkgcounter <= finsdsize(2)
        bkg = finsavedata(:,bkgcounter:finsdsize(2));
        for G = 1 : 1 : finsdsize(2) - bkgcounter + 1
            bkg(:,G) = bkg(:,G).*lampscaling;
        end
        meanbkg = mean(bkg,2);
        
        for G = 1 : 1: counter - 1
            %scaling the bkg to the OES data
            bkgscaling = findbkgscaling(finsavedata, OES, meanbkg, G);
            scaledbkg = meanbkg*bkgscaling;
            OES(:,G) = OES(:,G) - scaledbkg; %subtracting the bkg from the OES data
        end
        finsavedata(:,finsdsize(2)+3) = meanbkg;
    end
    
    % after scaling for the calibration lamp data and subtracting off the
    % background counts, the data is now absolutely calibrated.  Next step
    % is averaging the calibrated data and scaling it to the integration
    % times used to collect each data set.
    aveOES = mean(OES,2);
    intscalingfactor = intscaling(finsavedata(1,1), Ar1inttime, Ar1scans, Ar2inttime, Ar2scans, O2inttime, O2scans);
    finalOES = aveOES*intscalingfactor;
    
    % To smooth out the data a running average is taken.
    lowrun = floor(runavenum/2);
    runaveOES = zeros(765,1);
    
    for G = lowrun+1 : 1 : 765 - lowrun
        runaveOES(G,1) = mean(finalOES(G-lowrun:G+lowrun));
    end
    
    % the peakfinder finds the peak value of the data and the corresponding
    % IvE (intensity vs. Energy). 
    [peak , IvE] = peakfinder(finsavedata(:,1), runaveOES, peak, IvE);
    
    finsavedata(:,finsdsize(2)+2) = lampscaling;
    finsavedata(:,finsdsize(2)+4) = aveOES;
    finsavedata(:,finsdsize(2)+5) = finalOES;
    finsavedata(:,finsdsize(2)+6) = runaveOES;
    
    %saving the wavelength range data to a file, identified by the wavelength
    savewave = num2str(finsavedata(383,1));
    savefile = sprintf('%snm.txt',savewave);
    save(savefile, 'finsavedata', '-ascii', '-tabs');
end

% saving the peak and IvE data to a file 
save('peakvalues', 'peak', '-ascii', '-tabs');
save('lnIvsEnergy', 'IvE', '-ascii', '-tabs');

% Applying a linear fit to the IvE data
fit = polyfit(IvE(:,1),IvE(:,2),1)
   
% -1/slope of the linear fit gives an approximate value for the electron
% temperature of the plasma.
Te = -1/fit(1)

% plots the IvE data along with the fit.
plotfit = polyval(fit,IvE(:,1));

plot(IvE(:,1), IvE(:,2),'o',IvE(:,1),plotfit,'-')