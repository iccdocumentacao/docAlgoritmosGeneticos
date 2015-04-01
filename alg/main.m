
global iga x y
%% Configura GA

npar=20;% # variaveis 
Nt=npar;% # numero de colunas matrix

x=rand(1,npar);
y=rand(1,npar); % Carrega os pontos (parametros),(xp,yp)

% Criterio de parada
maxit=60; % Numero maximo de iteração

% GA parameters
popsize=6; % tamanho da população
taxamut=.05; % taxa de mutação
select=0.5; % taxa de seleção para guardada da popul.

keep=floor(select*popsize); % Quantidade da população qie sobrevive - # Afunção floor arredonda a quantidade da população

M=ceil((popsize-keep)/2); % numero de cruzamentos
%Determina a probabilidade para seleção baseado nos primeiros cromossomos - odds determina a probabilidade para os filhos serem pais, baseados 
% na quantidade quantidade da pop. que sobrevive.

odds=1;
for ii=2:keep
    odds=[odds ii*ones(1,ii)];
end
Nodds=length(odds);
odds=keep-odds+1;

% Cria a população inicial
iga=0; % Contador para iniciar a geração
for iz=1:popsize
    pop(iz,:)=randperm(npar); %randperm, metodo escolhe pontos aleatorio nos xis uniformemente.
end

cost=feval(fo,pop); % calcula custo da populacao usando fo. A funcao permite que se tenha uma entrada string (sequencia de caracteres) como uma entrada, como nome de outra funcao.
[cost,ind]=sort(cost); %custo minimo no elemento 1
pop=pop(ind,:); %individuo com menor custo da populacao
minc(1)=min(cost); %num minimo da populacao
meanc(1)=mean(cost); %media da populacao

%% Iteracao das geracoes (MAIN LOOP)
while iga<maxit
iga=iga+1; % Contador de gerações

% Pais
escolhe1=ceil(Nodds*rand(1,M)); % Pai #1
escolhe2=ceil(Nodds*rand(1,M)); % Pai #2

% ma e pa Contem indices dos parametos
ma=odds(escolhe1);
pa=odds(escolhe2);

% Realiza Cruzamento
for ic=1:M
mate1=pop(ma(ic),:);
mate2=pop(pa(ic),:);
indx=2*(ic-1)+1; % Numeros impares a partir de 1 
xp=ceil(rand*npar); % valores randomicos entre 1 e N
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

% Mutação da população
nmut=ceil(popsize*npar*taxamut);
for ic = 1:nmut
row1=ceil(rand*(popsize-1))+1;
col1=ceil(rand*npar);
col2=ceil(rand*npar);
temp=pop(row1,col1);
pop(row1,col1)=pop(row1,col2);
pop(row1,col2)=temp;
im(ic)=row1;
end
cost=feval(fo,pop);
%_______________________________________________________
% Organizaçao dos custos e parametros associados
part=pop;
costt=cost;
[cost,ind]=sort(cost);
pop=pop(ind,:);
%_______________________________________________________
% Realiza calcula as estatisticas produzindo um vetor linha com os resultados obtidos 
minc(iga)=min(cost); %Menor valor
meanc(iga)=mean(cost);% Obtem o valor medio 
end 
%_______________________________________________________
%Imprime
fo='funcobj'; % nome do arquivo da funcao objetivo
disp(['Funcao para otimizar é: ' fo])

%format short g
%disp(['popsize=' num2str(popsize) 'taxamut=' num2str(taxamut) '# par=' num2str(npar)])
disp(['Melhor Custo=' num2str(cost(1))])
disp(['Melhor Solução']); disp([num2str(pop(1,:))])

figure(1);
plot([x(pop(1,:)) x(pop(1,1))],[y(pop(1,:)) y(pop(1,1))],x,y,'o');
axis square;

figure(2)
iters=1:maxit;
plot(iters,minc,'--');
xlabel('geração');
ylabel('custo');


