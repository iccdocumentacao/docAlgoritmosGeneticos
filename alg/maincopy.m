global iga x y

%% Configura GA
fo='funcobj'; % nome do arquivo da funcao objetivo

nvar=6; % # variaveis 6
Nt=nvar;% # colunas matrix

% pontos (xcity,ycity)
% Carrega cidades
x=rand(1,nvar);
y=rand(1,nvar); 

% criterio de parada
iteracao=50; % numero maximo de iteracao
% Parametros do AG
popsize=6; % tamanho da populacao
taxamut=.05; % taxa de mutacap
selection=0.5; % guardar uma quantidade da populacao

manter=floor(selection*popsize); % quantidade da populacao que sobrevivera
% A função floor arredonda a quantidade da populacao

cruzamento=ceil((popsize-manter)/2); %numero de cruzamentos

%Determinar probabilidades para selecao baseado  nos primeiros cromossomos
% odds determina a probabilidade para ser pais
odds=1;
for ii=2:manter
    odds=[odds ii*ones(1,ii)];
end
Nodds=length(odds);
odds=manter-odds+1;

% Cria a populacao inicial
iga=0; % contador para iniciar a geracao
for iz=1:popsize
    pop(iz,:)=randperm(nvar); % populacao randomica. randperm, metodo escolhe pontos aleatorios (x, y) uniformemente. 
end

cost=feval(fo,pop); % calcula custo da populacao usando fo. A funcao permite que se tenha uma entrada string (sequencia de caracteres) como uma entrada, como nome de outra funcao.
[cost,ind]=sort(cost); %custo minimo no elemento 1
pop=pop(ind,:); %individuo com menor custo da populacao
minc(1)=min(cost); % num minimo da populacao
meanc(1)=mean(cost); % media da populacao

%% Iteracao das geracoes (MAIN LOOP)
while iga<iteracao
    iga=iga+1; % contador de geracao

% Par
escolhe1=ceil(Nodds*rand(1,cruzamento)); % pai 1
escolhe2=ceil(Nodds*rand(1,cruzamento)); % pai 2
% ma and pa sao os indices dos parametros
ma=odds(escolhe1);
pa=odds(escolhe2);

% Realizar cruzamenta
for ic=1:cruzamento
    pai1=pop(ma(ic),:);
    pai2=pop(pa(ic),:);
    indx=2*(ic-1)+1; % numeros impares a partir 1
    xp=ceil(rand*nvar); % valores randomicos entre 1 e N
    temp=pai1;
    x0=xp;
    while pai1(xp)~=temp(x0)
        pai1(xp)=pai2(xp);
        pai2(xp)=temp(xp);
        xs=find(temp==pai1(xp));
        xp=xs;
    end
    pop(manter+indx,:)=pai1;
    pop(manter+indx+1,:)=pai2;
end

% Mutacao da populacao
nmut=ceil(popsize*nvar*taxamut);

for ic = 1:nmut
    row1=ceil(rand*(popsize-1))+1;
    col1=ceil(rand*nvar);
    col2=ceil(rand*nvar);
    temp=pop(row1,col1);
    pop(row1,col1)=pop(row1,col2);
    pop(row1,col2)=temp;
    im(ic)=row1;
end
cost=feval(fo,pop);

%_______________________________________________________
% classificação de custos
part=pop;
costt=cost;
[cost,ind]=sort(cost);
pop=pop(ind,:);
%_______________________________________________________

% calcular a estatisticas
minc(iga)=min(cost);
meanc(iga)=mean(cost);
end 

figure(1);
plot([x(pop(1,:)) x(pop(1,1))],[y(pop(1,:)) y(pop(1,1))],x,y,'o');
axis square;


