function activations = simulate( numlayers, unitsperlayer, weights, inputs )
bias = 1;
activations = cell(numlayers);
for layer = 1:numlayers
    for unit = 1:unitsperlayer(layer) - length(inputs{layer})
        input = activations{layer - 1} * weights{layer - 1}(:, unit);
        activations{layer}(unit) = logistic(input);
    end
    activations{layer}(end + 1 : unitsperlayer(layer)) = inputs{layer};
    activations{layer}(end + 1) = bias;
end
for layer = 1:numlayers
    activations{layer} = activations{layer}(1:end-1);
end
end
