machine lamp {
   event switchOn
   event switchOff
   region bulb {
      state dedas
   }
   from bulb.Off to buld.On on switchOn
   from buld.On to buld.Off on SwitchOff
}
