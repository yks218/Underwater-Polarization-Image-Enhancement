function cfg = config()

% 示例数据路径（GitHub用）
cfg.path_0   = 'data/example/0.bmp';
cfg.path_45  = 'data/example/45.bmp';
cfg.path_90  = 'data/example/90.bmp';
cfg.path_135 = 'data/example/135.bmp';
cfg.path_raw = 'data/example/raw.bmp';

% 参数
cfg.blocksize = 8;
cfg.c = 0.7;

end