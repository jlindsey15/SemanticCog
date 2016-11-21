inputfilename = 'semanticoutput2001.txt';
filetext = fileread(inputfilename);
lines = strsplit(filetext, '\n');
representations = zeros(length(lines) - 1, length(strsplit(lines{1})) - 1);
for i = 1:length(lines) - 1
    temp = strsplit(lines{i});
    for j = 1:length(temp) - 1
        representations(i, j) = str2double(temp{j});
    end
end
tree = linkage(representations);
dendrogram(tree);
axis([0, 9, 0, 1.5]);