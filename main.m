clear; clc;

% 1. 读取配置
cfg = config();

% 2. 读取图像
I1 = im2double(imread(cfg.path_0));
I2 = im2double(imread(cfg.path_45));
I3 = im2double(imread(cfg.path_90));
I4 = im2double(imread(cfg.path_135));
Ior = im2double(imread(cfg.path_raw));

% 3. 调用算法
L = compute_descatter(I1, I2, I3, I4, Ior, cfg);

% 4. 显示结果
imshow(L);
title('Descattering Result');