inputfilename = 'semanticextension.txt';
filetext = fileread(inputfilename);
lines = strsplit(filetext, '\n');
for i = 1:5
    temp = strsplit(lines{i}, ':');
    temp
    lines{i} = temp{2};
end
numlayers = str2num(lines{1});
unitsperlayer = str2num(lines{2});
fullyconnected = str2num(lines{3});
weights = cell(numlayers - 1);
connections = cell(numlayers - 1);
if ~fullyconnected
    connections = strsplit(lines{4}, '//');
    for layer = 1:numlayers-1
        connections{layer} = str2num(connections{layer});
    end
end
trainingpairs = str2num(lines{5});
inputs = cell(1, trainingpairs);
for i = 1:trainingpairs
    io = strsplit(lines{6+i}, ',');
    targets{i} = str2num(io{2});
    inputs{i} = cell(1, numlayers);
    temp = strsplit(io{1}, '//');
    for j = 1:length(temp)
        inputs{i}{j} = str2num(temp{j});
    end
end
noninputsperlayer = zeros(1, numlayers);
for i = 1:numlayers
    noninputsperlayer(i) = unitsperlayer(i) - length(inputs{1}{i});
end

for i = 1:numlayers-1
    for j = 1:unitsperlayer(i) + 1
        for k = 1:noninputsperlayer(i+1)
            if ~fullyconnected 
               if connections{i}(j, k) == 0
                   weights{i}(j, k) = 0;
               else
                   weights{i}(j, k) = randn();
               end
            else
                connections{i}(j, k) = 1;
                weights{i}(j, k) = randn();
            end
        end
    end
end
for i = 1:2001
    for trial = 1:trainingpairs
        weights = cellfun(@(x,y){x+y}, weights, trainoninput(numlayers, unitsperlayer, connections, weights, inputs{trial}, targets{trial}));
    end
    if mod(i, 100) == 1
        outputfilename = strcat('semanticoutput', num2str(i), '.txt');
        outputfile = fopen(outputfilename, 'w');
        for trial = 1:8
            activations = simulate(numlayers, unitsperlayer, weights, inputs{trial*4});
            activations{4}
            fprintf(outputfile, '%8.7f ', activations{2}(1:8));
            fprintf(outputfile, '\n');
        end
    end
end
testinput = cell(1, numlayers);
testinput{1} = [0 0 0 0 0 0 0 0 1];
testinput{2} = [0 1 0 0];
%activations = simulate(numlayers, unitsperlayer, weights, testinput);
%activations{4};