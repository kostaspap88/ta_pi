function PI = perceived_information(me, C, test_red, m)


no_classes = size(me,2);
c_pool = mean(C,3); 
hs=log2(no_classes);

ps=1/no_classes;
ss=sqrt(c_pool);



%Univariate Perceived Information
if (m==1)
    sum_ext=0;
    for i=1:no_classes
        sum_int=0;

        for j=1:size(test_red{i},1)

            denom=0;
            for k=1:no_classes
                %denom=denom+nchoosek(8,k-1)/(2^8)*normpdf(test_red{i}(j,:),me(:,k),ss);
                denom=denom+normpdf(test_red{i}(j,:),me(:,k),ss);
            end

            %num=nchoosek(8,i-1)/(2^8)*normpdf(test_red{i}(j,:),me(:,i),ss);
            num=normpdf(test_red{i}(j,:),me(:,i),ss);

            model_term=log2(num)-log2(denom);

            chip_term=1/size(test_red{i},1);

            sum_int=sum_int+chip_term*model_term;
        end
        sum_ext=sum_ext+sum_int; 
        
    end

    PI=hs+ps*sum_ext;
    %PI=hs+nchoosek(8,k-1)/(2^8)*sum_ext;
    
end

%Multivariate Perceived Information
if (m>1)
    sum_ext=0;
    for i=1:no_classes
        sum_int=0;

        for j=1:size(test_red{i},1)

            denom=0;
            for k=1:no_classes
                denom=denom+mvnpdf(test_red{i}(j,:)',me(:,k),c_pool);
            end

            num=mvnpdf(test_red{i}(j,:)',me(:,i),c_pool);

        model_term=log2(num)-log2(denom);

        chip_term=1/size(test_red{i},1);

        sum_int=sum_int+chip_term*model_term;
        end
        sum_ext=sum_ext+sum_int;
    end

    PI=hs+ps*sum_ext;
end

end
