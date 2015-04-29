function [ bkgscaling ] = findbkgscaling(finsavedata, OES, meanbkg, G)
WL = finsavedata(1,1);

if WL > 838 && WL < 845
    [beg,Y] = find(finsavedata == 845);
    [ending,Y] = find(finsavedata == 845.17);
elseif WL > 702 && WL < 707
    [beg,Y] = find(finsavedata == 707.5);
    [ending,Y] = find(finsavedata == 708);
elseif WL > 746 && WL < 752
    if isempty(find(finsavedata == 752.7)) == 0
        [beg,Y] = find(finsavedata == 752.3);
        [ending,Y] = find(finsavedata == 752.7);
    elseif isempty(find(finsavedata == 749.2)) == 0
        [beg,Y] = find(finsavedata == 749.2);
        [ending,Y] = find(finsavedata == 749.5);
    else
        fprintf('could not find an appropriate background for 750.5 nm line, used 1st 20 points for background scaling')
        beg = 1;
        ending = 20;
    end
elseif WL > 908 && WL < 913
    [beg,Y] = find(finsavedata == 911.4);
    [ending,Y] = find(finsavedata == 911.7);
elseif WL > 961 && WL < 966
    [beg,Y] = find(finsavedata == 964.9);
    [ending,Y] = find(finsavedata == 965.2);
elseif WL > 454 && WL < 461
    [beg,Y] = find(finsavedata == 460.3);
    [ending,Y] = find(finsavedata == 460.5);
elseif WL > 468 && WL < 473
    [beg,Y] = find(finsavedata == 474);
    [ending,Y] = find(finsavedata == 474.5);
elseif WL > 484 && WL < 488
    [beg,Y] = find(finsavedata == 487);
    [ending,Y] = find(finsavedata == 487.3);
elseif WL > 773 && WL < 778
    [beg,Y] = find(finsavedata == 776);
    [ending,Y] = find(finsavedata == 776.3);
else
    fprintf('this line is not in the database, averaged first 20 datapin, used 1st 20 points for background scaling')
    beg = 1;
    ending = 20;
end
meanOES = mean(OES(beg(1):ending(1),G));
meanavebkg = mean(meanbkg(beg(1):ending(1)));
bkgscaling = meanOES/meanavebkg;
end

