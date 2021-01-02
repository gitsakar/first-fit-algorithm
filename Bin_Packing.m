clc;
cap = 60;                   %max. capacity of one bin
l = 23;                      %number of objects
pop_size = 10;              %initial population
rep_size = 6;               %reproduction size

a = [12, 16, 23, 31, 25, 27, 9, 11, 15, 7, 52, 48, 25, 43, 26, 4, 4, 5, 5, 7, 7, 34, 32];     %items to be packed

bin = zeros(pop_size,1);    %bins required for each chromosome

pop = zeros(pop_size,l);        %creating population
for i = 1:pop_size
    sel = l;
    loc = 1:l;
    for j = 1:l      %random selection of items
        pos = randi([1 sel]);
        pop(i,j) = loc(pos);
        loc(pos) = [];
        sel = sel - 1;
    end
end

pop_deco = a(pop);          %decoded population

for i = 1:pop_size          %computing number of bins required for each chroosome
    ele = l;
    cur = pop_deco(i,:);
    while(ele ~= 0)
        w_sum = 0;
        k = 1;
        ind = [];
        for j = 1:1:ele
            if(w_sum + cur(j) <= cap)
                w_sum = w_sum + cur(j);
                ind(k) = j;
                k = k + 1;
            end
        end
        cur(ind) = [];
        bin(i) = bin(i) + 1;
        ele = ele - k + 1;
    end
end

bin_max = max(bin);

all_best = l;           %start by assuming number of bins required = number of items
counter = 0;

while(1)
    fit = (bin_max - bin) + 20;
    
    sum_fit = sum(fit);             %total fitness of the parent population
    prob = fit/sum_fit;             %individual probability of selection of each parent
    cum_prob = cumsum(prob);                %cumulative probability of selection
    
    par_ind = zeros(1,rep_size);            %initializing the position of parent to be selected
    for i = 1:rep_size                      %finds out index of parents to be selected based on probability
        rand_par = rand(1,1);
        for j = 1:pop_size
            if (rand_par <= cum_prob(j))
                par_ind(i) = j;
                break;
            end
        end
    end
    
    p = pop(par_ind,:);     %selects the parents for reproduction from computed index
    
    offspring = zeros(rep_size,l);
    for k = 1:2:rep_size            %PMX operator for offspring 1 and 2
        sel = l - 1;           %random selection of crossover points from 2 to number of l - 1
        loc = 1:l;
        
        c = zeros(1,2);
        for j = 1:2
            pos = randi([2 sel]);   %positions can be selected from 2 to l-1
            c(j) = loc(pos);
            loc(pos) = [];
            sel = sel - 1;
        end
        c = sort(c,'ascend');   %sorting crossover points in ascending order
        
        for j = c(1):c(2)       %keeping only crossedover points
            offspring(k,j) = p(k,j);
            offspring(k+1,j) = p(k+1,j);
        end
        
        
        for i = 1:l                      %importing remaining ls from other parents according to PMX
            if(offspring(k,i) == 0)
                match = 0;
                ind = 0;
                for j = c(1):c(2)
                    if (p(k+1,i) == p(k,j))
                        match = 1;
                        ind = j;
                        break;
                    end
                end
                
                if(match == 0)
                    offspring(k,i) = p(k+1,i);
                else
                    clr = 0;
                    while(clr ~= 1)
                        for j = c(1):c(2)
                            if(p(k+1,ind) == p(k,j))
                                clr = 0;
                                ind = j;
                                break;
                            else
                                clr = 1;
                            end
                        end
                    end
                    offspring(k,i) = p(k+1,ind);
                end
            end
            
            
            if(offspring(k+1,i) == 0)
                match = 0;
                ind = 0;
                for j = c(1):c(2)
                    if (p(k,i) == p(k+1,j))
                        match = 1;
                        ind = j;
                        break;
                    end
                end
                
                if(match == 0)
                    offspring(k+1,i) = p(k,i);
                else
                    clr = 0;
                    while(clr ~= 1)
                        for j = c(1):c(2)
                            if(p(k,ind) == p(k+1,j))
                                clr = 0;
                                ind = j;
                                break;
                            else
                                clr = 1;
                            end
                        end
                    end
                    offspring(k+1,i) = p(k,ind);
                end
            end
        end
    end
    
    offspring_deco = a(offspring);      %decoded offspring
    bin_off = zeros(rep_size,1);        %bins array for offspring
    for i = 1:rep_size                  %finding bins required for each offspring
        ele = l;
        cur = offspring_deco(i,:);
        while(ele ~= 0)
            w_sum = 0;
            k = 1;
            ind = [];
            for j = 1:1:ele
                if(w_sum + cur(j) <= cap)
                    w_sum = w_sum + cur(j);
                    ind(k) = j;
                    k = k + 1;
                end
            end
            cur(ind) = [];
            bin_off(i) = bin_off(i) + 1;
            ele = ele - k + 1;
        end
    end
    
    self_ind = 1;                           %finding offsprings that are same
    self_loc = [];
    for i = 1:rep_size
        for j = i+1:rep_size
            if(isequal(offspring(i,:), offspring(j,:)))
                self_loc(self_ind) = i;
                self_ind = self_ind + 1;
                break;
            end
        end
    end
    
    offspring(self_loc,:) = [];                       %deleting redundant offsprings within themselves
    bin_off(self_loc) = [];                        %deleting bins of redundant offsprings
    
    cross_ind = 1;                            %finding locations of offsprings that are already in parent population
    cross_loc = [];
    for i = 1:rep_size-self_ind+1
        for j = 1:pop_size
            if (isequal(offspring(i,:), pop(j,:)))
                cross_loc(cross_ind) = i;
                cross_ind = cross_ind + 1;
                break;
            end
        end
    end
    
    offspring(cross_loc,:) = [];                  %deleting redundant offspring with parent population
    bin_off(cross_loc) = [];                        %deleting bins of redundant offsprings
    
    
    pop = [pop; offspring];                         %group parents and offspring for survival of the fittest
    bin = [bin; bin_off];
    
    for i = 1:rep_size-self_ind+1-cross_ind+1                      %discards the higher number of bins
        [least, loc] = max(bin);
        pop(loc,:) = [];
        bin(loc) = [];
    end
    
    [cur_best, idx] = min(bin);       %stores best outcome till current iteration and counts how long the best outcome has not changed
    if(cur_best < all_best)
        all_best = cur_best;
        optm_arr = a(pop(idx,:));
        optm_bin = bin(idx);
        counter = 0;
    else
        counter = counter + 1;
    end
    
    if (counter == 1000)                     %stopping criteria and prints optimum solution with its fitness
        display(optm_arr);
        display(optm_bin);
        break;
    end
end