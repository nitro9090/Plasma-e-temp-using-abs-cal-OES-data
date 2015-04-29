function [ integrationscaling ] = intscaling( WL, Ar1inttime, Ar1scans, Ar2inttime, Ar2scans, O2inttime, O2scans)
%WL is the wavelength
%wavelengths available: 
%Ar I - 842.4648 nm, 706.7218, 750.3869, 751.4652, 912.2967, 965.7786
if WL > 702 && WL < 707 ||WL > 746 && WL < 752 || WL > 908 && WL < 913 ||WL > 961 && WL < 966
    integrationscaling = Ar2inttime*Ar2scans/(Ar1inttime*Ar1scans);
%Ar II - 457.935 nm, 458.99, 460.957, 472.687, 487.986 
elseif WL > 454 && WL < 461 || WL > 468 && WL < 473 ||WL > 484 && WL < 488
    integrationscaling = 1;
%O II - 844.6 nm, 777 - both of these wavelengths are 3 stacked lines
elseif WL > 838 && WL < 845 || WL > 773 && WL < 778
    integrationscaling = Ar2inttime*Ar2scans/(O2inttime*O2scans);
else
    fprintf('this wavelength could not be scaled for int time/n update intscaling file to make available /n intscaling was set to 1')
    integrationscaling = 1;
end

