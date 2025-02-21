function cdypress_update_v1


handles     = guidata(findall(0,'Tag','cdypress_main_fig'));

cdypress    = mcacache(handles.cdy_press);      % cindy pressure
xspecpress  = mcacache(handles.xspec_press);    % xray spec pressure


% update display
set(handles.show_cdy_press,'String',...
    strcat(num2str(cdypress,'%1.1e'),' mbar'));
set(handles.show_xspec_press,'String',...
    strcat(num2str(xspecpress,'%1.1e'),' mbar'));


end