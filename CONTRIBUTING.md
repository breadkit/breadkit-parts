# Contributing parts

Add a part only when its exact manufacturer and model can be identified. Link a primary pinout or datasheet with `datasheet_url`, then map every physical contact from that source. Record the viewing orientation and dimensions used by the footprint in the YAML comments or README. Do not guess pin order from another vendor's similarly named breakout.

Use a model-specific part ID. Keep electrical types tied to the pin's hardware role: a multifunction GPIO stays `gpio` even when one circuit uses it for I²C. Do not invent a `provides` voltage for a board that needs external power.

Run the model tests and validate all definitions with a current Breadkit core checkout:

```sh
ruby test/pico_w_test.rb
for file in parts/*.yml; do
  breadkit check-part "$file"
done
```

Add a source-backed pin and footprint regression test for each new part. CI currently pins a core commit because released Breadkit 0.1.0 does not include `check-part`; update the pin deliberately after checking compatibility.
