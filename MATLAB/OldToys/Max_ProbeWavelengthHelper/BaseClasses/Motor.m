classdef Motor < SingleFileArchive
    %MOTOR Class for the motor archive.
    %   Imports the motor data.
    
  properties
    Position,
    Conversion
  end

  methods
    function obj = Motor(path, filename)
      obj = obj@SingleFileArchive(path, filename);
    end

  end
  
  methods(Static)
    function spec = formatSpec()
      spec = '%f%f';
    end
    function props = Properties()
      props = {'Position', 'Conversion'};
    end
  end
end

