%Init
clear all;
clc
%clf
%variable definition
tic
pas_phy_influence_area=3;%15;%&*picture_factor;
pas_soc_influence_area=10;%20;%*picture_factor;
att_soc_influence_area=10;%*picture_factor;
A_phy=80;%*picture_factor;
A_soc=40;%*picture_factor;
A_att=70;%*picture_factor;
A_wall=600;
B_phy=1;
B_soc=2;
B_wall=1;
lamda=0.2;
dt=0.3;
epsilon=1e-10;
T=200/dt;
wall_influence_area=1.2;
wallrelevance_area=10;
heavy=1e10;
fear_force_factor=20;
force_factor=40;
flee_force_factor=60;
walelem=1;
paselem=1;
attelem=1;
exielem=1;
crewflee=0;
passengerfleed=0;
gone=0;

%allocation of matrices
pasMat=zeros(3,20);
obiMat=zeros(700,20);
obiMat2=[];
attMat=zeros(4,20);

%read picture/generate forcefield
 f = getFile();
[FX,FY]=computeGradientField1(f);
[m n]=size(FX);

%passenger integration
% for mp=1:m
%     for np=1:n
%         if f(mp,np)==2;
%             pasMat(paselem,2)=mp;
%             pasMat(paselem,1)=np;
%             paselem=paselem+1;
%         end
%     end 
% end  

%flightattendant integration
for mm=1:m
    for nn=1:n
        if f(mm,nn)==2;
            pasMat(paselem,2)=mm;
            pasMat(paselem,1)=nn;
            paselem=paselem+1;
        end
%         if f(mm,nn)==4;
%             attMat(attelem,2)=mm;
%             attMat(attelem,1)=nn;
% 
%             %initial flightattendant weigth
%             attMat(:,16)=heavy;
%             %direction of forcefield at attendant position
%             attMat(attelem,12)=FX(mm,nn);
%             attMat(attelem,13)=FY(mm,nn);
%             attelem=attelem+1;
%         end
        %wall integration
        if f(mm,nn)==0;
            obiMat(walelem,2)=mm;
            obiMat(walelem,1)=nn;
            walelem=walelem+1;
        end
        if f(mm,nn)==Inf;
            exiMat(exielem,2)=mm;
            exiMat(exielem,1)=nn;
            exielem=exielem+1;
        end
    end
end


%IT'S ALIVE MUAHAHAH!!
pasMat(:,3)=1;
attMat(:,3)=1;

%'previous' place
pasMat(:,6)=pasMat(:,1);
pasMat(:,7)=pasMat(:,2)+epsilon;
pasMat(:,4)=epsilon;
[NrOfpassenger entries]=size(pasMat);

%random weigth
pasMat(:,16)=unidrnd(70,NrOfpassenger,1)+50;

attMat(:,6)=attMat(:,1);
attMat(:,7)=attMat(:,2)+epsilon;
[NrOfAttend Aentries]=size(attMat);
[NrOfObi Obientries]=size(obiMat);

obiMat(:,16)=heavy;

%set walldirection



for mn=2:NrOfObi
    
       %there is a wallelem above
   if f(obiMat(mn,2)+1,obiMat(mn,1))==0    
       obiMat(mn,20)=[2.2]; 
   end
       %there is a wallelem below
   if f(obiMat(mn,2)-1,obiMat(mn,1))==0     
       obiMat(mn,20)=obiMat(mn,20)-3.3;
   end
       %there is a wallelem on the rigth
   if f(obiMat(mn,2),obiMat(mn,1)+1)==0    
       obiMat(mn,19)=[2.2];
   end
       %there is a wallelem on the left
   if f(obiMat(mn,2),obiMat(mn,1)-1)==0     
       obiMat(mn,19)=obiMat(mn,19)-3.3;
   end
end

%exit integration


%simplify obiMat -> leave out useless wall elements 
for j=1:exielem-1
    obiMat1=obiMat;
    [NrOfObi Obientries]=size(obiMat);
    gone=0;
    for i=1:NrOfObi
        fv=abs([obiMat1(i-gone,1)-exiMat(j,1);obiMat1(i-gone,2)-exiMat(j,2)]);
        NrOfObi=NrOfObi-gone;
        if abs(obiMat1(i-gone,19)) > abs(obiMat1(i-gone,20)) 
        if abs(norm(fv)) > wallrelevance_area
            obiMat1(i-gone,:)=[];
            gone=gone+1;
        end
        end
    end
    obiMat2=[obiMat2;obiMat1];
end

obiMat3=unique(obiMat2,'rows');
clear obiMat2;

[NrOfObi Obientries]=size(obiMat);
for i=1:NrOfObi
    if abs(obiMat(i,19)) > abs(obiMat(i,20))
        if obiMat(i,2) < 7 || obiMat(i,2) > m-7
        else
            obiMat3=[obiMat3;obiMat(i,:)];
        end
    end
end
obiMat2=obiMat;
obiMat=obiMat3;
clear obiMat4;
clear obiMat1;
clear obiMat3;
[NrOfObi Obientries]=size(obiMat);
[NrOfObi2 Obientries2]=size(obiMat2);


toc