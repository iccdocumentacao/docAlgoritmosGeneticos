
%%Genetic Algorithm for permutation problems
% minimizes the objective function designated in ff
%
% Haupt and Haupt, 2003
% Edited and modified by Hundley and Carr, 2014
%clear

global iga x y
%% Setup the GA
ff='tspfun';% filename objective function

npar=6;% # of optimization variables 20
Nt=npar;% # of columns in population matrix
x=rand(1,npar);
y=rand(1,npar); % cities are at (xcity,ycity)
% Uncomment next line to use the same set of cities in multiple runs
% load cities0

% Stopping criteria
maxit=100; % max number of iterations 1000
% GA parameters
popsize=6; % set population size 20
mutrate=.05; % set mutation rate
selection=0.5; % fraction of population kept

keep=floor(selection*popsize); % #population members that survive

M=ceil((popsize-keep)/2); % number of matings
odds=1;
for ii=2:keep
    odds=[odds ii*ones(1,ii)];
end
Nodds=length(odds);
odds=keep-odds+1; % odds determines probabilities for being parents

% Create the initial population
iga=0; % generation counter initialized
for iz=1:popsize
    pop(iz,:)=randperm(npar); % random population
end

cost=feval(ff,pop); % calculates population cost using ff
[cost,ind]=sort(cost); %min cost in element 1
pop=pop(ind,:); %sort population with lowest cost first
minc(1)=min(cost); %minc contains min of population
meanc(1)=mean(cost); %meanc contains mean of population

%% Iterate through generations (MAIN LOOP)
while iga<maxit
iga=iga+1; % increments generation counter

% Pair and mate
pick1=ceil(Nodds*rand(1,M)); % mate #1
pick2=ceil(Nodds*rand(1,M)); % mate #2
% ma and pa contain the indices of the parents
ma=odds(pick1);
pa=odds(pick2);

% Performs mating
for ic=1:M
mate1=pop(ma(ic),:);
mate2=pop(pa(ic),:);
indx=2*(ic-1)+1; % odd numbers starting at 1
xp=ceil(rand*npar); % random value between 1 and N
temp=mate1;
x0=xp;
while mate1(xp)~=temp(x0)
mate1(xp)=mate2(xp);
mate2(xp)=temp(xp);
xs=find(temp==mate1(xp));
xp=xs;
end
pop(keep+indx,:)=mate1;
pop(keep+indx+1,:)=mate2;
end
% Mutate the population
nmut=ceil(popsize*npar*mutrate);
for ic = 1:nmut
row1=ceil(rand*(popsize-1))+1;
col1=ceil(rand*npar);
col2=ceil(rand*npar);
temp=pop(row1,col1);
pop(row1,col1)=pop(row1,col2);
pop(row1,col2)=temp;
im(ic)=row1;
end
cost=feval(ff,pop);
%_______________________________________________________
% Sort the costs and associated parameters
part=pop;
costt=cost;
[cost,ind]=sort(cost);
pop=pop(ind,:);
%_______________________________________________________
% Do statistics
minc(iga)=min(cost);
meanc(iga)=mean(cost);
end %iga

%_______________________________________________________
% Displays the output
%day=clock;
%disp(datestr(datenum(day(1),day(2),day(3),day(4),day(5),day(6)),0))
%disp(['optimized function is ' ff])
%format short g
%disp(['popsize=' num2str(popsize) 'mutrate=' num2str(mutrate) '# par=' num2str(npar)])
%disp(['best cost=' num2str(cost(1))])
%disp(['best solution']); disp([num2str(pop(1,:))])

figure(1);
plot([x(pop(1,:)) x(pop(1,1))],[y(pop(1,:)) y(pop(1,1))],x,y,'o');
axis square;

figure(2)
iters=1:maxit;
plot(iters,minc,iters,meanc,'--');
xlabel('generation');
ylabel('cost');


