function h = h_generate_2d(r_h,r_l,c,x,y,D_0,D_1)
    h = (r_h-r_l)*(1-exp(-c*(x.^2+y.^2)/(D_0^2+D_1^2)))+r_l;
end