function [ result ] = CalFaMeasure( a, precision,recall )
%Fa function, a is the weight of precision
n = size(precision,2);
result = zeros(1,n);
    for i= 1:n
        result(i) = (1 + a)*(precision(i) * recall(i))/(a*precision(i) + recall(i));
    end
end

