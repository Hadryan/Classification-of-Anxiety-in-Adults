
function [accuracyMatrix, featureMatrix, confusionMatrix] = optimize_SVM_ALL(data, labels)
%Function to find the opimal number of features for the given data using a selected FS method.
% Input: data - Feature matrix [Double:Matrix]
% Input: label - Class labels [Scalar: Array]

% Input: fs - Feature Selection Method [String {'jmi', 'cmim', 'disr'}]
% Input: minimum - Minimum number of features to be selected [Scalar]
% Input: maximum - Maximum number of features to be selected [Scalar]

% Output: optimalNumFeatures - Optimum number of features [Scalar]
% Output: optimalAccuracy - Optimum classification accuracy [Double]

tStart = tic;
fsMethods = {'jmi', 'cmim', 'disr'};
numberOfParticipants = 1;

accuracyMatrix = zeros(numberOfParticipants,size(fsMethods,2));
featureMatrix = zeros(numberOfParticipants,size(fsMethods,2));
confusionMatrix = zeros(2,2,numberOfParticipants);

minimum = 5;
maximum = 200;
fIndex = 1;

for fs = fsMethods
    fprintf('\nProcessign method: %s\n',fsMethods{fIndex});
    pIndex = 1;
    
    
    while pIndex <= numberOfParticipants
        optimalAccuracy = 0.0;
        optimalNumFeatures = minimum;
        targets = [];
        outputs = [];
        confusionTemp = zeros(3,3);
        fprintf('\nProcessign particpant : %d\n',pIndex);
        
        % Get the data and labels for participant participantIndex
        pData = data;
        pLabels = labels;
                
        fprintf('Processign order: 00000');
        for numOfFeatures=minimum:maximum
            fprintf('\b\b\b\b\b%5d', numOfFeatures);
            selectedIndices = feast(fs,numOfFeatures,pData,pLabels);
            selectedData = pData(:, selectedIndices);
            x = selectedData;
            t = pLabels;
            %t(t==-1) = 0;
            % Balance the class samples
            % ADASYN: set up ADASYN parameters and call the function:

            adasyn_features                 = x;
            adasyn_labels                   = t;
            adasyn_beta                     = [];   %let ADASYN choose default
            adasyn_kDensity                 = [];   %let ADASYN choose default
            adasyn_kSMOTE                   = [];   %let ADASYN choose default
            adasyn_featuresAreNormalized    = false;    %false lets ADASYN handle normalization
            adasyn_features(adasyn_features==-1) = 0;
            [adasyn_featuresSyn, adasyn_labelsSyn] = ADASYN(adasyn_features, adasyn_labels, adasyn_beta, adasyn_kDensity, adasyn_kSMOTE, adasyn_featuresAreNormalized);
            
            % Balanced feature and label set
            balanced_features = [x; adasyn_featuresSyn];
            balanced_labels = [t; adasyn_labelsSyn];       
            balanced_labels(balanced_labels==0) = -1;  
            %Make the features sparse to use with LIBSVM
            features_sparse = sparse(balanced_features);  
            verbose_option = 1;            
            [X_train, Y_train, X_test, Y_test] = random_split(features_sparse, balanced_labels);
            [best_C, best_gamma] = automaticParameterSelection(Y_train, X_train);
            model = fitcsvm(Y_train, X_train, ...
                    sprintf('-c %f -g %f -b %d -q', best_C, best_gamma, verbose_option));
            % Use the SVM model to classify the data
            [predict_label, accuracy, ~] = svmpredict(Y_test, X_test, model, '-q'); % test the training data
            %[c,cm] = confusion(testT,testY);
            [cMatrix,~] = confusionmat(Y_test,predict_label);
            if(accuracy>optimalAccuracy)
                optimalAccuracy = accuracy;
                optimalNumFeatures = numOfFeatures;
%                 targets = Y_test;
%                 outputs = predict_label;
                confusionTemp = cMatrix;
            end
        end
        
        accuracyMatrix(pIndex,fIndex) = optimalAccuracy(1);
        featureMatrix(pIndex,fIndex) = optimalNumFeatures;
        confusionMatrix(:, :,pIndex) = confusionTemp';
%         plotconfusion(targets,outputs);
%         cd 'E:\DataSet\AMIGOS\Development\Data\Results_SVM';
%         plotName = strcat(int2str(pIndex),'_',fsMethods{fIndex});
%         saveas(gcf,plotName,'epsc');
%         cd 'E:\DataSet\AMIGOS\Development\FEAST-v2.0.0_1\FEAST\matlab';
        close all;
        pIndex = pIndex + 1;
    end
    fIndex = fIndex + 1;
%     fprintf('\nOptimal Accuracy : %f%%\n', optimalAccuracy);
%     fprintf('Optimal Number of Features : %d\n', optimalNumberOfFeatures);
end


cd 'E:\DataSet\AMIGOS\Development\Data\Results_SVM'
csvwrite('accuracyMatrixALL.csv', accuracyMatrix);
csvwrite('featureMatrixALL.csv', featureMatrix);
save('confusionMatrixALL.mat', 'confusionMatrix');

cd 'E:\DataSet\AMIGOS\Development\FEAST-v2.0.0_1\FEAST\matlab'
fprintf('\nSaved the accuracy and feature matrices !\n');
tEnd = toc(tStart);
fprintf('\nExecution took %d minutes and %f seconds\n',floor(tEnd/60),rem(tEnd,60));
end
