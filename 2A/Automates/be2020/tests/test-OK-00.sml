machine Test {
   event switchOn
   event switchOff
   from bulb.Off to buld.On on switchOn
   from buld.On to buld.Off on SwitchOff
   }
