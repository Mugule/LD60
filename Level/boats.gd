extends Node2D

func on_valid_word(word : String):
	print('boats received %s' % word)
	var order = word.right(-1)
	var id : String = word[0]
	if id == 'A' : # FOR ALL
		for b in get_children():
			var first : bool = true
			if b.orders.has(order) :
				print('boat %s do %s' % [b.name,order])
				b.on_order_received(order)
				if first : # Play sounds only for one
					first = false
					Sound.play('order_ok')
			else :
				print('wrong order')
	else : # FOR ONE
		if has_node(id) :
			var boat : Boat = get_node(id)
			if boat.orders.has(order) :
				print('boat %s do %s' % [boat.name,order])
				boat.on_order_received(order)
				Sound.play('order_ok')
			else :
				print('wrong order')
		else :
			print('no boat')
