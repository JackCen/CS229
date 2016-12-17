setup = 0;

%%  resize the test images 
if setup
resize_ratio = 1/16;
for i = 1:999999
    filename = sprintf('/Users/samuco/Downloads/caffe-opencl/cs229/data/test/img_%d.jpg', i);
    if exist(filename, 'file') == 2
        I = imread(filename);
        R = imresize(I, resize_ratio);
        resize_filename = sprintf('/Users/samuco/Downloads/caffe-opencl/cs229/data/resize/img_%d.jpg', i);
        imwrite(R, resize_filename);
        i
    end
end


imgNumber = 79726;
imgSize = 40*30;


%%  reshape resiezed images to matrix of imgNumber x imgSize
index = 1;
imgMatrix = zeros(imgNumber, imgSize);
for i = 1:999999
    filename = sprintf('/Users/samuco/Downloads/caffe-opencl/cs229/data/resize/img_%d.jpg',i);
    if exist(filename,'file') == 2
       I = rgb2gray(imread(filename));
       imgVector = reshape(I, [1,imgSize]);
       imgMatrix(index,:) = imgVector;
       index = index + 1
    end
end


%%  get list of image names
imgName = zeros(imgNumber,1);
index = 1;
for i = 1:999999
   filename = sprintf('/Users/samuco/Downloads/caffe-opencl/cs229/data/resize/img_%d.jpg',i);
   if exist(filename,'file') == 2
       imgName(index) = i;
       index = index + 1;
   end
end
size(index)
end

%%  calculating kNN
k = 10;
startJ = 3;
for j = startJ:6
    kNN = zeros(10000, k);
    for i = 1+j*10000:(j+1)*10000
       imgV = imgMatrix(i,:);
       %diffMatrix = imgMatrix - repmat(imgV,imgNumber,1);
       diffMatrix = bsxfun(@minus, imgMatrix, imgV);
       [diffVector, sortIndex] = sort(sum(diffMatrix .^ 2, 2));
       kNN(i,:) = imgName(sortIndex(1:k));
       i
    end
    dlmwrite(sprintf('knn_%d',j), kNN, 'delimiter', ',', 'precision', 9);
end

%% testing playground...

%imgName(sortIndex(10:20))

figure
imshow('~/Desktop/cs229Proj/imgs/test_resize2/img_1815.jpg')

%I = imread('~/Desktop/cs229Proj/imgs/test_resize2/img_1815.jpg');
%R = imresize(I, 0.5);
%imshow(R)

