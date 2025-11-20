%% Script to generate binary values of the angles
N_tot = 16;
N_frac = 14;
fid = fopen('angles.txt','w');
C = 1;
H = 0;
L = 0;
%% Circular coordinates angles
if C == 1 
    for i=0:N_tot-1
        temp = atan(2^-i);
        temp2 = temp * 2^(N_frac);
        binaryValue = round(temp2); % Convert to binary representation
        temp3 = dec2base(binaryValue,2,16);
        fprintf(fid,'%s\n',temp3);
        fprintf('Angle %d: Binary Value = %d\n', i, binaryValue); % Display the result  
    end
end
%% Hyperbolic coordinates angles
if H == 1
    for i=1:N_tot
        temp = atanh(2^-i);
        temp2 = temp * 2^(N_frac);
        binaryValue = round(temp2); % Convert to binary representation
        temp3 = dec2base(binaryValue,2,16);
        fprintf(fid,'%s\n',temp3);
        fprintf('Angle %d: Binary Value = %d\n', i, binaryValue); % Display the result  
    end
end
%% Linear coordinates angles
if L == 1
    for i=0:N_tot-1
        temp = (2^-i);
        temp2 = temp * 2^(N_frac);
        binaryValue = round(temp2); % Convert to binary representation
        temp3 = dec2base(binaryValue,2,16);
        fprintf(fid,'%s\n',temp3);
        fprintf('Angle %d: Binary Value = %d\n', i, binaryValue); % Display the result  
    end
end
fclose(fid)
