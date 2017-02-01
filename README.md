# handy-scripts

# bat_alert
This script generates notifications when your laptop battery is critically low.
It works by beeping and by making the display blink once. 
Alternatively, an audio file can be provided for the sound notification.
Notifications are generated every `2.5` minutes, provided the laptop is not charging and the battery level reported by `acpi` is less than or equal to `5%`.

It can be used by simply running `bat_alert.sh`. 
It takes an optional argument, which represents the path of the audio file to play as a sound alert.
Note that if the duration of the audio file exceeds `2.5` seconds, only the first `2.5` seconds will be played.

`bat_alert` can be used with the [i3 window manager](https://github.com/mariusmuja/i3wm) by adding the following line to your `config` file:

`exec --no-startup-id <path>`

where `<path>`is the path to `bat_alert.sh`.
