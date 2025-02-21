classdef Camera < MultiFileArchive
  %CAMERA Class for the Hao's Labview-created images.
  %   This class imports the images written by the Labview camera VIs.
  
  properties
    ImageSize,
    PixelSize,
  end
  
  methods
    
    function obj = Camera(experimentPath, subFolder, archiveName)
      obj = obj@MultiFileArchive(experimentPath, subFolder, archiveName);
    end
    
    function load(obj, directory, archiveName, update)
      %% Gathers the information from the files.
      % archiveName: e.g. 'ePointing' for files like 20160714_000_0001_ePointing.png
      if nargin < 4
        update = false;
      end
      if nargin < 3
        archiveName = obj.ArchiveName;
      end
      if nargin < 2
        directory = obj.Path;
      end
      
      matPath = [fullfile(directory, archiveName) '.mat'];
      
      if (~exist(matPath, 'file') || update)
        obj.Path = directory;
        files = dir(fullfile(directory, ['*' archiveName '.png']));
        numFiles = length(files);
        obj.No = zeros(numFiles,1);
        obj.Run = zeros(numFiles,1);
        obj.DateTime = cell(numFiles,1);
        obj.FileName = cell(numFiles,1);
        
        for i = 1:length(files)
          file = files(i).name;
          idx = regexp(file,'_');
          obj.Run(i) = str2num(file(idx(1)+1:idx(2)-1));
          obj.No(i)  = str2num(file(idx(2)+1:idx(3)-1));
          obj.DateTime{i} = datestr(files(i).datenum,'yyyy-mm-dd.HH:MM:SS');
          obj.FileName{i} = file;
        end
        
        % load one image to get the dimensions
        
        tmpImage = imread(fullfile(obj.Path,files(1).name));
        obj.ImageSize = size(tmpImage);
        
        obj.LastUpdate = datestr(now);
        save(matPath, 'obj');
      else
        savedClass = load(matPath, 'obj');
        savedClass.obj.Path = obj.Path;
        p = properties(obj);
        for k = 1:length(p)
          if isprop(savedClass.obj,p{k})
            obj.(p{k}) = savedClass.obj.(p{k});
          end
        end
      end
    end
    
    
    function cellArray = addRecordIdx(obj, cellArray, idx, outputIdx)
      for i = 1:length(outputIdx)
        cellArray.Image{outputIdx(i)} = imread(fullfile(obj.Path, obj.FileName{idx(i)}));
        %display(['Opening File: ' fullfile(obj.Path, obj.FileName{idx(i)})]);
      end
    end
    
  end
  
end

