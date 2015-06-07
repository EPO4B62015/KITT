function Grid_Update(new_x,new_y) %Geef de verwijzing naar Grid mee?

global pos_x;
global pos_y;
%  
% Grid_up = guidata(Grid); %Output from Grid is hObject

pos_x(end+1) = new_x;
pos_y(end+1) = new_y;
%Update the position of the car
handles.x = pos_x;
handles.y = pos_y;

%Update the handles
guidata(Grid, handles);
guidata(Grid, handles);
end


