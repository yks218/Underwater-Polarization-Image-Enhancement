function ZI = imblizoom(L,zmf)
[IH,IW,ID] = size(L);
ZIH = round(IH*zmf);
ZIW = round(IW*zmf);
ZI = zeros(ZIH,ZIW,ID);
IT = zeros(IH+2,IW+2,ID);
IT(2:IH+1,2:IW+1,:) = L;
IT(1,2:IW+1,:)=L(1,:,: );IT(IH+2,2:IW+1,:)=L(IH,:,:);
IT(2:IH+1,1,:)=L(:,1,:);IT(2:IH+1,IW+2,: )=L(:,IW,:);
IT(1,1,:) = L(1,1,:);IT(1,IW+2,:) = L(1,IW,:);
IT(IH+2,1,:) = L(IH,1,:);IT(IH+2,IW+2,:) = L(IH,IW,:);
for zj = 1:ZIW
for zi = 1:ZIH
ii = (zi-1)/zmf; jj = (zj-1)/zmf;
i = floor(ii); j = floor(jj);
u = ii - i; v = jj - j;
i= i+ 1;j= j+ 1;
ZI(zi,zj,:) = (1-u)*(1-v)*IT(i,j,:) +(1-u)*v*IT(i,j+1,:) + u*(1-v)*IT(i+1,j,:) +u*v*IT(i+1,j+1,:);
end
end
ZI=uint8(ZI);
end