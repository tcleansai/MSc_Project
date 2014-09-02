function [average_recall, precision_rates ] = CalAverageRecallPrecision(confusion_matrice)
% In put a average confusion matrice and return its average_recall and 
% precision_rates
nClass = size(confusion_matrice,1);
average_recall = zeros(1,nClass);
precision_rates = zeros(1,nClass);
column_number = size(confusion_matrice,2);
for i = 1:column_number
    TP = confusion_matrice(i,i);
    FN = sum(confusion_matrice(i,:)) - TP;
    FP = sum(confusion_matrice(:,i)) - TP;
    ar = TP/(TP+FN);
    pr = TP/(TP+FP);
    average_recall(i) = ar;
    precision_rates(i) = pr;
end

