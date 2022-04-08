%% data_process_veggies
% Here I create a .mat file with the vegetable data
% Data taken from https://www.kaggle.com/datasets/misrakahmed/vegetable-image-dataset

% Make sure there is a folder Veggies in Data containing the folders Bean through Tomato from the training data from the above link
% I'm not trying to be careful with this code. So probably just use veggies.mat, no need to remake the data

%% Load

% All the subfolders
folder = '..\Data\Veggies';
aux = dir(folder);
subfolders = cell(15,1);
for f = 1 : 15
    subfolders{f} = aux(f+2).name;
end

% Load
M = 15 * 1000;
R = zeros(224,224,M);
G = zeros(224,224,M);
B = zeros(224,224,M);
l = 1;
L = 0; % The number of them that we skipped
for f = 1 : 15
    disp(subfolders{f})
    path = fullfile(folder,subfolders{f});
    aux = dir(path);
    for k = 3 : 1002
        % Read the image
        pathp = fullfile(path,aux(k).name);
        [img, map] = imread(pathp);

        % If it's not the right size, skip it
        if ~(size(img,1) == 224 && size(img,2) == 224)
            L = L + 1;
        else

            % If it's using a color map, decipher that
            if ~isempty(map)
                imgp = img;
                img = zeros(224,224,3);
                for i = 1 : 224
                    for j = 1 : 224
                        img(i,j,:) = map(imgp(i,j)+1);
                    end
                end
            end
            
            % Save its RGB
            R(:,:,l) = img(:,:,1);
            G(:,:,l) = img(:,:,2);
            B(:,:,l) = img(:,:,3);
            l = l + 1;

        end

    end
end

% Remove the last part of the list of images
R = R(:,:,1:end-L);
G = G(:,:,1:end-L);
B = B(:,:,1:end-L);

% Things should be in [0,1]
R = R / 256;
G = G / 256;
B = B / 256;

%% Downscale by a factor of 4
Rp = R;
Gp = G;
Bp = B;
M = size(Rp,3);
R = zeros(56,56,M);
G = R;
B = R;
for i = 1 : 56
    for j = 1 : 56
        ip = 4*(i-1)+1;
        jp = 4*(j-1)+1;
        I = ip : ip+3;
        J = jp : jp+3;
        R(i,j,:) = mean(Rp(I,J,:),[1 2]);
        G(i,j,:) = mean(Gp(I,J,:),[1 2]);
        B(i,j,:) = mean(Bp(I,J,:),[1 2]);
    end
end

%% Save
save('..\Data\veggies','R','G','B')

%% Clear some memory
clear aux R G B Rp Gp Bp f folder i I img ip j J jp k l L M map path pathp subfolders