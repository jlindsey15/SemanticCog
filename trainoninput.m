function changeinweights = trainoninput( numlayers, unitsperlayer, connections, weights, inputs, target )
changeinweights = cell(numlayers - 1);
learningrate = 0.1;
bias = 1;
activations = simulate(numlayers, unitsperlayer, weights, inputs);
for layer = 1:numlayers
    activations{layer}(end+1) = bias;
end
errors = cell(numlayers);
deltas = cell(numlayers);
errors{numlayers} = (target ./ activations{numlayers}(1:end-1)) - ((1 - target) ./ (1 - activations{numlayers}(1:end-1)));
deltas{numlayers} = errors{numlayers} .* activations{numlayers}(1:end-1) .* (1 - activations{numlayers}(1:end-1));
for layer = (numlayers - 1):-1:2
    for unit = 1 : unitsperlayer(layer) - length(inputs{layer})
        errors{layer}(unit) = deltas{layer + 1} * weights{layer}(unit, :)';
    end
    deltas{layer} = errors{layer} .* activations{layer}(1 : unitsperlayer(layer) - length(inputs{layer})) .* (1 - activations{layer}(1 : unitsperlayer(layer) - length(inputs{layer})));
end
for layer = 1 : numlayers - 1
    changeinweights{layer} = zeros(unitsperlayer(layer), unitsperlayer(layer+1) - length(inputs{layer+1}));
    for unit = 1 : unitsperlayer(layer) + 1
        changeinweights{layer}(unit, connections{layer}(unit, :) == 1) = learningrate * activations{layer}(unit) * deltas{layer + 1}(connections{layer}(unit, :) == 1);
    end
end
end