function L = compute_descatter(I1, I2, I3, I4, Ior, cfg)

S0=(I1+I2+I3+I4)/2;
S1=(I1-I3);
S2=(I2-I4);
I=S0;
P1=sqrt(S1.^2+S2.^2)./S0;
Ia=I.*(1+P1)/2;
Ii=I.*(1-P1)/2;
I=Ia+Ii;


delt_I2=(P1).*I;

MAX1=max(max(delt_I2));
MIN1=min(min(delt_I2));
delt_I2=(delt_I2-MIN1)./(MAX1-MIN1);

delt_I2=imadjust(delt_I2,[0.1 1],[0 1],0.45);
delt_I2=imsharpen(delt_I2,'Amount',5,'Radius',2);

[m,n]=size(delt_I2);

blocksize = cfg.blocksize;%分块处理
blocknum1=floor(m/blocksize);
blocknum2 =floor(n/blocksize);
llength =blocknum1*blocksize;
height =blocknum2*blocksize;
%处理的宽度像素数
A=zeros(blocknum1,blocknum2);
ff = delt_I2(1:llength,1:height);%生成一个用来原图副本(去除多余像素的)
%开始分块处理
for k = 1:blocknum2
for h = 1:blocknum1
%生成模板
block = zeros(size(ff));%将模板初始化为0
lini = 1 + blocksize * (h - 1);
hini = 1 + blocksize * (k - 1);
x = lini:(lini + blocksize - 1);
y = hini:(hini + blocksize - 1);
%分块的第一个像素在原图中的坐标
%生成分块长、宽坐标序列
%将模板上需要进行分块的部分转换成1，用来提取该分块
block(x,y) = 1;
%提取分块
ff = im2double(ff);
%原图转换为double类型，保证和模板black同类型以做点乘
block = block .* ff;
%将原图投影在模板上
block =block(x,y);
%%%%%%%%%%%%%%%%对进进于处里%%%%%%%%%%%%%%%%%%%%%%%
%块的像素总数
a=blocksize * blocksize;
%将块的矩阵中的数重新排列为一行a列的一维矩阵
B=reshape(block,[1,a]);
C=sort(B,'ascend');
%对矩阵B进行升序排列，即从小到大排列
b=floor(a/4);
%b为一维矩阵1/4处的长度
D=C(1,b:a) ;
%D为一维矩阵后3/4的部分
%A(h,k)为D的平均值，A为背景模板矩阵
A(h,k)=mean(D);
end
end
A=im2uint8(A);
%对A进行差值放大，放大后的矩阵与ff一样，此时为图像背景矩阵
A=imblizoom(A,blocksize);
I0=im2double(A);
%I8为背景矩阵
%原图矩阵变为double类型
I1=im2double(delt_I2);
c = cfg.c;
%系数可调
III=zeros(llength, height);
for i=1:llength
%定义I提高运算速度
for j=1:height
III(i,j)=I1(i,j)*c/I0(i,j);
%灰度校正公式
end
end
im1=im2uint8(delt_I2);
%结果是去掉多余像素的，可以加回来，但多余像素未作处理

rh = 0.5;
rl = 0.1;
D0 = 10;
c1 = 0.3;
%读取图片并进行傅立叶变换
max0 = max(I(:));
min0 = min(I(:));
img = log(I+1e-10);
img_f = fftshift(fft2(img));
%获取滤波器
[h,w] = size(img_f);
[x2,y2] = meshgrid(-w/2:w/2,-h/2:h/2);
H = h_generate_2d(rh,rl,c1,x2,y2,D0,D0);
H = imresize(H,[h,w]);
%进行频域滤波
img_f_filter = img_f.*H;
%显示频谱
%反变换到空域
img_out1 = real(ifft2(ifftshift(img_f_filter)));
img_out2 = exp(img_out1);
img_out3 = (img_out2-min(img_out2(:)));
img_out4 = img_out3/max(img_out3(:));
img_out=img_out4*(max0-min0)+min0;
N1=numel(img_out);
K=N1*0.05;
k=round(K);
t1=sort(img_out(:));
[x1,y1]=find(img_out<=t1(k),k);%取最亮＋最暗反射最小的1%
for ii = 1:length(x1)
mat1(ii) = Ia(x1(ii),y1(ii)) ; %取最亮的反射最小区域
end
Ba=(sum(mat1(:)))/(length(x1));%求最亮背景区域
for ii = 1:length(x1)
mat2(ii) = Ii(x1(ii),y1(ii)) ; % 取最暗的反射最小区域 
end
Bi=(sum(mat2(:)))/(length(x1));%求最亮背景区域
A=Ba+Bi;%A∞=B∥＋B⊥
%A=0.4;
dB=Ba-Bi;
po=dB/A;%P偏振度
P=po*2.5;%修正
t=1-(Ia-Ii)./(P*A);%透射率
% =========================
% 金属区域处理（新增部分）
% =========================

% 1. 限制t，避免异常
t(t < 0.2) = 0.2;

% 2. 找到金属区域（低透射率）
[um, vm] = find(t == 0.2);

% 3. 重新定义偏振度（提高，避免金属P太小）
P_metal = po * 1.8;   % 可以调 1.5~2.5

% 4. 重新计算透射率
tt1 = 1 - (Ia - Ii) ./ (P_metal * A);

% 防止异常
tt1(tt1 < 0.2) = 0.2;

% 5. 用新的透射率恢复金属区域
L_metal = (I - A*(1 - tt1)) ./ tt1;

% =========================
% 后处理（可选增强）
% =========================
L_metal = mat2gray(L_metal);
L_metal = adapthisteq(L_metal,'NumTiles',[15 15],'ClipLimit',0.01);
L_metal = imadjust(L_metal,[0 0.9],[0 1],0.6);
L_metal = imsharpen(L_metal,'Amount',1.5,'Radius',1.5);

% =========================
% 6. 替换回原图（核心）
% =========================
for k = 1:length(um)
    L(um(k), vm(k)) = L_metal(um(k), vm(k));
end

% =========================
% 最终归一化
% =========================
L = mat2gray(L);