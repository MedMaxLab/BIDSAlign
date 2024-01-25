function [output]=string2boolean(string)
    % FUNCTION: string2boolean
    %
    % Description: Converts a string representation of a boolean to a logical value.
    %
    % Syntax:
    %   output = string2boolean(string)
    %
    % Input:
    %   - string: String representation of a boolean ('true' or 'false').
    %
    % Output:
    %   - output: Logical value corresponding to the input string.
    %
    % Author: [Federico Del Pup]
    % Date: [25/01/2024]
    %
   if strcmp(string,'false') || strcmpi(string,'false')
     output = false;
   else
     output = true;
   end
end
