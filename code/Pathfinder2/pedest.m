%Lecture with Computer Exercises
%Modelling and Simulating Social Systems

%Projects: Pedestrian Dynamics
%Lukas B�hler Heer Philipp  

%run matrix description
run init
 T=10000000;
 mov1 = avifile('planeS_1.avi');
%  
% 
%    mov4 = avifile('iplane0_412.avi');
%     mov5 = avifile('iplane0_512.avi');
%      mov6 = avifile('iplane0_612.avi');
%       mov7 = avifile('iplane0_712.avi');
%        mov8 = avifile('iplane0_812.avi');
%         mov9 = avifile('iplane0_912.avi');
%          mov10 = avifile('iplane0_1102.avi');
% %           mov11 = avifile('iplane380_111.avi');
%  mov12 = avifile('iplane0_1212.avi');
%   mov13 = avifile('iplane0_1312.avi');
%    mov14 = avifile('iplane0_1412.avi');
%     mov15 = avifile('iplane0_1512.avi');
%      mov16 = avifile('iplane0_1612.avi');
%       mov17 = avifile('iplane0_1712.avi');
%        mov18 = avifile('iplane0_1812.avi');
%         mov19 = avifile('iplane0_1912.avi');
%          mov20 = avifile('iplane0_2102.avi');
         tt=0;
%time loop
for t=0:dt:T
    tt=tt+1;
    %reset seen phy_, obi_& soc_forces
    pasMat(1:NrOfpassenger,8:11)=0;
    pasMat(1:NrOfpassenger,17:20)=0;
    
    %passenger loop
    for i=1:NrOfpassenger
        if  pasMat(i,3)==1
            
        %calculation integer matrix indices
        xint=real(int16(pasMat(i,1)));
        yint=real(int16(pasMat(i,2)));
       if xint<=0 || xint >= n || yint <=0 || yint >=m
       pasMat(i,3)=0;
       end
        end
        if  pasMat(i,3)==1
        %passenger in exit-area
        if  f(yint,xint)==Inf || f(yint+1,xint)==Inf ||f(yint-1,xint)==Inf || f(yint+2,xint)==Inf ||f(yint-2,xint)==Inf
            pasMat(i,3)=0;
            pasMat=sortrows(pasMat,3);
            passengerfleed=passengerfleed+1;
        end
        
        %passenger in "about to leave the plane"-area              
        if f(yint,xint)==3 && crewflee==0
            pasMat(i,12)=FX(yint,xint)*fear_force_factor;
            pasMat(i,13)=FY(yint,xint)*fear_force_factor;
        
        %passenger in flightattendant-area
        elseif f(yint,xint)==6 && crewflee==0
            pasMat(i,12)=FX(yint,xint)*flee_force_factor;
            pasMat(i,13)=FY(yint,xint)*flee_force_factor;
        
        %passenger in no special area
        else
            pasMat(i,12)=FX(yint,xint)*force_factor;
            pasMat(i,13)=FY(yint,xint)*force_factor;        
        end
        
        e_a=pasMat(i,12:13)/norm(pasMat(i,12:13)+[epsilon 0]);
         
        %influence of other passenger
        for j=1:NrOfpassenger
            if i~=j && pasMat(j,3)==1
                fv=[pasMat(i,1)-pasMat(j,1);pasMat(i,2)-pasMat(j,2)];
                if norm(fv)<pas_soc_influence_area
                    n_ab=(pasMat(i,1:2)-pasMat(j,1:2))./norm(pasMat(j,1:2)-pasMat(i,1:2));
                    
                    %calculation f_phy
                    if norm(fv)<pas_phy_influence_area
                        pasMat(i,8:9)=pasMat(i,8:9)+A_phy*exp((1-norm(pasMat(i,1:2)-pasMat(j,1:2)))/B_phy).*n_ab;  
                    end
                    
                    %calculation f_soc
                    %phi_alphabeta = angle between passenger i and j
                    %e_a=pasMat(i,4:5)/norm(pasMat(i,4:5));
                    phi_alphabeta=acos(dot(e_a,n_ab));
                    pasMat(i,10:11)=pasMat(i,10:11)+((lamda+(1-lamda)*(1+cos(phi_alphabeta))/2))*A_soc*exp(1-norm(pasMat(i,1:2)-pasMat(j,1:2))/B_soc).*n_ab;  
                end
            end
        end
        

        %influence of wall_objects
        for j=1:NrOfObi
            %fv=vector between pas and wallelement
            fv=[pasMat(i,1)-obiMat(j,1);pasMat(i,2)-obiMat(j,2)];

            if norm(fv)<wall_influence_area
                wall_force=A_wall*exp(-norm(fv)/B_wall);
                
                if abs(obiMat(j,19))< abs(obiMat(j,20)) % wall in y-direction
                    if obiMat(j,20)==[2.2] %only a wallelem above
                        if pasMat(i,2)< obiMat(j,2)
                            pasMat(i,12)=pasMat(i,12)+3*FX(yint-1,xint)*force_factor;
                            
                        else
                            pasMat(i,17)=pasMat(i,17)+1.5*sign(fv(1))*wall_force;
                        end
                        pasMat(i,18)=-100;
                            
                        %end
                    elseif obiMat(j,20)==[-3.3] %only a wallelem below
                        if pasMat(i,2) > obiMat(j,2)
                            pasMat(i,12)=pasMat(i,12)+3*FX(yint+1,xint)*force_factor;
                        else
                            pasMat(i,17)=pasMat(i,17)+1.5*sign(fv(1))*wall_force;
                        end
                        pasMat(i,18)=100;
                            
                        %end
                    else
                        pasMat(i,17)=pasMat(i,17)+1.5*sign(fv(1))*wall_force;
                    end
                    
                else % wall in x-direction
                    
                    if obiMat(j,19)==[2.2] %only a wallelem on the rigth
                        if pasMat(i,1)< obiMat(j,1)
                            pasMat(i,13)=pasMat(i,13)+3*FY(yint,xint-1)*force_factor;
                        else
                            pasMat(i,18)=pasMat(i,18)+1.5*sign(fv(2))*wall_force;
                        end
                        pasMat(i,17)=-100;

                        %end
                    elseif obiMat(j,19)==[-3.3] %only a wallelem on the left
                        if pasMat(i,1) > obiMat(j,1)
                            pasMat(i,13)=pasMat(i,13)+3*FY(yint,xint+1)*force_factor;
                            
                        else
                            pasMat(i,18)=pasMat(i,18)+1.5*sign(fv(2))*wall_force;
                        end
                            pasMat(i,17)=100;
   
                        %end
                    else
                        pasMat(i,18)=pasMat(i,18)+1.5*sign(fv(2))*wall_force;
                    end
                end
                break;
            end
           
        end
        
        %influence of att_objects (phys&soc)
%         if crewflee==0 
%             pasMat(i,19:20)=[0 0];
%             for j=1:NrOfAttend
%                 fv=[pasMat(i,1)-attMat(j,1);pasMat(i,2)-attMat(j,2)];
%                 fvv=[pasMat(i,1)-attMat(j,1);pasMat(i,2)-attMat(j,2)]/(norm([pasMat(i,1)-attMat(j,1);pasMat(i,2)-attMat(j,2)]));
%                 %calculation f_phy                
%                 if norm(fv)<att_soc_influence_area
%                     n_ab=(pasMat(i,1:2)-attMat(j,1:2))./norm(attMat(j,1:2)-pasMat(i,1:2));
%                      if norm(fv)<pas_phy_influence_area
%                         pasMat(i,19:20)=A_phy*exp((1-norm(pasMat(i,1:2)-attMat(j,1:2)))/B_phy).*n_ab;
%                      end
%                      
%                 %calculation f_soc
%                     c=dot(attMat(j,12:13),fvv);
%                     if c>0% && acos(c/(norm(attMat(j,12:13)*norm(fv))))<0  %forcefield_on_att and fv snaller 90_grad -> do nothing
%                     pasMat(i,19:20)=[0 0];
%                     else     
%                         %phi_alpha= angle of heading of passenger i
%                         %e_a=pasMat(i,4:5)/norm(pasMat(i,4:5));
%                         phi_alphabeta=acos(dot(e_a,n_ab));
%                         pasMat(i,19:20)=pasMat(i,19:20)+A_att*exp((1-norm(pasMat(i,1:2)-attMat(j,1:2)))/B_soc).*n_ab;
%                         
%                         fv=[FX(attMat(j,2),attMat(j,1));FY(attMat(j,2),attMat(j,1))];
%                         pasMat(i,19:20)=0.5*pasMat(i,19:20)+pasMat(i,12:13);
%                    end
%                 end
%             end
%         end
      
        else
            pasMat(i,8:15)=0;
            pasMat(i,4:5)=0;
        end
    end
    
    %calculate f_tot 
    pasMat(1:NrOfpassenger,14)=(pasMat(1:NrOfpassenger,8)+pasMat(1:NrOfpassenger,10)+pasMat(1:NrOfpassenger,12)+pasMat(1:NrOfpassenger,17)+pasMat(1:NrOfpassenger,19));   
    pasMat(1:NrOfpassenger,15)=(pasMat(1:NrOfpassenger,9)+pasMat(1:NrOfpassenger,11)+pasMat(1:NrOfpassenger,13)+pasMat(1:NrOfpassenger,18)+pasMat(1:NrOfpassenger,20));

    %calculate x'' and x'
    pasMat(1:NrOfpassenger,4)=dt.*pasMat(1:NrOfpassenger,14)./pasMat(1:NrOfpassenger,16);
    pasMat(1:NrOfpassenger,5)=dt.*pasMat(1:NrOfpassenger,15)./pasMat(1:NrOfpassenger,16);

    %calculate x
    pasMat(1:NrOfpassenger,6)=pasMat(1:NrOfpassenger,1);
    pasMat(1:NrOfpassenger,7)=pasMat(1:NrOfpassenger,2)+epsilon;
    pasMat(1:NrOfpassenger,1)=dt.*pasMat(1:NrOfpassenger,4)+pasMat(1:NrOfpassenger,1);
    pasMat(1:NrOfpassenger,2)=dt.*pasMat(1:NrOfpassenger,5)+pasMat(1:NrOfpassenger,2);
    pasMat(1:NrOfpassenger,4)=pasMat(1:NrOfpassenger,4)+epsilon;
    allMat=[pasMat;obiMat2;attMat];
    
    %speed in km/h
   % v=abs(pasMat(1:NrOfpassenger,1:2)-pasMat(1:NrOfpassenger,6:7))/dt*3.6;
    
    %newplot
     plot(allMat(NrOfpassenger+1:NrOfpassenger+NrOfObi2,1),allMat(NrOfpassenger+1:NrOfpassenger+NrOfObi2,2),'.k','MarkerSize', 20);
hold on
    plot(exiMat(:,1),exiMat(:,2),'.r','MarkerSize', 20);

%     if crewflee==1
%           reset(plot2)   
%     end
    
    %if t==1
     %   plot(allMat(NrOfpassenger+1:NrOfpassenger+NrOfObi2,1),allMat(NrOfpassenger+1:NrOfpassenger+NrOfObi2,2),'.k','MarkerSize', 20);
        %plot(allMat(NrOfpassenger+NrOfObi2+1:NrOfpassenger+NrOfObi2+NrOfAttend,1),allMat(NrOfpassenger+NrOfObi2+1:NrOfpassenger+NrOfObi2+NrOfAttend,2),'.m','MarkerSize', 35);
    %end
        plot(allMat(1+passengerfleed:NrOfpassenger,1),allMat(1+passengerfleed:NrOfpassenger,2),'.bl','MarkerSize', 25);
    %xlim([000 n+1]);
    %ylim([-n/2+m/2 m/2+n/2+1]);

    xlim([000 n]);
    ylim([0 m]);

    FF1 = getframe(gca);
    mov1=addframe(mov1,FF1);

    %pause(0.1);
    %reset(plot2)
    %reset(plot1)
    clf('reset')
    %if all passengers are gone -> allow crew to flee
    if sum(pasMat(1:NrOfpassenger,3))==0   
%        if crewflee==1
            break;
%        end
%             attMat(:,16)=unidrnd(50,NrOfAttend,1)+50;
%             pasMat=[pasMat;attMat];
%             [NrOfpassenger entries]=size(pasMat);
%             crewfleed=1;  
%             crewflee=1;
%             pasMat=sortrows(pasMat,3);
%             pasMat(1:NrOfpassenger,4)=pasMat(1:NrOfpassenger,4)+epsilon;
     end
end


mov1=close(mov1);

