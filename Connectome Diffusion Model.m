%%Diffusion Network Model:
clc
clear all;

%% Load and Prepare Matrix

WM=load('WeightMatrix')
W=WM.Weights;
%W(i,j) is porportional average number of 
%connections begining at i terminating at j per unit volume. From Allen
%Mouse Brain ("A mesoscale connectome of the mouse
%brain", Oh et al, 2014). Specfically it is projection intensity divided by injection
%intensity.

Volumes=load('Volumes')
V=Volumes.Volume;
%Volume of regions in voxels from AMB Atlas.

%Weights depending on travel directions

Wr=W'.*V./V';            %retrograde spread

Wa=W.*V./V;              %anterograde spread

Wsym=((W+W')/2).*V./V';  %Mixed spread

%this suppposes that travel is always in a certain direction regardless of
%disease time point. It would not be hard to specificy a further paremeter
%that allowed switching between the directions



TractLengths=load('TractMatrix')
TL=TractLengths.TractLengths;
TL(TL==0)=inf;

%TL(i,j) is tract length from AMB. Self connections are made infinity since
%we later divide the weight matrix by these tract lengths; thus any self
%connection is given strength 0.


Ar   =Wr./TL-diag(diag((Wr./TL))); 
Aa   =Wa./TL-diag(diag((Wa./TL)));
Asym =Wsym./TL-diag(diag((Wsym./TL)));

%A(i,j) is projection strength from region from i to j
Ar=Ar./sum(sum(Ar));
Aa=Aa./sum(sum(Aa));
Asym=Asym./sum(sum(Asym));


%Defining Degree Out Matrices
Dr=diag(sum(Ar,1)); %sum rows for degree out matrix
Da=diag(sum(Aa,1)); 
Dsym=diag(sum(Asym,1)); 

%Graphical Laplacians
Lr=Dr-Ar; %definition in terms of adjacency and degree-out
La=Da-Aa; 
Lsym=Dsym-Asym; 

%Ordered Names:
RL=["AAA",	"ACAd",	"ACAv",	"ACB",	"AD",	"AHN",	"AId",	"AIp",	"AIv",...
    "AMB",	"AMd",	"AMv",	"AN",	"AOB",	"AON",	"APN",	"ARH",	"AUDd",...
    "AUDp",	"AUDv",	"AV",	"BLA",	"BMA",	"BST",	"CA1",	"CA2",	"CA3",...
    "CEA",	"CENT",	"CL",	"CLA",	"CLI",	"CM",	"COAa",	"COAp",	"CP",...
    "CS",	"CUL",	"CUN",	"DCO",	"DG",	"DMH",	"DN",	"DP",	"DR",...
    "ECT",	"ENTl",	"ENTm",	"EPd",	"EPv",	"FL",	"FN",	"FRP",	"FS",...
    "GPe",	"GPi",	"GRN",	"GU",	"IA",	"ICc",	"ICd",	"ICe",	"ILA",...
    "IMD",	"IO",	"IP",	"IPN",	"IRN",	"LA",	"LAV",	"LD",	"LGd",...
    "LGv",	"LH",	"LHA",	"LP",	"LPO",	"LRN",	"LSc",	"LSr",	"LSv",...
    "MA",	"MARN",	"MD",	"MDRNd",	"MDRNv",	"MEA",	"MEPO",	"MGd",...
    "MGm",	"MGv",	"MH",	"MM",	"MOB",	"MOp",	"MOs",	"MPN",	"MPO",...
    "MPT",	"MRN",	"MS",	"MV",	"NDB",	"NI",	"NLL",	"NLOT",	"NOD",...
    "NOT",	"NPC",	"NTS",	"ORBl",	"ORBm",	"ORBvl",	"OT",	"PA",...
    "PAA",	"PAG",	"PAR",	"PARN",	"PB",	"PCG",	"PERI",	"PF",	"PFL",...
    "PG",	"PGRNd",	"PGRNl",	"PH",	"PIR",	"PL",	"PMd",	"PO",...
    "POL",	"POST",	"PP",	"PPN",	"PRE",	"PRM",	"PRNc",	"PRNr",	"PRP",...
    "PSV",	"PT",	"PTLp",	"PVH",	"PVT",	"PVp",	"PVpo",	"PYR",	"RCH",...
    "RE",	"RH",	"RM",	"RN",	"RR",	"RSPagl",	"RSPd",	"RSPv",	"RT",...
    "SBPV",	"SCm",	"SCs",	"SF",	"SI",	"SIM",	"SMT",	"SNc",	"SNr",...
    "SOC",	"SPA",	"SPFm",	"SPFp",	"SPIV",	"SPVC",	"SPVI",	"SPVO",...
    "SSp-bfd",	"SSp-ll",	"SSp-m",	"SSp-n",	"SSp-tr",	"SSp-ul",...
    "SSs",	"STN",	"SUBd",	"SUB",	"SUM",	"SUT",	"SUV",	"TEa",	"TR",...
    "TRN",	"TRS",	"TT",	"TU",	"V",	"VAL",	"VCO",	"VII",	"VISC",...
    "VISal",	"VISam",	"VISl",	"VISp",	"VISpl",	"VISpm",	"VM",...
    "VMH",	"VPL",	"VPM",	"VPMpc",	"VTA",	"XII"]; %SUBv changed to SUB to fit with brainrender


%Regions Appearing in Rey et Al, Figure 4
ReyR=[  94, 15, 194, 129, 7, 8, 9, 49, 114, 4, 79, 80, 81, 36, 96, 177,...
        178, 179, 180, 181, 182, 55, 56, 106, 24, 75, 22, 23, 28, 87, 122, 46,...
        191, 18, 20, 190, 47, 48, 167, 168, 212, 186, 102];
[t,c]=ode45(@(t,c) BrainODE(c,t,Lr,paraHD),linspace(0,168,6*7*4),[(paraHD.k0/paraHD.k1).*ones(paraHD.N,1);zeros(93,1);1.5;zeros(paraHD.N-94,1)]);



%% Alpha Syn Projection Simulation

%Parameters for the Heterodimer Model
paraHD=struct('N',length(Ar),'ModelType',"HD",'k0',0.014.*(log(2)/14.8)*24,'k1',(log(2)/14.8)*24,'k3',(2.8e-05)*24,'k12',(10.7e-02)*24,'kap',[1,0.6]);

%The data in Rey et al. provides regions with a Pser129 score.
%“0= no inclusions”, “1= sparse inclusions”, “2= mild burden”,“3 = dense burden”, and “4= very dense”

%The matrix below contains the by-hand copied data and the Pser129 scores
%for regions in commen between Allen brain data and Rey et al data (and
%associated position in matrix). This is split into pairs of two columns,
%for data 3 MPI and 6 MPI for each strain

RD=load('ReyData.mat','ReyData');
RD=RD.ReyData;

Fibrils=RD(:,1:2);
Ribbons=RD(:,3:4);
F65=RD(:,5:6);
F91=RD(:,7:8);
F110=RD(:,9:10);


%Matrix to convert numbers to strain names
StrainToText=["Fibrils","Ribbons","F-65","F-91","F-110"];
k12=[8,2.55,(30.5e-02)*24,6.5,(16.5e-02)*24]; %example values for k12
kap=[0.1,4,0.12,0.6,0.1];
timepoints=[91,168]; %days


%plot data and concentrations from simulations

figure
for strain=1:4 %only first 4 for easy of plotting
paraHD=struct('N',length(Ar),'ModelType',"HD",'k0',0.014.*(log(2)/14.8)*24,...
    'k1',(log(2)/14.8)*24,'k3',(0.14*8.4*1e-05)*24,'k12',k12(strain),'kap',[1,kap(strain)]);

[t,c]=ode45(@(t,c) BrainODE(c,t,Lr,paraHD),linspace(0,168,6*7*4),[(paraHD.k0/paraHD.k1).*ones(paraHD.N,1);zeros(93,1);1.5;zeros(paraHD.N-94,1)]);

%concentrations of misfolded protein at 3 and 6 months
StrainBurden(:,:,strain) = c(timepoints,paraHD.N+ReyR)';
 
subplot(4,2,2*strain-1)
bar(RD(:,[2*strain-1,2*strain]))
xlim([0.5,43.5])
xticks([1:43])
xtickangle(45)
xticklabels(RL(ReyR))
ylim([0,3])
ylabel("Pser-129 Score "+StrainToText(strain))
set(gca,'fontsize', 9)
subplot(4,2,2*strain)
bar(StrainBurden(:,:,strain)) 
xlim([0.5,43.5])
xticks([1:43])
xticklabels(RL(ReyR))
xtickangle(45)
ylabel('Concentration \mu{M}')


set(gca,'fontsize', 9)

end

legend("3 MPI","6 MPI")


%% Final Data, Range of Behaviours across different parameter values and also directions
%This collects data with the intention of importing it to brain-render to
%visualise


%Collect data over a range of parameters, and scale so that has average
%scale on PIR for the appropriate data after 6 months (mean value 0.5875 on 1-4 scale)

%Since there is no precise way to connect concentrations to Pser129 scores,
%this code is designed only to give a visual representation of the spread
%assuming just the PIR region is scaled correctly


%Symmetric Transport
k12v=linspace(0.1,5,5);
kapv=linspace(0.01,2,5);
for ind1=1:length(k12v)
    for ind2=1:length(kapv)
        paraHD=struct('N',length(Asym),'ModelType',"HD",'k0',0.014.*(log(2)/14.8)*24,...
    'k1',(log(2)/14.8)*24,'k3',(0.14*8.4*1e-05)*24,'k12',k12v(ind1),'kap',[1,kapv(ind2)]);
        [t,c]=ode45(@(t,c) BrainODE(c,t,Lsym,paraHD),linspace(0,168,6*7*4),[(paraHD.k0/paraHD.k1).*ones(paraHD.N,1);zeros(93,1);1.5;zeros(paraHD.N-94,1)]);
        MPI3 = c(end/2,paraHD.N+ReyR)';
        MPI6 = c(end,paraHD.N+ReyR)';

        Table = array2table([MPI3,MPI6]'.*0.5875./MPI6(4)./4);
        Table.Properties.VariableNames=RL(ReyR);
        write(Table,"SymModelTable"+ind1+","+ind2+".csv")
    end
end

%Anterograde Transport

for ind1=1:length(k12v)
    for ind2=1:length(kapv)
        paraHD=struct('N',length(Asym),'ModelType',"HD",'k0',0.014.*(log(2)/14.8)*24,...
    'k1',(log(2)/14.8)*24,'k3',(0.14*8.4*1e-05)*24,'k12',k12v(ind1),'kap',[1,kapv(ind2)]);
        [t,c]=ode45(@(t,c) BrainODE(c,t,La,paraHD),linspace(0,168,6*7*4),[(paraHD.k0/paraHD.k1).*ones(paraHD.N,1);zeros(93,1);1.5;zeros(paraHD.N-94,1)]);
        MPI3 = c(end/2,paraHD.N+ReyR)';
        MPI6 = c(end,paraHD.N+ReyR)';

        Table = array2table([MPI3,MPI6]'.*0.5875./MPI6(4)./4);
        Table.Properties.VariableNames=RL(ReyR);
        write(Table,"AModelTable"+ind1+","+ind2+".csv")
    end
end


%Retrograde Transport

for ind1=1:length(k12v)
    for ind2=1:length(kapv)
        paraHD=struct('N',length(Lr),'ModelType',"HD",'k0',0.014.*(log(2)/14.8)*24,...
    'k1',(log(2)/14.8)*24,'k3',(0.14*8.4*1e-05)*24,'k12',k12v(ind1),'kap',[1,kapv(ind2)]);
        [t,c]=ode45(@(t,c) BrainODE(c,t,Lr,paraHD),linspace(0,168,6*7*4),[(paraHD.k0/paraHD.k1).*ones(paraHD.N,1);zeros(93,1);1.5;zeros(paraHD.N-94,1)]);
        MPI3 = c(end/2,paraHD.N+ReyR)';
        MPI6 = c(end,paraHD.N+ReyR)';

       Table = array2table([MPI3,MPI6]'.*0.5875./MPI6(4)./4);
       Table.Properties.VariableNames=RL(ReyR);
       write(Table,"RModelTable"+ind1+","+ind2+".csv")
    end
end


%% Fuction
function dc=BrainODE(c,t,L,para)

if para.ModelType=="FK"
    dc=zeros(para.N,1);
    dc=-para.kap(2).*L*c+para.alpha.*c.*(1-c);
elseif para.ModelType=="HD"
    dc=zeros(2*para.N,1);
    dc(1:para.N)    = -para.kap(1).*L*c(1:para.N)+para.k0...
                      -c(1:para.N).*para.k1...
                      -c(1:para.N).*c(para.N+1:end).*para.k12;
    dc(para.N+1:end)= -para.kap(2).*L*c(para.N+1:end)...
                      -c(para.N+1:end).*para.k3...
                      +c(1:para.N).*c(para.N+1:end).*para.k12;
end




end

