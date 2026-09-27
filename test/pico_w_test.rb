# frozen_string_literal: true

require "yaml"

part_path = File.expand_path("../parts/raspberry_pi_pico_w.yml", __dir__)
raise "Pico W definition is missing" unless File.file?(part_path)

part = YAML.safe_load(File.read(part_path, encoding: "UTF-8"), aliases: false)
pins = part.fetch("pins")
expected_names = %w[
  GP0 GP1 GND GP2 GP3 GP4 GP5 GND GP6 GP7 GP8 GP9 GND GP10 GP11
  GP12 GP13 GND GP14 GP15 GP16 GP17 GND GP18 GP19 GP20 GP21 GND
  GP22 RUN GP26 GP27 AGND GP28 ADC_VREF 3V3_OUT 3V3_EN GND VSYS VBUS
]
actual_names = pins.map { |pin| pin.fetch("name").sub(/\AGND\d+\z/, "GND") }
raise "Pico W pin numbers differ from the pinout" unless pins.map { |pin| pin.fetch("num") } == (1..40).to_a
raise "Pico W pin names differ from the pinout" unless actual_names == expected_names
raise "Pico W ground pins differ from the pinout" unless pins.select { |pin| pin["type"] == "ground" }.map { |pin| pin["num"] } == [3, 8, 13, 18, 23, 28, 33, 38]
raise "GP0 and GP1 must remain multifunction GPIO" unless pins.first(2).all? { |pin| pin["type"] == "gpio" }
raise "Pico W must straddle the gap" unless part["straddle"] == true && part["placement"] == "footprint"
raise "Pico W board dimensions differ from the datasheet" unless part.dig("render", "size_mm") == [51, 21]
raise "Pico W pinout source is missing" unless part["datasheet_url"] == "https://datasheets.raspberrypi.com/picow/PicoW-A4-Pinout.pdf"

footprint = part.fetch("footprint")
expected_footprint = (1..20).to_h { |number| [number.to_s, [number - 1, 0]] }
expected_footprint.merge!((21..40).to_h { |number| [number.to_s, [40 - number, 7]] })
raise "Pico W footprint does not match the 40 contacts" unless footprint == expected_footprint

puts "Pico W pinout and footprint verified"
