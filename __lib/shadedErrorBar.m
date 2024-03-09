function [H] = shadedErrorBar(x,y,errBar,lineProps)
    % FUNCTION: shadedErrorBar
    %
    % Description: Plot a line with shaded error bars around it.
    %
    % Syntax:
    %   [H] = shadedErrorBar(x, y, errBar, lineProps)
    %
    % Input:
    %   - x (vector): x-axis values.
    %   - y (vector or matrix): y-axis values.
    %   - errBar (matrix): Error bar values.
    %   - lineProps (cell array): Properties of the main line (e.g., color, line style).
    %
    % Output:
    %   - H (structure): Structure containing handles for the main line, shaded region, and edge lines.
    %
    % Author: [Andrea Zanola]
    % Date: [06/03/2024]

   %% Check Inputs
    y=y(:)';
    
    if isempty(x)
        x=1:length(y);
    else
        x=x(:)';
    end
    
    if length(x) ~= length(y)
        error('WRONG LENGTH BETWEEN X and Y');
    end
    
    if length(errBar)==length(errBar(:))
        errBar=repmat(errBar(:)',2,1);
    else
        f=find(size(errBar)==2);
        if isempty(f), error('errBar has the wrong size'), end
        if f==2, errBar=errBar'; end
    end
    
    if length(x) ~= length(errBar)
        error('WRONG LENGTH BETWEEN X and ERRORBAR');
    end
    
    %% Plot Errobars
    if ~iscell(lineProps)
        lineProps={lineProps}; 
    end
    
    H.mainLine=plot(x,y,lineProps{:},'HandleVisibility','off','LineWidth',1.5);
    
    col=get(H.mainLine,'color');
    edgeColor=col+(1-col)*0.55;
    set(gcf,'renderer','openGL')
    
    holdStatus=ishold;
    if ~holdStatus, hold on,  end
    
    upper=y+errBar(1,:);
    lower=y-errBar(2,:);

    yP=[lower,fliplr(upper)];
    xP=[x,fliplr(x)];
    
    xP(isnan(yP))=[];
    yP(isnan(yP))=[];
    
    H.patch=patch(xP,yP,1,'facecolor',col,'edgecolor','none','facealpha',0.15);
    H.edge(1)=plot(x,lower,'-','color',edgeColor,'HandleVisibility','off');
    H.edge(2)=plot(x,upper,'-','color',edgeColor,'HandleVisibility','off');
    
    if ~holdStatus, hold off, end

end