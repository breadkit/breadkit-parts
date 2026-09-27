# Breadkit parts

Model-specific part definitions for [Breadkit](https://github.com/breadkit/breadkit). This repository is a separate Git part pack; it is not a gem and has its own revision history.

| Part ID | Model | Source |
| --- | --- | --- |
| `pico_w` | Raspberry Pi Pico W | [Official pinout](https://datasheets.raspberrypi.com/picow/PicoW-A4-Pinout.pdf) and [datasheet](https://datasheets.raspberrypi.com/picow/pico-w-datasheet.pdf) |

The definition has 40 physical edge pins. With USB facing up, pin 1 is at the upper left and pin 40 at the upper right. The rows are 17.78 mm apart on a 2.54 mm grid; the board is 51 × 21 mm. Pin 33 is analog ground (`AGND`). The three debug pads and wireless-chip pins are not breadboard contacts, so they are not in the footprint. The part has no assumed power source: model how the Pico W is powered in your circuit.

## Use in a circuit

Add this repository as a submodule and review the exact commit before committing the submodule pointer:

```sh
git submodule add https://github.com/breadkit/breadkit-parts.git vendor/breadkit-parts
git -C vendor/breadkit-parts rev-parse HEAD
```

Reference its local YAML in a declarative Breadkit circuit:

```yaml
board: full
use_parts: [vendor/breadkit-parts/parts/*.yml]
parts:
  - {ref: MCU, type: pico_w, at: c1}
```

With USB at the top, this placement puts the left pin row in column `c` and the right pin row in column `h`. Check your board and pin orientation before wiring. The built-in `pico` part is a different model and does not select this definition.

Record checksums of the selected YAML bytes and commit the circuit, `breadkit.lock`, and submodule pointer together:

```sh
breadkit lock circuit.bk.yml
breadkit nets circuit.bk.yml
git add .gitmodules vendor/breadkit-parts circuit.bk.yml breadkit.lock
```

In CI, check out submodules, then run `breadkit nets circuit.bk.yml`; Breadkit verifies the lockfile before resolving the circuit. See [locking local definitions](https://github.com/breadkit/breadkit/blob/main/docs/LOCK.md). The `lock` and `check-part` commands currently require Breadkit `main`; the published 0.1.0 gem predates them.

## Validation and contributions

CI checks the [manufacturer pinout](https://datasheets.raspberrypi.com/picow/PicoW-A4-Pinout.pdf) against the committed pin list and validates every YAML definition with a pinned Breadkit core revision using `breadkit check-part`. See [CONTRIBUTING.md](CONTRIBUTING.md) before adding a model. Generic breakout names without a fixed, documented pinout are intentionally excluded.

Licensed under [MIT](LICENSE.txt).
