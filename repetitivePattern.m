% I = imread('testImages\bird.bmp');
I = imread('data\IM_04.jpg');
[I,estDoS] = imnlmfilt(I);
% 
%  I = imread('IM_05.jpg');
img = rgb2gray(I);
% level = graythresh(img);
% img = (imbinarize(img, level));
load durer
White = max(max(img));
imagesc(img)
% imagesc(BW)
colormap gray
title('Original')

rect = drawrectangle().Vertices;
x = int16(rect(1, 2));
X = int16(rect(2, 2));
y = int16(rect(1, 1));
Y = int16(rect(3, 1));

% x = 250;
% X = 380;
% 
% y = 750;
% Y = 880;
% 
% x = 50;
% X = 180;
% 
% y = 50;
% Y = 180;

szx = x:X;
szy = y:Y;
Sect = img(szx,szy);

kimg = img;
kimg(szx,szy) = White;

kumg = 255*ones(size(img));
kumg(szx,szy) = Sect;

subplot(1,2,1)
imagesc(kimg)
axis image off
colormap gray
title('Image')

subplot(1,2,2)
imagesc(kumg)
axis image off
colormap gray
title('Section')

nimg = img-mean(mean(img));
nSec = nimg(szx,szy);

crr = xcorr2(nimg,nSec);

% [ssr,snd] = max(crr(:));
% [ij,ji] = ind2sub(size(crr), snd);
% [ij,ji] = ind2sub(size(crr),557500);
% figure
% imagesc(rgb2gray(I));
% colormap gray
% h = drawrectangle('Position',[ji1,ij1,ji1 + 500,ij1 + 500],'StripeColor','r');
% h = drawrectangle('Position',[500,500,1000,1000],'StripeColor','r');
[ssr,snd] = maxk(crr(1:1000:end), 10);
snd = snd * 1000;
[ij,ji] = ind2sub(size(crr),snd);

figure
plot(crr(:))
title('Cross-Correlation')
hold on
plot(snd,ssr,'or')
hold off
text(snd*1.05,ssr,'Maximum')

% kimg(ij:-1:ij-size(Sect,1)+1,ji:-1:ji-size(Sect,2)+1) = rot90(Sect,2);
for i =  1 : size(ij)
    
    kimg(ij(i):-1:ij(i)-size(Sect,1)+1,ji(i):-1:ji(i)-size(Sect,2)+1) = kimg(ij(i):-1:ij(i)-size(Sect,1)+1,ji(i):-1:ji(i)-size(Sect,2)+1) - rot90(Sect,2);

end
figure
imagesc(kimg)
colormap gray
title('Reconstructed')
hold on
plot([y y Y Y y],[x X X x x],'r')
hold off
