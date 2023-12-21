extends Node



const EASING_STYLES: Array[String] = [
	'linear', 'quint', 'elastic', 'sine', 'quart', 'quad', 'expo', 'cubic', 'circ', 'bounce', 'back',
	'spring'
]
const EASING_DIRECTIONS: Array[String] = [
	'out', 'in', 'in_out', 'out_in'
]



signal delayed_tw_ended(tween: Tween, delay: float)


var default_es := ''
var default_ed := ''
var default_time := 0.0




func set_default_easing(style = 'linear', direction = 'out') -> void:
	if !EASING_STYLES.has(style.to_lower()):
		style = EASING_STYLES[0]
		printerr(style, ' easing style not found. Set to ' + EASING_STYLES[0])
	if !EASING_DIRECTIONS.has(direction.to_lower()):
		direction = EASING_DIRECTIONS[0]
		printerr(direction, ' easing direction not found. Set to ' + EASING_DIRECTIONS[0])
	
	default_es = style
	default_ed = direction


func set_default_time(time: float) -> void:
	default_time = time




func tw(v: Node, time: float, property_dict: Dictionary, es := 'linear', ed := 'out', delay := -1.0) -> Tween:
	if !v:			return
	
	if !EASING_STYLES.has(es.to_lower()):
		es = EASING_STYLES[0]
		printerr(es, ' easing style not found. Set to ' + EASING_STYLES[0])
	if !EASING_DIRECTIONS.has(ed.to_lower()):
		ed = EASING_DIRECTIONS[0]
		printerr(ed, ' easing direction not found. Set to ' + EASING_DIRECTIONS[0])
	
	if es.is_empty():				es = default_es
	if es.is_empty():				ed = default_ed
	if !time or (time == -1.0):		time = default_time 
	
	time = max(time, 0.0)
	
	
	var easing: Tween.TransitionType = Tween['TRANS_'+str(es).to_upper()]
	var direction: Tween.EaseType = Tween['EASE_'+str(ed).to_upper()]
	
	if delay != -1:
		var timer := Timer.new()
		timer.wait_time = delay
		timer.one_shot = true
		add_child(timer)
		
		var tween := create_tween()
		tween.set_parallel(true)
		
		timer.timeout.connect(func() -> void:
			for property: String in property_dict:
				tween.tween_property(
					v,
					property,
					property_dict[property],
					time
				).set_ease(direction).set_trans(easing)
			
			emit_signal('delayed_tw_ended', tween, delay)
			timer.queue_free()
		)
		return tween
	
	if time > 0:
		var tween := create_tween()
		
		for property: String in property_dict:
			tween.tween_property(
				v,
				property,
				property_dict[property],
				time
			).set_ease(direction).set_trans(easing)
			
			if property_dict.size() == 1:
				return tween
	else:
		for property: String in property_dict:
			v[property] = property_dict[property]
	
	return null
