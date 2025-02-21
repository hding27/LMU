classdef TangoArchive < handle
  %TANGOARCHIVE Abstract class to import SingleFileArchive archives generated
  %with Max's fantastic Tango servers.
  %   This class is supposed to be a parent class for SingleFileArchives
  %   created by Max's 'ArchivingDevice' Tango servers.
  
  properties
    No,
    Run,
    DateTime,
    LastUpdate,
    ExperimentPath,
  end
  
  methods
    function update(obj)
    end
 
    function cellArray = getRun(obj, Run)
      %% Returns the data of one run.
      % Returns the datasets of the archive, i.e. the shot no., run,
      % datetime and (if inherited) the additional data from the archive.
      
      idx = find(ismember(obj.Run, Run));
      isAvailable = idx~=0;
      outputIdx = find(isAvailable);
      idx(idx==0) = [];
      cellArray.No(outputIdx) = obj.No(idx);
      cellArray.Run(outputIdx) = obj.Run(idx);
      cellArray.DateTime(outputIdx) = obj.DateTime(idx);
      cellArray = obj.addRecordIdx(cellArray, idx, outputIdx);
    end
    
    function [cellArray, isAvailable] = getRecord(obj, ShotNo, cellArray)
      %% Returns the data of one or more shots.
      % Returns the datasets of the archive, i.e. the shot no., run,
      % datetime and (if inherited) the additional data from the archive.
      % The second returned parameter isAvailable returns one for existing
      % datasets and zero for nonexisting ones.
      if (nargin < 3)
        cellArray = [];
      end
      
      
      [~, idx] = ismember(ShotNo, obj.No);
      isAvailable = idx~=0;
      outputIdx = find(isAvailable);
      idx(idx==0) = [];
      cellArray.No(outputIdx) = obj.No(idx);
      cellArray.Run(outputIdx) = obj.Run(idx);
      cellArray.DateTime(outputIdx) = obj.DateTime(idx);
      cellArray = obj.addRecordIdx(cellArray, idx, outputIdx);
    end
    
    function shots = shotsByRun(obj, run)
      shots = [];
      for i = 1:length(run)
        shots = [shots obj.No(find(obj.Run == run(i)))'];
      end
    end
  end
  methods(Static)
    function ds = datestring()
      %% Returns the date string format.
      % Returns the date string format for conversion purposes.
      ds = 'yyyy-mm-dd.HH:MM:SS';    
    end
  end
  
end

