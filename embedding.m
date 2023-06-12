%灰度图像      嵌入与提取过程    效果展示
img=imread("E:\paper-一种增强图像平滑度的可逆信息隐藏方案\experiment-matlab\paper-matlab\高斯的可逆\测试图\1.png");
%for ii=1:4
%img=imread("E:\paper-一种增强图像平滑度的可逆信息隐藏方案\experiment-matlab\paper-matlab\高斯的可逆\测试图\"+num2str(ii)+".png");
%img=rgb2gray(img);
w = fspecial('gaussian',[3,3],1);
% figure(1);imshow(img);title('原图像');
% imgb=double(img(:,:,3));ii
% imgg=double(img(:,:,2));
% imgr=double(img(:,:,1));
embeddingnum=0;
g=double(img);
Gau=Gaussian(g,w);
T=2;
cz=510;
%嵌入算法
b=0;
cz=510;
testpre1=zeros([cz,cz]);
lxtest=zeros([cz,cz]);
ft=zeros([cz,cz]);
for i=1:cz
    for j=1:cz 
        %预测的值
        pre=predict(i+1,j+1,g);%中间的进行预测
        testpre1(i,j)=pre;
        delta=g(i+1,j+1)-double(pre);  %差值0或者-1 其余的不管
        f=g(i+1,j+1);
        g(i+1,j+1)=pre;
        change=0;
        for k=0:2
            for m=0:2
               change=change+(g(i+k,j+m)*w(1+k,1+m));  %滤波的值
            end
        end
        lx=fix(change)-g(i+1,j+1);
        lxtest(i,j)=lx;
        if(delta<=T&&delta>=(-T)) 
            manzu(i,j)=1;
            delta=(delta*2)+b;
            d(i,j)=delta;
            if(pre+delta+lx<=0)
                g(i+1,j+1)=f;
                ft(i,j)=1;                
            else
                g(i+1,j+1)=double(pre)+delta+lx;
                embeddingnum=embeddingnum+1;
            end
       
        elseif(delta<(-T))
            manzu(i,j)=2;
            delta=delta-T;
            d(i,j)=delta;
            if(pre+delta+lx<=0)
                g(i+1,j+1)=f;
                ft(i,j)=1;
            else
                g(i+1,j+1)=double(pre)+delta+lx;
            end
        else  %delta>TH
            manzu(i,j)=3;
            delta=delta+T+1;
            d(i,j)=delta;
            if(pre+delta+lx<=0)
                g(i+1,j+1)=f;
                ft(i,j)=1;
            else
                g(i+1,j+1)=double(pre)+delta+lx;

            end
        end   
    end   
end
imgEmb=g;
% figure(1)
% imshow(uint8(img))
% figure(2)
% imshow(uint8(imgEmb))
imwrite(uint8(imgEmb),"E:\paper-一种增强图像平滑度的可逆信息隐藏方案\experiment-matlab\paper-matlab\高斯的可逆\结果图\"+num2str(ii)+".png")
% ss=ssim(uint8(imgEmb),Gau);
% disp(ss);
%end
testerr=zeros([cz,cz]);
extractnum=0;
disp('------------------extract-------------------');
testpre2=zeros([510,510]);
result=imgEmb;
lxtest1=zeros([510,510]);
for i=1:510
    ii=510-i+1;
    for j=1:510
        jj=510-j+1;
        if(ft(ii,jj)==0)
            
                change=0;
                pre=predict(ii+1,jj+1,result);%中间的进行预测
                pre=double(pre);
                testpre2(ii,jj)=pre;
                f=result(ii+1,jj+1);%保存下原始的值
                result(ii+1,jj+1)=pre;
                for k=0:2
                    for m=0:2
                       change=change+(result(ii+k,jj+m)*w(1+k,1+m));  %滤波的值
                    end
                end
                %result(i+1,j+1)=f;
                lx=fix(change)-result(ii+1,jj+1);
                lxtest1(ii,jj)=lx;
                err=f-double(pre)-lx;
                testerr(i,j)=err;
                if(err<-(2*T))
                    delta=err+T;
                elseif(err>(2*T)+1)
                    delta=err-T-1;
                else   %(-2<=err<=3)
                    b=mod(err,2);
                    %disp(b);
                    extractnum=extractnum+1;
                    delta=(err-b)/2;
                    
                end
                fin=pre+delta;
                result(ii+1,jj+1)=fin;
        end   
    end
end

if(result == double(img))
    disp("提取图像与原图相同");
else
    disp("提取图像与原图不相同");
end

subplot(1,3,1),imshow(img),title('原始图像'); 
subplot(1,3,2),imshow(uint8(imgEmb)),title('携带秘密信息的受保护的载密图像'); 
subplot(1,3,3),imshow(uint8(result)),title('恢复原图'); 

%%
% g=imgg;   %g是个510*510大小的
% for i=1:cz
%     for j=1:cz 
%         %预测的值
%         pre=predict(i+1,j+1,g);%中间的进行预测
%         delta=g(i+1,j+1)-double(pre);  %差值0或者-1 其余的不管
%         f=g(i+1,j+1);
%         g(i+1,j+1)=pre;
%         change=0;
%         for k=0:2
%             for m=0:2
%                change=change+(g(i+k,j+m)*w(1+k,1+m));  %滤波的值
%             end
%         end
%         lx=fix(change)-g(i+1,j+1);
%         if(delta<=T&&delta>=(-T)) 
%             delta=(delta*2)+b;
%             if(pre+delta+lx<=0)
%                 g(i+1,j+1)=f;
%                 ft(i,j)=1;                
%             else
%                 g(i+1,j+1)=double(pre)+delta+lx;
%                 %embeddingnum=embeddingnum+1;
%             end
%        
%         elseif(delta<(-T))
%             delta=delta-T;
%             if(pre+delta+lx<=0)
%                 g(i+1,j+1)=f;
%                 ft(i,j)=1;
%             else
%                 g(i+1,j+1)=double(pre)+delta+lx;
%             end
%         else  %delta>TH
%             delta=delta+T+1;
%             if(pre+delta+lx<=0)
%                 g(i+1,j+1)=f;
%                 ft(i,j)=1;
%             else
%                 g(i+1,j+1)=double(pre)+delta+lx;
%             end
%         end
%     end    
% end
% imggEm=g;
% 
% g=imgb;
% for i=1:cz
%     for j=1:cz 
%         %预测的值
%         pre=predict(i+1,j+1,g);%中间的进行预测
%         delta=g(i+1,j+1)-double(pre);  %差值0或者-1 其余的不管
%         f=g(i+1,j+1);
%         g(i+1,j+1)=pre;
%         change=0;
%         for k=0:2
%             for m=0:2
%                change=change+(g(i+k,j+m)*w(1+k,1+m));  %滤波的值
%             end
%         end
%         lx=fix(change)-g(i+1,j+1);
%         if(delta<=T&&delta>=(-T)) 
%             delta=(delta*2)+b;
%             if(pre+delta+lx<=0||pre+delta+lx>=256)
%                 g(i+1,j+1)=f;
%                 ft(i,j)=1;                
%             else
%                 g(i+1,j+1)=double(pre)+delta+lx;
%             end
%        
%         elseif(delta<(-T))
%             delta=delta-T;
%             if(pre+delta+lx<=0||pre+delta+lx>=256)
%                 g(i+1,j+1)=f;
%                 ft(i,j)=1;
%             else
%                 g(i+1,j+1)=double(pre)+delta+lx;
%             end
%         else  %delta>TH
%             delta=delta+T+1;
%             if(pre+delta+lx<=0||pre+delta+lx>=256)
%                 g(i+1,j+1)=f;
%                 ft(i,j)=1;
%             else
%                 g(i+1,j+1)=double(pre)+delta+lx;
%             end
%         end
%     end
% end
% imgbEm=g;
% g=uint8(g);     %写入文件的时候要把double矩阵转变为uint8类型
%  imwrite(g,"F:\matlabCode\TestPic\高斯的可逆\实验结果图\Pro-2.png");
%%
%%----------------------------计算相似度Corr----------------------
% r1=corr2(img,imgEmb);
%  r2=corr2(imggua,imgEmb);
% % disp("r1=");
% % disp(r1);
%  rate=embeddingnum/262144;
%  disp("rate=");
%  disp(rate);
%   disp("r2=");
%  disp(r2);
%----------------------------计算相似度Corr----------------------
% p=ssim(img,uint8(imgEmb));
% psn=psnr(img,uint8(imgEmb));
% disp("ssim=");
% disp(p);
% disp("psnr=");
% disp(psn);
% sim=sim+p;
% imggua=uint8(imggua);
% imgpro=uint8(imgpro);
% ssimvalgua = ssim(imggua,imgpro);
% ssimvalpro = ssim(img,imgpro);
%%
%-------------------------------计算位置图大小--------------------
% a=0;
% for i=1:510
%     for j=1:510
%         if (ft(i,j)==1)
%             a=a+1;
%             name=['位置为1的坐标   i= ',num2str(i),'j= ',num2str(j)] ;
%             disp(name);
%         end     
%     end
% end
% disp(a);
% [data,I4]=RLEcode(ft);
% realembeddingnum=(embeddingnum-(a*18));
% qianrulv=realembeddingnum/262144;                                                                              