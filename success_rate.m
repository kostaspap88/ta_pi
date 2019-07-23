function SR = success_rate(me, C, test_red, d)

% number of traces used in every attack is d

% number of classes
no_classes = size(me,2);

% Compute the pooled covariance matrix for improved numerical stability
c_pool = mean(C,3);
inv_c=inv(c_pool); 


% find the number of misclassifications 
miss_count = zeros(1, no_classes);

for i=1:no_classes
    
    for j=1:size(test_red{i},1)/d
         %trace(s)-to-classify
         start_trace = 1+(j-1)*d;
         end_trace = j*d;
         trace=test_red{i}(start_trace:end_trace,:);
        
         % log probability computation
         p = zeros(1, no_classes);
         for k=1:no_classes
             
             for index=1:d
                  p(k)=p(k) + (trace(index,:)-me(:,k)')*inv_c*(trace(index,:)-me(:,k)')';
             end
             
             p(k) = -0.5*p(k);
            
         end
         

        if ((p(i)<max(p))|| (p(i)==-Inf)|| (p(i)==Inf))   
            miss_count(i) = miss_count(i)+1;
        end  
    end
end

% compute the success rate
SR = zeros(no_classes,1);
for i=1:no_classes
    SR(i)=1-miss_count(i)/floor(size(test_red{i},1)/d);
end

end