# tw
Easy tween



## Default parameters:
```gdscript
tw.tw(
	node = null, #required
	time = 0.1, #required
	property_dict = {}, #required
	easing_style = 'linear',
	easing_direction = 'out', 	
	delay = null
)
```


## Configuration:
```gdscript
tw.set_default_time(1.0)

tw.set_default_easing(style := '', direction := '')
tw.set_default_easing('quint')
tw.set_default_easing('quint', 'out')
```



## Usage:
```gdscript
tw.set_default_time(1.0)
tw.set_default_easing('quint')


tw.tw(self, 1.0, {modulate = Color.RED})
tw.tw($Node, 1.0, {modulate = Color.RED, rotation = 360}, 'quint', 'out')
tw.tw(self, 1.0, {modulate = Color.RED, "position:x" = 20}, 'QuiNT', 'OuT')
tw.tw(self, 1.0, {modulate = Color.RED}, 'quint', 'in')
tw.tw(self, 1.0, {modulate = Color.RED}, 'elastic', 'out')
tw.tw(self, 1.0, {modulate = Color.RED}, 'elastic')

tw.tw(self, 0.0, {modulate = Color.RED}, 'elastic')
#equivalent to      "self.modulate = Color.RED"

tw.tw(self, -2.0, {modulate = Color.RED}, 'elastic')
#equivalent to      "self.modulate = Color.RED"

```
