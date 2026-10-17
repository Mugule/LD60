extends Node2D

func on_valid_word(word : String):
	print('boats received %s' % word)
	var boat : Boat = get_node(word[0])
	if boat :
		var order = word.right(-1)
		if boat.orders.has(order) :
			print('boat %s do %s' % [boat.name,order])
			boat.on_order_received(order)
		else :
			print('wrong order')
	else :
		print('no boat')
		
