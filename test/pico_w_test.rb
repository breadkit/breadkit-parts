# frozen_string_literal: true

require "minitest/autorun"
require "yaml"

class PicoWTest < Minitest::Test
  PART_PATH = File.expand_path("../parts/raspberry_pi_pico_w.yml", __dir__)
  PIN_NAMES = %w[
    GP0 GP1 GND GP2 GP3 GP4 GP5 GND GP6 GP7 GP8 GP9 GND GP10 GP11
    GP12 GP13 GND GP14 GP15 GP16 GP17 GND GP18 GP19 GP20 GP21 GND
    GP22 RUN GP26 GP27 AGND GP28 ADC_VREF 3V3_OUT 3V3_EN GND VSYS VBUS
  ].freeze

  def part
    assert File.file?(PART_PATH), "Pico W definition is missing"
    YAML.safe_load(File.read(PART_PATH, encoding: "UTF-8"), aliases: false)
  end

  def test_pins_follow_official_pico_w_pinout
    pins = part.fetch("pins")

    assert_equal (1..40).to_a, pins.map { |pin| pin.fetch("num") }
    assert_equal PIN_NAMES, pins.map { |pin| pin.fetch("name").sub(/\AGND\d+\z/, "GND") }
    assert_equal [3, 8, 13, 18, 23, 28, 33, 38],
                 pins.select { |pin| pin["type"] == "ground" }.map { |pin| pin["num"] }
    assert_equal "gpio", pins.first.fetch("type")
    assert_equal "gpio", pins[1].fetch("type")
  end

  def test_usb_up_footprint_straddles_a_breadboard_gap
    definition = part
    footprint = definition.fetch("footprint")

    assert_equal true, definition.fetch("straddle")
    assert_equal "footprint", definition.fetch("placement")
    assert_equal (1..40).map(&:to_s), footprint.keys.sort_by(&:to_i)
    assert_equal({ "1" => [0, 0], "20" => [19, 0], "21" => [19, 7], "40" => [0, 7] },
                 footprint.slice("1", "20", "21", "40"))
    assert_equal [51, 21], definition.fetch("render").fetch("size_mm")
  end

  def test_definition_links_to_manufacturer_pinout
    assert_equal "https://datasheets.raspberrypi.com/picow/PicoW-A4-Pinout.pdf",
                 part.fetch("datasheet_url")
  end
end
