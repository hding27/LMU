classdef constants
  %CONSTANTS Summary of this class goes here
  %   Detailed explanation goes here
  
  properties (Constant)
    me = 9.11e-31,
    c = 299792458,
    e = 1.602e-19,
    kB = 1.3806488e-23,
    epsilon0 = 8.854e-12,
    ev = 5.110898675588270e+05
  end
  
  methods(Static)
    function value = omega_p( n0 )
      value = sqrt(n0*constants.e^2/(constants.epsilon0*constants.me));
    end
    function value = n0(omega_p)
       value = omega_p.^2 * constants.epsilon0 * constants.me / constants.e^2;
    end
  end
  
end

