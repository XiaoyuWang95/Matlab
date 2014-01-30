function value = twos_complement(x, numBits)

    % Check the value of the MSB.  To accomodate any data word size, we
    % perform bit shifting operations, rather than trying select the
    % position of the bit
    msb = bitshift(x, -(numBits - 1) );
    
    % A negative number will have a '1' for the MSB.  A positive number
    % will simply have the same output as the input.
    if (true == msb)
        % Dealing with a negative number.  To determine what
        % it is a negative of, take the one's complement and
        % add 1, per standard 2's complement encoding convention
        value = -1 * ( bitcmp(x, numBits) + 1 );
    else
        value = x;
    end
    
end

