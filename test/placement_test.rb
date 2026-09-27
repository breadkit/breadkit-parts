# frozen_string_literal: true

require "breadkit"

circuit_path = File.expand_path("fixtures/pico_w.bk.yml", __dir__)
circuit = Breadkit.load(circuit_path)
raise "Pico W placement has errors" if circuit.diagnostics.any? { |diagnostic| diagnostic.severity == "error" }

mcu = circuit.components.fetch("MCU")
expected_holes = { 1 => "c1", 20 => "c20", 21 => "h20", 40 => "h1" }
expected_holes.each do |pin_number, hole_id|
  raise "Pico W pin #{pin_number} should be in #{hole_id}" unless mcu.pin(pin_number).hole_id == hole_id
end

puts "Pico W board placement verified"
