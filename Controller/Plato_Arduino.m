  clear a;
   a = arduino('COM4', 'Uno');
   
   for i = 1:30
   writeDigitalPin(a, 'D11', 1);
   pause(0.1);
   writeDigitalPin(a, 'D11', 0);
   end