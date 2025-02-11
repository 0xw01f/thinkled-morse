#!/bin/bash

# Path to the ThinkPad logo LED
LED_PATH="/sys/class/leds/tpacpi::lid_logo_dot/brightness"

# Morse code mapping
declare -A MORSE_CODE=(
    [A]=".-"    [B]="-..."  [C]="-.-."  [D]="-.."   [E]="."
    [F]="..-."  [G]="--."   [H]="...."  [I]=".."    [J]=".---"
    [K]="-.-"   [L]=".-.."  [M]="--"    [N]="-."    [O]="---"
    [P]=".--."  [Q]="--.-"  [R]=".-."   [S]="..."   [T]="-"
    [U]="..-"   [V]="...-"  [W]=".--"   [X]="-..-"  [Y]="-.--"
    [Z]="--.."
    [0]="-----" [1]=".----" [2]="..---" [3]="...--" [4]="....-"
    [5]="....." [6]="-...." [7]="--..." [8]="---.." [9]="----."
)

# Default speed: normal
SPEED="normal"

# Timing settings based on speed
set_timings() {
    case "$SPEED" in
        fast)
            DOT_DURATION=0.1
            DASH_DURATION=0.3
            SYMBOL_PAUSE=0.1
            LETTER_PAUSE=0.3
            WORD_PAUSE=0.7
            ;;
        slow)
            DOT_DURATION=0.4
            DASH_DURATION=1.2
            SYMBOL_PAUSE=0.4
            LETTER_PAUSE=1.2
            WORD_PAUSE=2.8
            ;;
        *)
            # Default normal speed
            DOT_DURATION=0.2
            DASH_DURATION=0.6
            SYMBOL_PAUSE=0.2
            LETTER_PAUSE=0.6
            WORD_PAUSE=1.4
            ;;
    esac
}

# Function to turn LED on
led_on() {
    echo 1 | sudo tee $LED_PATH > /dev/null
}

# Function to turn LED off
led_off() {
    echo 0 | sudo tee $LED_PATH > /dev/null
}

# Function to blink a dot
blink_dot() {
    led_on
    sleep $DOT_DURATION
    led_off
    sleep $SYMBOL_PAUSE
}

# Function to blink a dash
blink_dash() {
    led_on
    sleep $DASH_DURATION
    led_off
    sleep $SYMBOL_PAUSE
}

# Function to convert text to Morse and blink
text_to_morse() {
    local input=$(echo "$1" | tr '[:lower:]' '[:upper:]')  # Convert to uppercase

    for (( i=0; i<${#input}; i++ )); do
        char="${input:$i:1}"

        if [[ "$char" == " " ]]; then
            sleep $WORD_PAUSE  # Pause between words
        else
            morse="${MORSE_CODE[$char]}"
            if [[ -n "$morse" ]]; then
                for symbol in $(echo "$morse" | grep -o .); do
                    if [[ "$symbol" == "." ]]; then
                        blink_dot
                    elif [[ "$symbol" == "-" ]]; then
                        blink_dash
                    fi
                done
                sleep $LETTER_PAUSE  # Pause between letters
            fi
        fi
    done
}

# Function to handle looping
loop_morse() {
    while true; do
        text_to_morse "$1"
        sleep 2  # Pause between repeats
    done
}

# Argument parsing
LOOP_MODE=false
MESSAGE=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        -l|--loop)
            LOOP_MODE=true
            shift
            ;;
        -s|--speed)
            SPEED="$2"
            if [[ ! "$SPEED" =~ ^(fast|normal|slow)$ ]]; then
                echo "Invalid speed option. Choose 'fast', 'normal', or 'slow'."
                exit 1
            fi
            shift 2
            ;;
        *)
            MESSAGE="$1"
            shift
            ;;
    esac
done

# Ensure a message was provided
if [[ -z "$MESSAGE" ]]; then
    echo "Usage: $0 [-l|--loop] [-s|--speed fast|normal|slow] \"Your message here\""
    exit 1
fi

# Set the timings based on speed
set_timings

# Run in loop mode if specified
if $LOOP_MODE; then
    loop_morse "$MESSAGE"
else
    text_to_morse "$MESSAGE"
fi

