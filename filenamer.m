function [ filestr ] = filenamer( filenumber, filehead )
    numstr = int2str(filenumber);
    if filenumber < 10
        filestr = sprintf('%s000%s.txt',filehead,numstr);
    elseif filenumber < 100
        filestr = sprintf('%s00%s.txt',filehead,numstr);
    elseif filenumber < 1000
        filestr = sprintf('%s0%s.txt',filehead,numstr);
    else
        filestr = sprintf('%s%s.txt',filehead,numstr);
    end

end

