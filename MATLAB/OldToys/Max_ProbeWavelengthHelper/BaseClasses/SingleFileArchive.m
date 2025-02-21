classdef SingleFileArchive < TangoArchive
  %SINGLEFILEARCHIVE Abstract class to import SingleFileArchive archives generated
  %with Max's fantastic Tango servers.
  %   This class is supposed to be a parent class for SingleFileArchives
  %   created by Max's 'ArchivingDevice' Tango servers. This is supposed to
  %   be inherited but can as well be used itself to just get the shot no.,
  %   run and date component of the SingleFileArchive file.
  
  properties
    Path,
    FileName
  end
  
  methods
    
    function [obj, success] = SingleFileArchive(path, filename)
      obj.FileName = filename;
      obj.Path = path;
      obj.ExperimentPath = path; % to do
      success = obj.load(fullfile(path, filename));
    end
    
    function update(obj)
      obj.load();
    end
    
    function success = load(obj, filename)
      %% Imports the data from an ArchivingDevice file.
      
      if nargin < 1
        filename = fullfile(obj.Path, obj.FileName);
      end
      
      delimiter = '\t';
      
      startRow = 2;
      endRow = inf;
      
      % column1: double (%f)
      %	column2: double (%f)
      % column3: date strings (%s)
      
      formatSpec = ['%f%f%s' obj.formatSpec '%[^\n\r]'];
      
      fileID = fopen(filename,'r');
      
      if (fileID ~= -1)
        
        
        %% Generated with the Import Tool
        % Read columns of data according to format string.
        % This call is based on the structure of the file used to generate this
        % code. If an error occurs for a different file, try regenerating the code
        % from the Import Tool.
        dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines', startRow(1)-1, 'ReturnOnError', false);
        for block=2:length(startRow)
          frewind(fileID);
          dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines', startRow(block)-1, 'ReturnOnError', false);
          for col=1:length(dataArray)
            dataArray{col} = [dataArray{col};dataArrayBlock{col}];
          end
        end
        
        fclose(fileID);
        
        % Post processing for unimportable data.
        % No unimportable data rules were applied during the import, so no post
        % processing code is included. To generate code which works for
        % unimportable data, select unimportable cells in a file and regenerate the
        % script.
        % Convert the contents of column with dates to serial date numbers using date format string (datenum).
        
        % dataArray{3} = datenum(dataArray{3}, 'yyyy-mm-dd.HH:MM:SS');
        
        %% Allocate imported array to class properties
        obj.No = dataArray{:, 1};
        obj.Run = dataArray{:, 2};
        obj.DateTime = dataArray{:, 3};
        
        % The remaining columns need to be allocated by the child class
        obj.extractDataFromDataArray(dataArray(:,4:end));
        success = 1;
      else
        success = 0;
      end
    end
    
    function extractDataFromDataArray(obj, dataArray)
      %%  Extracts child's specific data from the dataArray
      % The child class needs to extract the imported data to the class
      % properties. If all properties are overwritten in Properties() (in
      % the correct order!) and no processing of the data is necessary,
      % this function does not need to be overwritten.
      props = obj.Properties();
      for i = 1:length(props)
        obj.(props{i}) = dataArray{:,i};
      end
    end
    
    function cellArray = addRecordIdx(obj, cellArray, idx, outputIdx)
      %%  Add specific data to cellArray
      % Add the requested shot data to cellArray.
      % idx: Index of shot in the property arrays (equal to shot no. if
      % shots begin with 1 and no shot is missing in the archive)
      % outputIdx: Index in cellArray to write the data to.
      % idx and outputIdx may be arrays and always have the same length.
      % If no more processing is necessary and the child class properties
      % are overwritten in Properties() this does not need to be
      % overwritten.
      props = obj.Properties();
      for i=1:length(props)
        % Iterate over the child properties and add the data
        cellArray.(props{i})(outputIdx) = obj.(props{i})(idx);
      end
      
    end
  end
  
  methods(Static)
    function spec = formatSpec()
      %%  Needs to be overwritten
      % Defines the formatSpec for the class-specific data right of shot
      % no., run and datetime. %s for string, %f for float etc.
      spec = '';
    end
    function props = Properties()
      %% Child specific properties
      % The correct order is
      props = cell(1,0);
    end
  end
end

