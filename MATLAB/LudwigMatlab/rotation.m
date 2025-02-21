A = imread('simulated_reference2.bmp');
height = size(A,1);           %get image dimensions
len = size(A,2); 
k = 1:1:200;
for i = 1:height
    line = double(A(i,:)); 
end

line;
line2 = double(diag(A))

for i = 1:size(line2,1)
    if line2(i) == 248
        k(i) = i
    end
end
pks = findpeaks(line);


%Y = fft(line2);
%P2 = abs(Y/len);
%P1 = P2(1:len/2+1);
%P1(2:end-1) = 2*P1(2:end-1);


%Q = imrotate(A,45);
%imwrite(Q,'rottest.bmp')