class_name BitFlag extends RefCounted

var bits := 0

func set_flag(flag: int, enabled: bool) -> void:
	if enabled:
		bits |= flag
	else:
		bits &= ~flag

func set_flags(flags: Array, enabled: bool) -> void:
	for flag in flags:
		set_flag(flag, enabled)

func is_flag_set(flag: int) -> bool:
	return (bits & flag) != 0

func are_flags_set(flags: Array) -> bool:
	for flag in flags:
		if not is_flag_set(flag):
			return false
	return true