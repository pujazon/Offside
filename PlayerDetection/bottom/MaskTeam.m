%%
%% MaskTeam:    
%               Get RGB mean of each RGB Peaks Team B Player 
%               Get RGB mean of each RGB Peaks Team A Player 
%
for k = 1:1
%% Declare Variables

N=5;

TeamA = cell(1,N);
TeamB = cell(1,N);

RLevelTeamB = cell(1,N);
GLevelTeamB = cell(1,N);
BLevelTeamB = cell(1,N);

countRTeamB = cell(1,N);
countGTeamB = cell(1,N);
countBTeamB = cell(1,N);

RLevelTeamA = cell(1,N);
GLevelTeamA = cell(1,N);
BLevelTeamA = cell(1,N);

countRTeamA = cell(1,N);
countGTeamA = cell(1,N);
countBTeamA = cell(1,N);

RPeak = zeros(N);
GPeak = zeros(N);
BPeak = zeros(N);

PixelsRPeak = 0;
PixelsGPeak = 0;
PixelsBPeak = 0;


%% Get Teams

%TeamA
for i = 1:N

    path = sprintf('./img/test4_players/a%d.png',i);
    
    TeamA{i}= imread(path);
    fprintf("PlayerA(i) rows = %d\n",i,size(TeamA{i},1));
 
end

%TeamB
for i = 1:N
       
    path = sprintf('./img/test4_players/b%d.png',i);
    
    TeamB{i}= imread(path);
    fprintf("PlayerB(i) rows = %d\n",i,size(TeamB{i},1));
 
end

%% Get Histograms

%Take Histograms
for i = 1:N
    
    %TeamB
    [BcountR, BtmpR] = imhist(TeamB{i}(:,:,1));
    [BcountG, BtmpG] = imhist(TeamB{i}(:,:,2));
    [BcountB, BtmpB] = imhist(TeamB{i}(:,:,3));
    
    RLevelTeamB{i} = BtmpR;
    GLevelTeamB{i} = BtmpG;
    BLevelTeamB{i} = BtmpB;     

    countRTeamB{i} = BcountR;
    countGTeamB{i} = BcountG;
    countBTeamB{i} = BcountB;    
    
    %TeamA
    [AcountR, AtmpR] = imhist(TeamA{i}(:,:,1));
    [AcountG, AtmpG] = imhist(TeamA{i}(:,:,2));
    [AcountB, AtmpB] = imhist(TeamA{i}(:,:,3));
    
    RLevelTeamA{i} = AtmpR;
    GLevelTeamA{i} = AtmpG;
    BLevelTeamA{i} = AtmpB;     

    countRTeamA{i} = AcountR;
    countGTeamA{i} = AcountG;
    countBTeamA{i} = AcountB;
 
end

%Printf Histograms
for i = 1:N
    %fprintf("Player B(%d) Greens\n",i);
    %countGTeamA{i}
    
    figure, subplot(3,1,1);
    x = linspace(0,10,50);
    R=[countRTeamB{i}];
    plot(R,'r');
    title('RED 1')
    
    subplot(3,1,2);
    G=[countGTeamB{i}];
    plot(G,'g');
    title('GREEN 2')
    
    subplot(3,1,3);
    B=[countBTeamB{i}];
    plot(B,'b');
    title('BLUE 3')    
    
end

%% RGB TeamB

TeamB_RPeak = 0;
TeamB_GPeak = 0;
TeamB_BPeak = 0;

%RPeak(n), GPeak(n), BPeak(n) TeamB
for i = 1:N
    
    auxCountsR = countRTeamB{i};
    auxCountsG = countGTeamB{i};
    auxCountsB = countBTeamB{i};
    PixelsRPeak = 0;
    PixelsGPeak = 0;
    PixelsBPeak = 0;
    
        fprintf("index %d\n",i);
    
    for j = 1:255     
        %fprintf("R: Value %d #pixels = %d, max = %d\n",j,auxCountsR(j),PixelsRPeak);
        if(auxCountsR(j) > PixelsRPeak)
            RPeak(i) = j;
            PixelsRPeak = auxCountsR(j);
        end

        if(auxCountsG(j) > PixelsGPeak)
            GPeak(i) = j;
            PixelsGPeak = auxCountsG(j);
        end

        if(auxCountsB(j) > PixelsBPeak)
            BPeak(i) = j;
            PixelsBPeak = auxCountsB(j);
        end
        
    end
    
    TeamB_RPeak = TeamB_BPeak + RPeak(i);
    TeamB_GPeak = TeamB_BPeak + GPeak(i);
    TeamB_BPeak = TeamB_BPeak + BPeak(i);
end

TeamB_RPeak = floor(TeamB_RPeak/N);
TeamB_GPeak = floor(TeamB_GPeak/N);
TeamB_BPeak = floor(TeamB_BPeak/N);

%Print R,G,B Peaks
for i = 1:N
    fprintf("B(%d): RGB: (%d,%d,%d)\n",i,RPeak(i),GPeak(i),BPeak(i));
end
fprintf("Team B RGB: (%d,%d,%d)\n",TeamB_RPeak,TeamB_GPeak,TeamB_BPeak);


%% RGB TeamA

TeamA_RPeak = 0;
TeamA_GPeak = 0;
TeamA_BPeak = 0;

%RPeak(n), GPeak(n), BPeak(n) TeamA
for i = 1:N
    
    auxCountsR = countRTeamA{i};
    auxCountsG = countGTeamA{i};
    auxCountsB = countBTeamA{i};
    PixelsRPeak = 0;
    PixelsGPeak = 0;
    PixelsBPeak = 0;
    
        fprintf("index %d\n",i);
    
    for j = 1:255     
        %fprintf("R: Value %d #pixels = %d, max = %d\n",j,auxCountsR(j),PixelsRPeak);
        if(auxCountsR(j) > PixelsRPeak)
            RPeak(i) = j;
            PixelsRPeak = auxCountsR(j);
        end

        if(auxCountsG(j) > PixelsGPeak)
            GPeak(i) = j;
            PixelsGPeak = auxCountsG(j);
        end

        if(auxCountsB(j) > PixelsBPeak)
            BPeak(i) = j;
            PixelsBPeak = auxCountsB(j);
        end
        
    end
    
    TeamA_RPeak = TeamA_RPeak + RPeak(i);
    TeamA_GPeak = TeamA_GPeak + GPeak(i);
    TeamA_BPeak = TeamA_BPeak + BPeak(i);
    
end

TeamA_RPeak = floor(TeamA_RPeak/N);
TeamA_GPeak = floor(TeamA_GPeak/N);
TeamA_BPeak = floor(TeamA_BPeak/N);

%Print R,G,B Peaks
for i = 1:N
    fprintf("A(%d): RGB: (%d,%d,%d)\n",i,RPeak(i),GPeak(i),BPeak(i));
end
fprintf("Team A RGB: (%d,%d,%d)\n",TeamA_RPeak,TeamA_GPeak,TeamA_BPeak);

end
