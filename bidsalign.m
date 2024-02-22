function bidsalign( guistatus )

filePath = mfilename('fullpath');
filePath = filePath(1:length(filePath)-9);
s  = pathsep;
pathStr = [s, path, s];

libpath = [filePath '__lib'];
onPathLib  = contains(pathStr, [s, libpath, s], 'IgnoreCase', ispc);

GUIpath = [filePath '__lib' filesep 'GUI'];
onPathGUI  = contains(pathStr, [s, GUIpath, s], 'IgnoreCase', ispc);

if ~(onPathLib && onPathGUI)
    addpath([filePath filesep '__lib'])
    addpath([filePath filesep '__lib' filesep 'GUI'])
    disp('Added Path to BIDSAlign function')
end

switch nargin
    case 0
        BIDSAlign_GUI
    case 1
        if strcmpi(guistatus, 'nogui')
            disp('---------------------------------------------------------')
            disp('  BIDSAlign functions can be excecuted without problems.')
            disp('  To open the GUI, simply run bidsalign.')
            disp('---------------------------------------------------------')
        end
end

end