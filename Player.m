classdef Player
   properties
      top = -1
      bottom
      left
      right
      weight 
      processed = 0    
      team = -1;
   end
   methods
      function obj = SimpleValue(v)
         if nargin > 0
            obj.Value = v;
         end
      end
   end
end
