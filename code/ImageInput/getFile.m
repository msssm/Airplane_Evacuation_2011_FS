function [F] = getFile()
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

exit=0;
while exit==0
    [FileName,PathName] = uigetfile('*.bmp', 'Select a Bitmap File');
    I=imread(strcat(PathName,FileName));
    exit=1;
    if (find(I>6))
        exit=0;
        uiwait(msgbox('Wrong file'));
    end
end

space=find(I==5);
goSlow=find(I==4);
exit=find(I==2);
passenger=find(I==1);
flightattendant=find(I==3);
flightattendantarea=find(I==6);
wall=find(I==0);
[n,m]=size(I);
F=zeros(n,m);
F(space)=1;
F(goSlow)=3
F(exit)=Inf;
F(passenger)=2;
F(flightattendant)=4;
F(wall)=0;
F(flightattendantarea)=6;
F=flipud(F)

end

