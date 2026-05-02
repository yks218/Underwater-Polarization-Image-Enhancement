%结构相似度指数
function SSIM= ssim(L,I)
k1 = 0.01;
k2 = 0.03;
l= 255;
C1 = (k1 * l)^2;
C2 = (k2* l)^2;
mu1 = mean2(L);
mu2 = mean2(I);
sigma1 = std2(L);
sigma2 = std2(I);
cov12= cov(L,I);
SSIM = ((2*mu1*mu2+C1)*(2*cov12 +C2))/((mu1^2 + mu2^2 +C1)*(sigma1^2 + sigma2^2 + C2));
end