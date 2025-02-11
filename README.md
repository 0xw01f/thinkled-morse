# ThinkPad LED Morse Code Blinker

This project allows you to send messages in Morse code by blinking the ThinkPad logo LED on your laptop. The script takes a message as input and blinks the LED in patterns corresponding to Morse code for each character. You can adjust the speed of the blinking and choose to loop the message.

## Features
- Converts text into Morse code.
- Blinks the ThinkPad logo LED to represent the Morse code.
- Customizable speed options: fast, normal, and slow.
- Option to loop the message continuously.

## Requirements
- A ThinkPad laptop with a controllable logo LED (specific to certain models).
- `sudo` privileges to control the LED brightness.
- Bash environment (Linux-based systems preferred).

## Installation
1. Clone or download the script to your system.
2. Make sure you have the necessary permissions to control the LED brightness. You may need to configure `sudo` for accessing `/sys/class/leds/tpacpi::lid_logo_dot/brightness`.
3. Run the script using:

```bash
chmod +x morse_led.sh
./morse_led.sh "Your message here"
```

## Usage
```bash
./morse_led.sh [-l|--loop] [-s|--speed fast|normal|slow] "Your message here"
```

### Options:
- `-l, --loop`: Repeats the Morse code indefinitely.
- `-s, --speed <speed>`: Sets the speed of blinking. Options:
  - `fast`: Faster blinking.
  - `normal`: Default speed.
  - `slow`: Slower blinking.

### Example:
```bash
./morse_led.sh -s fast "HELLO WORLD"
```

This will blink the LED in Morse code for "HELLO WORLD" at a fast speed.

## How It Works
1. The script maps each letter and number to its corresponding Morse code pattern.
2. It then turns the LED on and off for each dot (short blink) and dash (longer blink).
3. The timing of the blinks is controlled by the selected speed.
4. If the `--loop` option is enabled, the message is repeatedly displayed.

## Customization
- You can modify the `MORSE_CODE` mapping to include additional characters if needed.
- The LED control path (`LED_PATH`) is specific to ThinkPad models; adjust it if using a different device.

## Notes
- Ensure that your laptop model supports controlling the LED brightness through `/sys/class/leds/tpacpi::lid_logo_dot/brightness`.
- The LED blink timing and duration can be adjusted in the `set_timings` function.

## License
This script is released under the MIT License. Feel free to modify and distribute it.

