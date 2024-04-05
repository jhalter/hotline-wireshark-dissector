# hotline-wireshark-dissector

A quick and dirty [Hotline protocol](https://en.wikipedia.org/wiki/Hotline_Communications) dissector for Wireshark.

## Usage

1. Install Wireshark
2. Save `hotline-proto.lua` to your "Personal Lua Plugins" directory.  In Wireshark 4.2.4 on macOS this defaults to `lib/wireshark/plugins`.  Your setup may vary.
3. Capture some Hotline traffic and filter for `tcp.port == 5500` or simply `hotl`.

Enjoy 🎉

<img width="692" alt="Screenshot 2024-04-05 at 4 34 27 PM" src="https://github.com/jhalter/hotline-wireshark-dissector/assets/868228/eb3ef5ee-21de-4585-9327-f683b2aa6bc9">
