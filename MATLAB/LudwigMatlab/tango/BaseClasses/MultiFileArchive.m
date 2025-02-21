classdef MultiFileArchive < TangoArchive
  %MULTIFILEARCHIVE Summary of this class goes here
  %   Detailed explanation goes here
  
  properties
    FileName,
    Path,
    ArchiveName,
  end
  
  methods
    function obj = MultiFileArchive(experimentPath, subFolder, archiveName)
      obj.ArchiveName = archiveName;
      obj.ExperimentPath = experimentPath;
      obj.Path = fullfile(experimentPath, subFolder);
      obj.load(fullfile(experimentPath, subFolder), archiveName);
    end
    function update(obj)
      obj.load(obj.Path, obj.ArchiveName, true);
    end
    function saveChanges(obj)
        matPath = [fullfile(obj.Path, obj.ArchiveName) '.mat'];
        obj.LastUpdate = datestr(now);
        save(matPath, 'obj');
    end
    function load(obj, directory, archiveName, update)
      %% Gathers the information from the files.
      % archiveName: e.g. 'Spectrum' for files like Spectrum_0001_0.txt
      % For e.g. the Camera subclass this is different since the files are
      % not archived by ArchivingDevice.
      % The actual data is imported later when getRecord() is called.
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
        files = dir(fullfile(directory, archiveName));
        
        %  Find which files have not yet been loaded previously
        if (isempty(obj.FileName))
          filesToLoad = 1:length(files);
        else
          filesToLoad = find(~ismember({files(:).name}',obj.FileName));
        end
        
        numFiles = length(filesToLoad);
        offset = length(obj.FileName);
        %       obj.No = zeros(numFiles,1);
        %       obj.Run = zeros(numFiles,1);
        %       obj.DateTime = cell(numFiles,1);
        %       obj.FileName = cell(numFiles,1);
        
        obj.No(offset + numFiles) = 0;
        obj.Run(offset + numFiles) = 0;
        obj.DateTime{offset + numFiles} = '';
        obj.FileName{offset + numFiles} = '';
        
        
        for i = 1:numFiles
          file = files(filesToLoad(i)).name;
          fileRaw = file(1:regexp(file,'\.')-1);
          idx = regexp(fileRaw,'_');
          obj.No(offset + i)  = str2num(fileRaw(idx(1)+1:idx(2)-1));
          obj.Run(offset + i) = str2num(fileRaw(idx(2)+1:end));
          obj.DateTime{offset + i} = datestr(files(filesToLoad(i)).datenum,'yyyy-mm-dd.HH:MM:SS');
          obj.FileName{offset + i} = file;
          
        end
        
        obj.saveChanges();
      else
        savedClass = load(matPath, 'obj');
        savedClass.obj.Path = obj.Path;
        p = properties(obj);
        for k = 1:length(p)
          obj.(p{k}) = savedClass.obj.(p{k});
        end
      end
    end
    

  end
  
end

