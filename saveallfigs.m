% saves all currently open figures as png to figs folder
function [] = saveallfigs(overwrite)

    if nargin == 0
        overwrite = false;
    end

    FolderName = 'figs';   % Your destination folder
    FigList = findobj(allchild(0), 'flat', 'Type', 'figure');
    for iFig = 1:length(FigList)
        FigHandle = FigList(iFig);
        if ~strcmp(FigHandle.Tag, 'EmbeddedFigure_Internal') % ignore live script inline plots
            FigName   = [num2str(get(FigHandle, 'Number')) '.png'];
            set(0, 'CurrentFigure', FigHandle);
            pathName = fullfile(FolderName, FigName);
            if ~overwrite
                while exist(pathName,'file') == 2 % don't overwrite existing figs
                    pathName = [pathName(1:end-4) '-(1).png'];
                end
            end
            saveas(FigHandle,pathName);
        end
    end

end