{ lib, ... }:
{
  services.udev.extraHwdb = ''
    evdev:atkbd:*
     KEYBOARD_KEY_3a=esc

    evdev:input:b*v*p*
     KEYBOARD_KEY_70039=esc
  '';
}
