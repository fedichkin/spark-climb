## Global signal bus (autoload "Events"). Systems emit and listen here
## instead of reaching for each other's nodes (ARCHITECTURE §6).
## Signals are emitted from other scripts, so the unused warning is muted.
extends Node

## The first landing on a regular platform: the climb has begun.
@warning_ignore("unused_signal")
signal run_started()
## The hero bounced off a platform.
@warning_ignore("unused_signal")
signal player_landed(platform: Platform, quality: LandingMath.Quality)
## The run's best height grew to a new whole number of meters.
@warning_ignore("unused_signal")
signal height_changed(meters: int)
