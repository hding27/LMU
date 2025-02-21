classdef Probe < Camera
  %PROBE Summary of this class goes here
  %   Detailed explanation goes here
  
  properties
    PlasmawaveRects,
    Wavelength,
  end
  
  methods
    
    function obj = Probe(experimentPath, subFolder, archiveName)
      
      if nargin < 3
        archiveName = 'probe';
      end
      if nargin < 2
        subFolder = 'Probe';
      end
      
      obj = obj@Camera(experimentPath, subFolder, archiveName);
     
      if length(obj.PlasmawaveRects) < length(obj.No)
        obj.PlasmawaveRects{length(obj.No)} = [];
      end
      if length(obj.Wavelength) < length(obj.No)
        obj.Wavelength{length(obj.No)} = [];
      end
    end
    
    
    function cellArray = addRecordIdx(obj, cellArray, idx, outputIdx)
      cellArray = addRecordIdx@Camera(obj, cellArray, idx, outputIdx);
      for i = 1:length(outputIdx)
        if length(obj.PlasmawaveRects) >= idx(i)
          cellArray.PlasmawaveRects{outputIdx(i)} = obj.PlasmawaveRects{idx(i)};
        else
          cellArray.PlasmawaveRects{outputIdx(i)} = [];
        end
      end
    end
    
  end
  
end

