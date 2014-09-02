function [frames, videoInfo] = extractDataForObservation(labelPath, video)
disp(strcat('extacting: ',video));
label = dlmread(labelPath,';',1,0);
[noFrames,~] = size(label);
videoInfo.noFrames = noFrames;
[Models,option] = xx_initialize;

% check video
if exist(video,'file') == 2 % if it is a file
  cap = cv.VideoCapture(video);
  frame_w = cap.get('FrameWidth');
  frame_h = cap.get('FrameHeight');
  videoInfo.frame_w = frame_w;
  videoInfo.frame_h = frame_h;
else
  error('Input file not exist');
end

% create a figure to draw upon
S.fh = figure('units','pixels',...
              'position',[100 50 frame_w frame_h],...
              'menubar','none',...
              'name','INTRAFACE_TRACKER',...              
              'numbertitle','off',...
              'resize','off',...
              'renderer','painters');

% create axes
S.ax = axes('units','pixels',...  
            'position',[1 1 frame_w frame_h],...
            'drawmode','fast');
          
set(S.fh,'KeyPressFcn',@pb_kpf);


%% AviObj for the triangulation Video
observationDir = 'data/observationData/';
if ~exist(observationDir,'dir')
   mkdir(observationDir);
end
stop_pressed = false;
drawed = false;     % not draw anything yet
output.pred = [];   % prediction set to null enabling detection
poseline = 60;      % head pose axis line length
loc = [70 70];      % where to draw head pose
frames = cell(noFrames,1); % where to save frames

S.im_h = imshow(zeros(frame_h,frame_w,3,'uint8'));
hold on;

%% tracking and detection
% Press 'Esc' to quit.
count = 0;
while true && ~stop_pressed
  tic;
  im = cap.read;
  
  if isempty(im), 
    warning('EOF'); 
    break ;
  end
  
  % main function for tracking. previous prediction is used as an video to
  % initialize the tracker for the next frame.
  output = xx_track_detect(Models,im,output.pred,option);
  count = count + 1;
  set(S.im_h,'cdata',im); % update frame
  
  te = toc;
  if isempty(output.pred) % if lost/no face, delete all drawings
    if drawed, delete_handlers(); end
  else % else update all drawings
    update_GUI();
  end
  
  drawnow;
  frames{count} = getframe;
end

close;


%% 
    % private function for deleting drawing handlers
    function delete_handlers() 
      delete(S.pts_h); 
      delete(S.time_h);
      if option.compute_pose
        delete(S.hh{1}); delete(S.hh{2}); delete(S.hh{3});
      end
   
      drawed = false;
    end
    % helper function for drawing head pose
    function p2D = projpose(pose,l)
      po = [0,0,0; l,0,0; 0,-l,0; 0,0,-l];
      p2D = po*pose.rot(1:2,:)' + repmat(loc,4,1);
    end
  
    % private function for updating/creating drawing
    function update_GUI()
    
      if drawed % faster to update than to creat new drawings
        % update head pose
        if option.compute_pose
          p2D  = projpose(output.pose,poseline); 
          set(S.hh{1},'xdata',[p2D(1,1) p2D(2,1)],'ydata',[p2D(1,2) p2D(2,2)]);
          set(S.hh{2},'xdata',[p2D(1,1) p2D(3,1)],'ydata',[p2D(1,2) p2D(3,2)]);
          set(S.hh{3},'xdata',[p2D(1,1) p2D(4,1)],'ydata',[p2D(1,2) p2D(4,2)]);
        end
    
        % update tracked points
        set(S.pts_h, 'xdata', output.pred(:,1), 'ydata',output.pred(:,2));
        % update frame/second
        set(S.time_h, 'string', sprintf('%d FPS',uint8(1/te)));
      else
        if option.compute_pose
          p2D  = projpose(output.pose,poseline);
          % create head pose drawing
          S.hh{1}=line([p2D(1,1) p2D(2,1)],[p2D(1,2) p2D(2,2)]);
          set(S.hh{1},'Color','r','LineWidth',2);

          S.hh{2}=line([p2D(1,1) p2D(3,1)],[p2D(1,2) p2D(3,2)]);
          set(S.hh{2},'Color','g','LineWidth',2);

          S.hh{3}=line([p2D(1,1) p2D(4,1)],[p2D(1,2) p2D(4,2)]);
          set(S.hh{3},'Color','b','LineWidth',2);
        end
    
        % create tracked points drawing
        S.pts_h   = plot(output.pred(:,1), output.pred(:,2), 'r*', 'markersize',2);
        
        % create frame/second drawing
        S.time_h  = text(frame_w-100,40,sprintf('%d FPS',uint8(1/te)),'fontsize',15,'color','c');
        drawed = true;
      end
    end
  
  
    % private callback function 
    function [] = pb_kpf(varargin)
      % Callback for pushbutton
      if strcmp(varargin{2}.Key, 'escape')==1
        stop_pressed = true;
      end
    end

end



