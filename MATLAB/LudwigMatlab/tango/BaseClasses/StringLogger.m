classdef StringLogger < SingleFileArchive
  %HEXAPOD Hexapod archive class
  %   Imports the data from an hexapod archive.

  properties
    Value,
  end

  methods
    function obj = StringLogger(path, filename)
      obj = obj@SingleFileArchive(path, filename);
    end
  end
  
  methods(Static)
    function spec = formatSpec()
      spec = '%s';
    end
    function props = Properties()
      props = {'Value'};
    end
  end
end




