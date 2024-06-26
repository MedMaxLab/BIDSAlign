function [output]=string2boolean(str)
    % FUNCTION: string2boolean
    %
    % Description: Converts a string representation of a boolean to a logical value.
    %
    % Syntax:
    %   output = string2boolean(string)
    %
    % Input:
    %   - str (string): String representation of a boolean ('true' or 'false').
    %
    % Output:
    %   - output (logical): Logical value corresponding to the input string.
    %
    % Author: [Federico Del Pup]
    % Date: [25/01/2024]
    %
    
    if strcmpi(str,'false') || isequal(str, 0) || ...
            strcmpi(str, 'off') || strcmpi(str, 'no')
      output = false;
    else
      output = true;
    end
end
