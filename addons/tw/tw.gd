extends Node


var regex_easing = RegEx.new()


## ALL THE SAME
# tw(node, 0.5, {color = Color.RED}, 'quint')
# tw(node, 0.5, {color = Color.RED, "position:y" = 20}, 'quint_out')
# tw(node, 0.5, {color = Color.RED}, 'Quintout')
# tw(node, 0.5, {color = Color.RED}, 'quint_In')
# tw(node, 0.5, {color = Color.RED}, 'quint_in')
# tw(node, 0.5, {color = Color.RED}, 'QUInt_in')
# tw(node, 0.5, {color = Color.RED}, '', '') -- defaul easing style and easing direction

const EASING_STYLES = [
	'linear', 'quint', 'elastic', 'sine', 'quart', 'quad', 'expo', 'cubic', 'circ', 'bounce', 'back',
	'spring'
]
const EASING_DIRECTIONS = [
	'out', 'in', 'in_out', 'out_in'
]


class basic:
	static var default_es := 'linear'
	static var default_ed := 'out'
	static  var default_time := 0.1
	static  var animations := true
	
	var node = null
	var time := 0.0
	var es :Tween.TransitionType
	var ed :Tween.EaseType
	var property_dict := {}
	var delay = null
	
	static func normalize_easing(style, direction):
		if !EASING_STYLES.has(style.to_lower()):
			style = EASING_STYLES[0]
			printerr(style, ' easing style not found. Set to ' + EASING_STYLES[0])
		if !EASING_DIRECTIONS.has(direction.to_lower()):
			direction = EASING_DIRECTIONS[0]
			printerr(direction, ' easing direction not found. Set to ' + EASING_DIRECTIONS[0])
		
		return {style = style, direction = direction}
	
	
	func _init(node, time, property_dict, es = '', ed = '', delay = null):
		if !node:						printerr('node is null:\nNode: ', node, ',\nProperty dict: ', property_dict);	return
		if  (!property_dict or property_dict.is_empty()):	push_error('property_dict is empty');		return
		
		
		if animations:
			if es.is_empty():				es = self.default_es
			if es.is_empty():				ed = self.default_ed
			if !time or (time == -1.0):		time = self.default_time 
			self.time = max(time, 0.0)
			
			var normalized = self.normalize_easing(es, ed)
			es = normalized.style
			ed = normalized.direction
			
			
			var easing :Tween.TransitionType = Tween['TRANS_'+str(es).to_upper()]
			var direction :Tween.EaseType = Tween['EASE_'+str(ed).to_upper()]
			
			
			self.es = easing
			self.ed = direction
		else:
			self.time = 0.0
		
		self.property_dict = property_dict
		self.node = node
		self.delay = delay
		




func set_default_easing(style = 'linear', direction = 'out'):
	var normalized = basic.normalize_easing(style, direction)
	style = normalized.style
	direction = normalized.direction
	
	basic.default_es = style
	basic.default_ed = direction


func set_default_time(time:float):
	basic.default_time = time





func tw(node:Node = null, time:float = -1.0, property_dict := {}, es := '', ed := '', delay = null):
	var new_basic = basic.new(node, time, property_dict, es, ed, delay)
	
	
	var callback = func():
		var tweens = []
		for property in property_dict:
			if (property in node):
				var tween = create_tween()
				tween.tween_property(
					new_basic.node,
					property,
					new_basic.property_dict[property],
					new_basic.time
				).set_ease( new_basic.ed ).set_trans( new_basic.es )
				
				if property_dict.size() == 1:		return tween
				else:								tweens.append(tween)
			else:
				printerr(node, ' does not have "%s" property' % property)
		
		return tweens
	
	
	if new_basic.delay:
		var timer=Timer.new()
		timer.wait_time = max(new_basic.delay, 0.0)
		timer.one_shot=true
		add_child(timer)
		timer.timeout.connect(func(): callback.call();	timer.queue_free() )
		return
	
	print(new_basic.time)
	if new_basic.time > 0.0:
		return callback.call()
	else:
		for property in new_basic.property_dict:
			if typeof(property) != TYPE_STRING:
				printerr(new_basic.property_dict, '\n', property, ' must be a string')
				continue
			
			if (property in new_basic.node):
				new_basic.node[property] = new_basic.property_dict[property]
			else:
				printerr(new_basic.node, ' does not have "%s" property' % property)






func tw_alpha(node:Node = null, time:float = -1.0, alpha := 0.0, es := '', ed := '', self_modulate = null):
	var property = ('self_'if self_modulate else '') + 'modulate'
	if !(property in node):
		printerr(node, ' does not have "%s" property' % property)
		return
	
	var new_basic = basic.new(node, time, {property = alpha}, es, ed)
		
	
	var tween = create_tween()
	tween.tween_property(
		new_basic.node,
		property,
		new_basic.property_dict[property],
		new_basic.time
	).set_ease( new_basic.ed ).set_trans( new_basic.es )
	
	return tween

