%_____________MASK Modulation and Demodulation Code________
 clear all;
 close all;
 Nb=5;
 Rb=1; %bps
 T=1/Rb;
 SNR = 12;
 % Generate Nb bits randomly
 %b =rand(1,Nb)&amp;amp;amp;gt;0.5;
 b =[1 1 0 1 0 0 1 0 1 1];
 %Rb is the bit rate in bits/second
 bit_to_symbol=[];
 for i=1:2:size(b,2)
     a = [b(i) b(i+1)]
     x = binaryVectorToDecimal(a)
     switch(x) 
         case [0]
         bit_to_symbol=[bit_to_symbol 0];
         case [1]
         bit_to_symbol=[bit_to_symbol 1];
         case [2]
         bit_to_symbol=[bit_to_symbol 2];
         case [3]
         bit_to_symbol=[bit_to_symbol 3];
     end
 
 end
 NRZ_out=[];
 RZ_out=[];
 Manchester_out=[];
 Vp=1;
 for index=1:size(bit_to_symbol,2)
    NRZ_out=[NRZ_out ones(1,200)*bit_to_symbol(index)];
 end
 figure;
 stem(b, 'filled');
 xlabel('Sequence Number')
 ylabel ('Transmitted Bits [0/1]')
 ylim ([0 2])
 figure;
 plot(NRZ_out, 'b', 'Linewidth', 2);
 xlabel ('Time')
 ylabel ('NRZ output')
 ylim ([0 4])
 grid on
 
 
 t=0.005:0.005:5;
 f=5;
 Modulated=NRZ_out.*(sqrt(2/T)*sin(2*pi*f*t));
 figure;
 plot(Modulated);
 xlabel ('Time')
 ylabel ('Modulated Carrier')
 ylim ([-6 6])
 md = Modulated;
 %%%%%%%%%%%%%%%%%%%%%%%%%
 %Qua kenh
 Modulated=awgn( Modulated,SNR)
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 y=[];
 received=[];
 demodulated=Modulated.*(sqrt(2/T)*sin(2*pi*f*t));
 for i=1:200:size(demodulated,2)
 y=[y trapz(t(i:i+199),demodulated(i:i+199))];
 end
  
 for (i=1:1:size(y,2))
 euclidean_dist=sqrt((y(i)-[0 1 2 3]).^2);
 [val index]=min(euclidean_dist)
 temp = [0 1 2 3];
 index = temp (index);
 switch(index)
 case 0
 received=[received 0 0];
 case 1
 received=[received 0 1];
 case 2
 received=[received 1 0];
 case 3
 received=[received 1 1];
 end
 
 end
  
 %received=y&amp;amp;amp;gt;0;
 figure;
 stem(received,'filled', 'm')
 xlabel('Sequence Number')
 ylabel ('Received Bits [0/1]')
 ylim ([0 2])
 %%%%%%%%%%%%
 s1 = scatterplot(md); hold on
 s2 = scatterplot(Modulated,[],[],'r*',s1);hold on
 scatterplot(received,[],[],'gx',s2); grid on;
 title('Modulation data, data in AWGN and Demodulation data'); hold off;