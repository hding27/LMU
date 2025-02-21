classdef TangoArchiveGroup < handle
  %TANGOARCHIVEGROUP Summary of this class goes here
  %   Detailed explanation goes here
  
  properties
    Archives
  end
  
  methods
    function obj = TangoArchiveGroup()    
    end
    function addArchive(obj, archive, name)
      idx = length(obj.Archives)+1;
      obj.Archives(idx).Archive = archive;
      obj.Archives(idx).Name = name;
    end
    function update(obj)
      for i = obj.Archives
        i.update();
      end
    end
    function cellArray = getRecord(obj, ShotNo)
      for i = 1:length(obj.Archives)
        cellArray.(obj.Archives(i).Name) = obj.Archives(i).Archive.getRecord(ShotNo);
      end
    end
  end
end

