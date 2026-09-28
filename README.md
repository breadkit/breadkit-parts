<p align="center">
  <a href="https://breadkit.github.io/breadkit/">
    <img src="https://raw.githubusercontent.com/breadkit/breadkit/main/site/favicon.svg" width="72" height="72" alt="Breadkit">
  </a>
</p>

<h1 align="center">breadkit-parts</h1>

<p align="center">
  <strong>Verified, model-specific parts for Breadkit circuits.</strong>
</p>

<p align="center">
  <a href="https://github.com/breadkit/breadkit-parts/actions/workflows/ci.yml"><img src="https://github.com/breadkit/breadkit-parts/actions/workflows/ci.yml/badge.svg" alt="CI status"></a>
  <a href="LICENSE.txt"><img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="MIT license"></a>
</p>

This repository provides source-backed YAML part definitions for
[Breadkit](https://github.com/breadkit/breadkit). It is a versioned Git part
pack, not a Ruby gem.

## Quick start

Use Breadkit 0.2.0 or newer. In your circuit project, add this repository as a
submodule and review the commit you are pinning:

```sh
git submodule add https://github.com/breadkit/breadkit-parts.git vendor/breadkit-parts
git -C vendor/breadkit-parts rev-parse HEAD
```

Save a declarative circuit as `circuit.bk.yml`:

```yaml
board: full
use_parts: [vendor/breadkit-parts/parts/*.yml]
parts:
  - {ref: MCU, type: pico_w, at: c1}
```

Lock the exact YAML definitions, then analyze the circuit:

```sh
breadkit lock circuit.bk.yml
breadkit nets circuit.bk.yml
git add .gitmodules vendor/breadkit-parts circuit.bk.yml breadkit.lock
```

Commit the circuit, lockfile, and submodule pointer together. Breadkit checks
the locked definitions before resolving the circuit. In CI, check out
submodules before running `breadkit nets`. See
[locking local definitions](https://github.com/breadkit/breadkit/blob/main/docs/LOCK.md)
for details.

## Included parts

| Part ID | Model | Manufacturer source |
| --- | --- | --- |
| [`pico_w`](parts/raspberry_pi_pico_w.yml) | Raspberry Pi Pico W | [Pinout](https://datasheets.raspberrypi.com/picow/PicoW-A4-Pinout.pdf) · [Datasheet](https://datasheets.raspberrypi.com/picow/pico-w-datasheet.pdf) |

With USB facing up, pin 1 is at the upper left and pin 40 at the upper right.
The 40 edge pins sit on a 2.54 mm grid, with 17.78 mm between rows; the board
measures 51 × 21 mm. Pin 33 is analog ground (`AGND`). Debug pads and
wireless-chip pins are excluded because they are not breadboard contacts.

This definition assumes no power source; model how the Pico W is powered in
your circuit. With `at: c1` and USB at the top, its left pin row occupies
column `c` and its right row occupies column `h`. Check the orientation before
wiring. Breadkit's built-in `pico` part is a different model.

## Validation and contributions

CI compares the committed pin list with the [manufacturer pinout](https://datasheets.raspberrypi.com/picow/PicoW-A4-Pinout.pdf)
and validates the YAML with a pinned Breadkit core revision using
`breadkit check-part`. Before adding a model, read [CONTRIBUTING.md](CONTRIBUTING.md).
Only exact models with a documented pinout belong in this pack.

## License

[MIT](LICENSE.txt).
