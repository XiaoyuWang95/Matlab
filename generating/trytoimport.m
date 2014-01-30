newData1 = importdata('004_base.txt.');

% Create new variables in the base workspace from those fields.
vars = fieldnames(newData1);
for i = 1:length(vars)
    assignin(baseline, vars{i}, newData1.(vars{i}));
end

