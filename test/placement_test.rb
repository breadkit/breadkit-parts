# frozen_string_literal: true

require "minitest/autorun"
require "breadkit"

class PlacementTest < Minitest::Test
  CIRCUIT_PATH = File.expand_path("fixtures/pico_w.bk.yml", __dir__)

  def test_usb_up_placement_uses_left_c_and_right_h_columns
    circuit = Breadkit.load(CIRCUIT_PATH)
    mcu = circuit.components.fetch("MCU")

    assert_empty circuit.diagnostics.select { |diagnostic| diagnostic.severity == "error" }
    assert_equal "c1", mcu.pin(1).hole_id
    assert_equal "c20", mcu.pin(20).hole_id
    assert_equal "h20", mcu.pin(21).hole_id
    assert_equal "h1", mcu.pin(40).hole_id
  end
end
