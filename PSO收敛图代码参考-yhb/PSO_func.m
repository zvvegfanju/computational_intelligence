function [gbest,gbestval,fitcount,gfs]= PSO_func(fname,Max_Gen,Max_FES,Particle_Number,Dimension,VRmin,VRmax,sn1,gfs,CE)
%[gbest,gbestval,fitcount]= PSO_func('f8',3500,200000,30,30,-5.12,5.12)
rand('state',sum(100*clock));
me=Max_Gen;
ps=Particle_Number;
D=Dimension;
cc=[2 2];   %acceleration constants
iwt=0.9-(1:me).*(0.5./me);
% iwt=0.5.*ones(1,me);
if length(VRmin)==1
    VRmin=repmat(VRmin,1,D);
    VRmax=repmat(VRmax,1,D);
end
mv=0.5*(VRmax-VRmin);
VRmin=repmat(VRmin,ps,1);
VRmax=repmat(VRmax,ps,1);
Vmin=repmat(-mv,ps,1);
Vmax=-Vmin;
pos=VRmin+(VRmax-VRmin).*rand(ps,D);

for i=1:ps
    e(i,1)=feval(fname,pos(i,:));
    CE(i,:)=[i,e(i,1)];
    if mod (i,sn1)==0
        cs1=i/sn1;
        gfs(1,cs1)=min(CE(1:i,2));
    end
end

fitcount=ps;
vel=Vmin+2.*Vmax.*rand(ps,D);%initialize the velocity of the particles
pbest=pos;
pbestval=e; %initialize the pbest and the pbest's fitness value
[gbestval,gbestid]=min(pbestval);
gbest=pbest(gbestid,:);%initialize the gbest and the gbest's fitness value
gbestrep=repmat(gbest,ps,1);

for i=2:me

    for k=1:ps

        aa(k,:)=cc(1).*rand(1,D).*(pbest(k,:)-pos(k,:))+cc(2).*rand(1,D).*(gbestrep(k,:)-pos(k,:));
        vel(k,:)=iwt(i).*vel(k,:)+aa(k,:); 
        vel(k,:)=(vel(k,:)>mv).*mv+(vel(k,:)<=mv).*vel(k,:); 
        vel(k,:)=(vel(k,:)<(-mv)).*(-mv)+(vel(k,:)>=(-mv)).*vel(k,:);
        pos(k,:)=pos(k,:)+vel(k,:); 
        pos(k,:)=((pos(k,:)>=VRmin(1,:))&(pos(k,:)<=VRmax(1,:))).*pos(k,:)...
            +(pos(k,:)<VRmin(1,:)).*(VRmin(1,:)+0.25.*(VRmax(1,:)-VRmin(1,:)).*rand(1,D))+(pos(k,:)>VRmax(1,:)).*(VRmax(1,:)-0.25.*(VRmax(1,:)-VRmin(1,:)).*rand(1,D));
    %     if (sum(pos(k,:)>VRmax(k,:))+sum(pos(k,:)<VRmin(k,:)))==0;
        e(k,1)=feval(fname,pos(k,:));
        fitcount=fitcount+1;
        if fitcount <= Max_FES
            CE(fitcount,:)=[fitcount,e(k,1)];
            if mod (fitcount,sn1)==0
                cs1=fitcount/sn1;
                gfs(1,cs1)=min(CE(1:fitcount,2));
            end
        end
        tmp=(pbestval(k)<e(k));
        temp=repmat(tmp,1,D);
        pbest(k,:)=temp.*pbest(k,:)+(1-temp).*pos(k,:);
        pbestval(k)=tmp.*pbestval(k)+(1-tmp).*e(k);%update the pbest
        if pbestval(k)<gbestval
            gbest=pbest(k,:);
            gbestval=pbestval(k);
            gbestrep=repmat(gbest,ps,1);%update the gbest
        end
    end
%     end

%     if mod(i,100)==0,
%     plot(pos(:,D-1),pos(:,D),'b*');
%     hold on
%     plot(gbest(D-1),gbest(D),'r*');   
%     hold off
%     axis([VRmin(1,D-1),VRmax(1,D-1),VRmin(1,D),VRmax(1,D)])
%     title(['PSO: ',num2str(i),' generations, Gbestval=',num2str(gbestval)]);  
%     drawnow
% % i
% % gbestval
%     end

    if fitcount>=Max_FES
        break;
    end

end


