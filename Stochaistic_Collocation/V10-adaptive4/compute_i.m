function i = compute_i(d, n)

nlevels = nchoosek(n+d-1,d-1);
i       = zeros(nlevels,d);

i(1,1) = n;
max = n;

for k = 2:nlevels
	if i(k-1,1) > 0
		i(k,1) = i(k-1,1) - 1;
		for l = 2:d
			if i(k-1,l) < max

				i(k,l) = i(k-1,l) + 1;
				for m = l+1:d
					i(k,m) = i(k-1,m);
				end
				break;
			end
		end
	else
		sum = 0;
		for l = 2:d
			if i(k-1,l) < max
				i(k,l) = i(k-1,l) + 1;
				sum = sum + i(k,l);
				for m = l+1:d
					i(k,m) = i(k-1,m);
					sum = sum + i(k,m);
				end
				break;
			else
				temp = 0;
				for m = l+2:d
					temp = temp + i(k-1,m);
				end
				max = n-temp;
				i(k,l) = 0;
			end
		end
		i(k,1) = n - sum;
		max = n - sum;
	end
end
i = i + 1;