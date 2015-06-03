function Grid_Update(new_x,new_y)
global data
%Get the Grid information
data = guidata(Grid);


handles.x = data.x;
handles.y = data.y;
%Update the position of the car
handles.x(end+1) = new_x
handles.y(end+1) = new_y

%Update the handles
guidata(Grid, handles);
end


