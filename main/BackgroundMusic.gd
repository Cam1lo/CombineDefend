extends AudioStreamPlayer

var config

func init(config):
	self.config = config

func _process(delta):
	if config:
		if !playing and config.audio_enabled:
			play()
