function x = compute_x(i,m)

i2 = i-1;
% Initialize variables
d = size(i,2);
k = size(i,1);
npoints     = zeros(k,1);
npoints2    = zeros(k,1);
dim         = zeros(d,1);
totalpoints = 0;
totalpoints2= 0;

for n = 1:k;
	ntemp = 1;
	for l = 1:d
		lev = i(n,l);
		if lev == 0
			continue;
		elseif lev <= 2
			ntemp = ntemp * 2;
		else
			ntemp = ntemp * 2^(lev-1);
		end
	end
	npoints(n) = ntemp;
	totalpoints = totalpoints + ntemp;
end
%%%%%%%%%%%%%%%-delete-%%%%%%%%%%%%%%%
for n = 1:k;
	ntemp2 = 1;
	for l = 1:d
		lev2 = i2(n,l);
		if lev2 == 0
			continue;
		elseif lev2 <= 2
			ntemp2 = ntemp2 * 2;
		else
			ntemp2 = ntemp2 * 2^(lev-1);
		end
	end
	npoints2(n) = ntemp2;
	totalpoints2 = totalpoints2 + ntemp2;
end
%%%%%%%%%%%%%%%-delete-%%%%%%%%%%%%%%%

index = 1;
x = 0.5*ones(totalpoints,d);

for kl = 1:k
    c = {};
    c2 ={};
    ndims = 0;
    ndims2 = 0;
    for l = 1:d
        % compute the points, scaled to [0,1]
        lev = i(kl, l);
        lev2= i2(kl,l);
        if lev2 == 0
        elseif lev2 == 1
            ndims2 = ndims2 + 1;
            c2{ndims2} = [0; 1];
        else
            ndims2 = ndims2 + 1;
            c2{ndims2} = ( ( ( (1:2^(lev2-1)) *2 ) -1).*2^(-lev2))';
        end
        if lev == 1
            continue;
        elseif lev == 2
            ndims = ndims + 1;
            c{ndims} = [0; 1];
        else
            ndims = ndims + 1;
            c{ndims} = (((1:m(kl,l))-1)./(m(kl,l)-1))';
        end
        dim(ndims) = l;
    end
    if ndims > 1
        [c{:}] = ndgrid(c{:});
        [c2{:}] = ndgrid(c2{:});
    end
    for n = 1:ndims
        x(index:index+npoints(kl)-1,dim(n)) = c{n}(:);
    end
    index = index + npoints(kl);
end
x = unique(x,'rows');