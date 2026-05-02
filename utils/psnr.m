%峰值信噪比
function PSNR=psnr(L,I)
mse_val=mse(L,I);
if mse_val==0
    PSNR=Inf;
else
    max_val=double(max(L(:)));
PSNR=20*log10(max_val/sqrt(mse_val));
end
end