#include <charconv>
#include <cstdint>
#include <cstdio>
#include <memory>
#include <string_view>
#include <systemd/sd-bus.h>

int main(int argc, char* argv[]) {
  if (argc < 2) return 1;

  int64_t offset = 0;
  std::string_view arg = argv[1];
  auto [end, error] = std::from_chars(arg.begin(), arg.end(), offset);
  if (error != std::errc{} || end != arg.end()) {
    std::fputs("Failed to parse offset as integer\n", stderr);
    return 1;
  }

  sd_bus* raw_bus = nullptr;
  if (sd_bus_open_user(&raw_bus) < 0) return 1;
  std::unique_ptr<sd_bus, decltype(&sd_bus_unref)> bus{raw_bus, &sd_bus_unref};

  sd_bus_call_method(
    bus.get(),
    "org.mpris.MediaPlayer2.playerctld",
    "/org/mpris/MediaPlayer2",
    "org.mpris.MediaPlayer2.Player",
    "Seek",
    nullptr,
    nullptr,
    "x",
    offset
  );

  return 0;
}
