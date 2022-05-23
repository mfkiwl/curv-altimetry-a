function varargout = negsemilogy (x, y, varargin)
  [varargout{1:nargout}] = semilogy(x, abs(y), varargin{:});
  %if all(y > 0),  return;  end
  
  negyticklab = @(ytl) strcat('-', ytl);
  setnegyticklab = @(ah) set(ah, 'YTickLabel', negyticklab(get(ah, 'YTickLabel')));
  %nlxticklab = @(xtl) strcat(xtl, newline());
  nlxticklab = @(xtl) strcat(xtl, '\newline.');
  setnlxticklab = @(ah) set(ah, 'XTickLabel', nlxticklab(get(ah, 'XTickLabel')));
  
  ah=gca();
  set(ah, 'YDir','reverse')
  set(ah, 'XAxisLocation','top')
  
  %setnegyticklab(ah);
  %setnlxticklab(ah);
  %fix_xticklabels(ah)
  %return  % DEBUG
  
  %set(gcf(), 'ResizeFcn',{@(s,e) setnegyticklab(ah)});
  %ticklabelformat(ah, 'y', @(s,e) setnegyticklab(ah));
  ticklabelformat(ah, 'y', @(s,e) setnegyticklab_ifunset(ah));
  ticklabelformat(ah, 'x', @(s,e) setnlxticklab_ifunset(ah));
  
  function setnegyticklab_ifunset (ah)
    ytl = get(ah, 'YTickLabel');
    if (ytl{1}(1) == '-')
      return;
    else
      setnegyticklab (ah);
    end
  end
  function setnlxticklab_ifunset (ah)
    xtl = get(ah, 'XTickLabel');
    if (xtl{1}(end) == '.')
      return;
    else
      setnlxticklab (ah);
      %TODO:
      %fix_xticklabels(ah);
    end
  end
end
