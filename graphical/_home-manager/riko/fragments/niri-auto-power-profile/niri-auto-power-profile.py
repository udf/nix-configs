import asyncio
from dbus_fast import BusType
from dbus_fast.aio import MessageBus

from sniri import NiriConnection

TARGET_APP_IDS = {
  'codium',
}

DEFAULT_PROFILE = 'power-saver'
TARGET_PROFILE = 'balanced'


class PowerProfileManager:
  def __init__(self):
    self.bus = None
    self.power_profiles = None
    self.current_profile = None

  async def connect(self):
    self.bus = await MessageBus(bus_type=BusType.SYSTEM).connect()
    introspection = await self.bus.introspect(
      'org.freedesktop.UPower.PowerProfiles',
      '/org/freedesktop/UPower/PowerProfiles',
    )
    proxy = self.bus.get_proxy_object(
      'org.freedesktop.UPower.PowerProfiles',
      '/org/freedesktop/UPower/PowerProfiles',
      introspection,
    )
    self.power_profiles = proxy.get_interface('org.freedesktop.UPower.PowerProfiles')
    props = proxy.get_interface('org.freedesktop.DBus.Properties')

    self.current_profile = await self.power_profiles.get_active_profile()
    print(f'[DBus] Connected. Initial profile: {self.current_profile}')

    props.on_properties_changed(self._on_props_changed)

  def _on_props_changed(self, iface, changed, invalidated):
    if 'ActiveProfile' in changed:
      self.current_profile = changed['ActiveProfile'].value
      print(f'[DBus] Power profile changed: {self.current_profile}')

  async def set_profile(self, profile: str):
    if profile == self.current_profile:
      return
    if self.current_profile not in {DEFAULT_PROFILE, TARGET_PROFILE}:
      return
    try:
      await self.power_profiles.set_active_profile(profile)
      self.current_profile = profile
      print(f'[DBus] Switched power profile -> {profile}')
    except Exception as e:
      print(f'[DBus] Failed to switch profile to {profile}: {e}')


async def evaluate_focus(conn: NiriConnection, power_mgr: PowerProfileManager):
  match await conn.command('FocusedWindow'):
    case {'Ok': {'FocusedWindow': {'app_id': app_id}}}:
      new_profile = TARGET_PROFILE if app_id in TARGET_APP_IDS else DEFAULT_PROFILE
      await power_mgr.set_profile(new_profile)
    case {'Ok': {'FocusedWindow': None}}:
      await power_mgr.set_profile(DEFAULT_PROFILE)
    case response:
      print('Unknown response for FocusedWindow:', response)


async def main():
  power_mgr = PowerProfileManager()
  await power_mgr.connect()

  async with NiriConnection() as event_conn, NiriConnection() as conn:
    async for event in event_conn.iter_event_stream():
      match event:
        case {'WindowFocusChanged': _}:
          await evaluate_focus(conn, power_mgr)


if __name__ == '__main__':
  try:
    asyncio.run(main())
  except KeyboardInterrupt:
    pass
