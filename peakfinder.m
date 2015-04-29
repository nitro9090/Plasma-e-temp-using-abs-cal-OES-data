function [peak , IvE] = peakfinder(dataWL, runaveOES, peak, IvE)

WL = dataWL(1);

% wavelength, Ek (eV), Aki, gk
linevalues = ...
    ...%Ar I lines
    [842.4648	13.0943793	21500000	5;...
    706.7218	13.30172639	3800000	5;...
    750.3869	13.47937905	44500000	1;...
    751.4652	13.27253813	40200000	1;...
    842.4648	13.0943793	21500000	5;...
    912.2967	12.90652911	18900000	3;...
    965.7786	12.90652911	5430000	3;...
    ...%Ar II lines
    457.93493	19.97178589	80000000	2;...
    458.98976	21.12623768	66400000	6;...
    460.95669	21.14227902	78900000	8;...
    472.68681	19.76151666	58800000	4;...
    473.59055	19.26035863	5.80E+07	4;...
    487.98634	19.67930763	82300000	6;...
    488.90419	19.80034069	1.90E+07    2;...

    %O1 lines
    844.625	19.31846713	32200000	1;...
    844.636	19.31844766	32200000	5;...
    844.676	19.31837836	32200000	3;...
    777.194	19.07052679	36900000	7;...
    777.417	19.07007104	36900000	5;...
    777.539	19.06982048	36900000	3];

if WL > 838 && WL < 845
    [peak, IvE] = IvEcalc(844.625, linevalues, dataWL, runaveOES.*810./(810+1000+935), peak, IvE);
    [peak, IvE] = IvEcalc(844.636, linevalues, dataWL, runaveOES.*1000./(810+1000+935), peak, IvE);
    [peak, IvE] = IvEcalc(844.676, linevalues, dataWL, runaveOES.*935./(810+1000+935), peak, IvE);
    
elseif WL > 702 && WL < 707
    [peak, IvE] = IvEcalc(706.7218, linevalues, dataWL, runaveOES, peak, IvE);

elseif WL > 746 && WL < 752
    [peak, IvE] = IvEcalc(750.3869, linevalues, dataWL, runaveOES, peak, IvE);
    [peak, IvE] = IvEcalc(751.4652, linevalues, dataWL, runaveOES, peak, IvE);
    
elseif WL > 908 && WL < 913
    [peak, IvE] = IvEcalc(912.2967, linevalues, dataWL, runaveOES, peak, IvE);
    
elseif WL > 961 && WL < 966
    [peak, IvE] = IvEcalc(965.7786, linevalues, dataWL, runaveOES, peak, IvE);
    
elseif WL > 454 && WL < 461
    [peak, IvE] = IvEcalc(457.93493, linevalues, dataWL, runaveOES, peak, IvE);
    [peak, IvE] = IvEcalc(458.98976, linevalues, dataWL, runaveOES, peak, IvE);
    [peak, IvE] = IvEcalc(460.95669, linevalues, dataWL, runaveOES, peak, IvE);
    
elseif WL > 468 && WL < 473
    [peak, IvE] = IvEcalc(472.68681, linevalues, dataWL, runaveOES, peak, IvE);
    [peak, IvE] = IvEcalc(473.59055, linevalues, dataWL, runaveOES, peak, IvE);
    
elseif WL > 484 && WL < 488
    [peak, IvE] = IvEcalc(487.98634, linevalues, dataWL, runaveOES, peak, IvE);
    [peak, IvE] = IvEcalc(488.90419, linevalues, dataWL, runaveOES, peak, IvE);
    
elseif WL > 773 && WL < 778
    [peak, IvE] = IvEcalc(777.194, linevalues, dataWL, runaveOES, peak, IvE);
    [peak, IvE] = IvEcalc(777.417, linevalues, dataWL, runaveOES, peak, IvE);
    [peak, IvE] = IvEcalc(777.539, linevalues, dataWL, runaveOES, peak, IvE);

else
    fprintf('this line is not in the database')
end

end

function [peak, IvE] = IvEcalc(cenWL, linevalues, dataWL, runaveOES, peak, IvE)
    [found,Y] = find(linevalues == cenWL);
    lowbound = round(10*(cenWL-.2))/10;
    highbound = round(10*(cenWL+.2))/10;
    [beg,Y] = find(dataWL == lowbound);
    [ending,Y] = find(dataWL == highbound);
    if peak(1,1) == 0;
        updrow = 1;
    else
        updrow = size(peak) + 1;
    end
    peak(updrow,1) = linevalues(found,1);
    peak(updrow,2) = max(runaveOES(beg(1):ending(1)));
    IvE(updrow,1) = linevalues(found,2);
    IvE(updrow,2) = log(peak(updrow,2)*linevalues(found,1)*10^-9/(linevalues(found,3)*linevalues(found,4)));
end