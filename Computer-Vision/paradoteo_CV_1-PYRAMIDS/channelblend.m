function [Lc] = channelblend(A,B)
[La1 La2 La3 La4] = Pyramid_of_image(A);
[Lb1 L22 Lb3 Lb4] = Pyramid_of_image(B);
Lc1 = Blend(La1, Lb1);
Lc2 = Blend(La2,Lb2);
Lc3 = Blend(La3,Lb3);
Lc4 = Blend(La4,Lb4);

Lc2 = imresize(Lc2,2,'bilinear');
Lc3 = imresize(Lc3,4,'bilinear');
Lc4 = imresize(Lc4,8,'bilinear');

Lc = Lc1+Lc2+Lc3+Lc4;
end







