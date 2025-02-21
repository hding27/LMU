%function makeFRG(fileName)
fileName = 'frog.bmp';
image = imread(fileName);
figure,imagesc(image)
dlmwrite('test.txt',image,'delimiter',' ')
%end