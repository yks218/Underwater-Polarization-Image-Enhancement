%均方误差
function MSE=mse(L,I)
diff=double(L)-double(I);
MSE=mean(diff(:).^2);
end