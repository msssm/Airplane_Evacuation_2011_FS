%Matrix description

%pasMat: 
%pasMat(1:NrOfpassenger,1)=x-coordinates of the passenger
%pasMat(1:NrOfpassenger,2)=y-coordinates of the passenger

%pasMat(1:NrOfpassenger,3)= is still running: 1=true 0=false

%pasMat(1:NrOfpassenger,4)=x' of the passenger
%pasMat(1:NrOfpassenger,5)=y' of the passenger
%pasMat(1:NrOfpassenger,6)=x(t-1)-coordinates of the passenger
%pasMat(1:NrOfpassenger,7)=y(t-1)-coordinates of the passenger

%pasMat(1:NrOfpassenger,8)= x-phys force on passenger
%pasMat(1:NrOfpassenger,9)= y-phys force on passenger
%pasMat(1:NrOfpassenger,10)= x-soc force on passenger
%pasMat(1:NrOfpassenger,11)= y-soc force on passenger
%pasMat(1:NrOfpassenger,12)= x-field force on passenger
%pasMat(1:NrOfpassenger,13)= y-field force on passenger
%pasMat(1:NrOfpassenger,14)= x-total force on passenger = sum other forces
%pasMat(1:NrOfpassenger,15)= y-total force on passenger = sum other forces

%pasMat(1:NrOfpassenger,16)= m = mass of the passenger

%pasMat(1:NrOfpassenger,17)= x-oby force on passenger 
%pasMat(1:NrOfpassenger,18)= y-oby force on passenger

%pasMat(1:NrOfpassenger,19)= x-att force on passenger 
%pasMat(1:NrOfpassenger,20)= y-att force on passenger


%attMat: 
%attMat(:,1)=x-coordinates of the flightattendants
%attMat(:,2)=y-coordinates of the flightattendants

%attMat(:,3)= is still running: 1=true 0=false

%attMat(:,6)=x(t-1)-coordinates of the flightattendants
%attMat(:,7)=y(t-1)-coordinates of the flightattendants

%attMat(:,12)= x-Komp. field force on flightattendants
%attMat(:,13)= y-Komp. field force on flightattendants

%attMat(:,16)= m = mass of the flightattendants


%obiMat:
%obiMat(:,1)=x-coordinates of the wall elements
%obiMat(:,2)=y-coordinates of the wall elements

%attMat(:,16)= m = mass of the wall elements

%obiMat(:,19)= x-Komp. walldirection of wall elements
%obiMat(:,20)= y-Komp. walldirection of wall elements

