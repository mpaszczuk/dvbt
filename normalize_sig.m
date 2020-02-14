function output = normalize_sig(sym, l)
% Input:        sym          = odebrany symbol
%               l            = numer symbolu   
% Output: output = znomalizowany symbol 

%% generowanie pilotów 
pilot_index_continual = [0 48 54 87 141 156 192 201 255 279 282 333 432 450 483 525 531 618 636 714 759 765 780 804 873 888 918 939 942 969 984 1050 1101 1107 1110 1137 1140 1146 1206 1269 1323 1377 1491 1683 1704 1752 1758 1791 1845 1860 1896 1905 1959 1983 1986 2037 2136 2154 2187 2229 2235 2322 2340 2418 2463 2469 2484 2508 2577 2592 2622 2643 2646 2673 2688 2754 2805 2811 2814 2841 2844 2850 2910 2973 3027 3081 3195 3387 3408 3456 3462 3495 3549 3564 3600 3609 3663 3687 3690 3741 3840 3858 3891 3933 3939 4026 4044 4122 4167 4173 4188 4212 4281 4296 4326 4347 4350 4377 4392 4458 4509 4515 4518 4545 4548 4554 4614 4677 4731 4785 4899 5091 5112 5160 5166 5199 5253 5268 5304 5313 5367 5391 5394 5445 5544 5562 5595 5637 5643 5730 5748 5826 5871 5877 5892 5916 5985 6000 6030 6051 6054 6081 6096 6162 6213 6219 6222 6249 6252 6258 6318 6381 6435 6489 6603 6795 6816];
pilot_index_continual = pilot_index_continual+1;
kmax = 6817;
kmin = 1;
location_scattered = @(l,p)kmin + 3 *mod(l,4) + 12*p ;

p = 0;
pilot_index_scattered = [];
temp_index = location_scattered(l,p);
while(temp_index <=kmax)
    pilot_index_scattered = [pilot_index_scattered temp_index];
    p = p+1;
     temp_index = location_scattered(l,p);
end
 all_pilot = [pilot_index_continual pilot_index_scattered];
 all_pilot = unique(all_pilot);
 all_pilot = sort(all_pilot);
 
 %% Tworzenie odpowiedzi impulsowej 
 
prbs_sequence = prbs(ones(1,11));
prbs_sequence = [prbs_sequence prbs_sequence prbs_sequence prbs_sequence];
pilots_sequence = 4/3*2*(1/2 - prbs_sequence);
ilor = []; 
for k = 1:length(all_pilot)
    ilor = [ilor sym(all_pilot(k))./pilots_sequence(all_pilot(k))];
end
xfit  = 1:6817;
interpol = interp1(all_pilot, ilor,xfit,'linear');
figure, plot(abs(interpol),'.');
title("Estymacja kana³u")

%% Normalizowanie sygna³u

data_normalized=[];
for k = 1:length(sym)
%         data_normalized = [data_normalized symbols(k)/ilor(k)]; 
      data_normalized = [data_normalized abs(sym(k)).*exp(j*(angle(sym(k))-angle(interpol(k))))]; 
end
figure, plot(data_normalized,'.');
title('Symbol po kompensacji zmiany fazy');
data_normalized=[];
for k = 1:length(sym)
        data_normalized = [data_normalized sym(k)/interpol(k)]; 
%       data_normalized = [data_normalized abs(sym(k)).*exp(j*(angle(sym(k))-angle(interpol(k))))]; 
end
figure, plot(data_normalized,'.');
title('Symbol kompensacji kana³u');
end
