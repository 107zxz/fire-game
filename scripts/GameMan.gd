extends Node

var inv = {
	0: null,
	1: null,
	2: null,
	3: null,
	4: null,
}

var active_item = ""

func _enter_tree():
	
	var sIdx = 0
	
	for slot in $UI/Inventory.get_children():
		slot.connect("pressed", _invslot_clicked.bind(sIdx))
		sIdx += 1


func _on_left_arrow_button_down():
	rotateBy(1)


func _on_right_arrow_button_down():
	rotateBy(-1)


func rotateBy(angle: float):
	var tw = create_tween()
	
	tw.tween_property($CF3D/Camera3D, "rotation", $CF3D/Camera3D.rotation + Vector3(0, angle * PI/2, 0), 0.15)
	
	$UI/LeftArrow.hide()
	$UI/RightArrow.hide()
	
	await tw.finished
	
	$UI/LeftArrow.show()
	$UI/RightArrow.show()


func _input(event):
	
	# Don't allow movement if viewing a note
	if $UI/Note.visible:
		# Clicking / pressing a key closes the note
		if (event is InputEventMouseButton or event is InputEventKey) and event.pressed:
			
			
			# Re-enable controls
			$UI/LeftArrow.show()
			$UI/RightArrow.show()
			
			get_viewport().set_input_as_handled()
			
			await get_tree().create_timer(0.01).timeout
			
			$UI/Note.hide()
			
		return
	
	# Block events if burnconfirm open
	if $UI/BurnConfirm.visible:
		if (event is InputEventMouseButton or event is InputEventKey) and event.pressed:
			
			# Block event from affecting interactables if not hovering
			if $UI/BurnConfirm.get_global_rect().has_point(get_viewport().get_mouse_position()):
				pass
			else:
				get_viewport().set_input_as_handled()
			
		return
	
	if Input.is_action_just_pressed("turn_left") and $UI/LeftArrow.visible:
		rotateBy(1)
	if Input.is_action_just_pressed("turn_right") and $UI/RightArrow.visible:
		rotateBy(-1)


func collect_item(item: Node3D) -> void:
#	$UI/Note/Label.text = note.note_text
#	$UI/Note.show()
	
#	$UI/LeftArrow.hide()
#	$UI/RightArrow.hide()
	
	# Inventory slot
#	$UI/Inventory.get_child(note.note_index - 1).show()
#	$UI/Inventory.get_child(note.note_index - 1).set_meta("note_text", note.note_text)

	# Kill the item used to collect it
	if active_item != "":
		for invSlot in inv:
			if inv[invSlot].name == active_item:
				ditch_item(invSlot)
				break
		active_item = ""


	# Don't collect 'generic' items
	if item.item_meta.type == "generic":
		return
	
	
	for sl in inv:
		if inv[sl] == null:
			
			
			var uiSlot = $UI/Inventory.get_child(sl)
			
			inv[sl] = item.item_meta
			
			# Fill this slot
			if not uiSlot.visible:
				uiSlot.show()
			
			uiSlot.get_child(0).texture = item.item_meta.icon
			
			# Special for usables
			if item.item_meta.type == "item":
				uiSlot.set_toggle_mode(true)
			
			break


func _invslot_clicked(slot):
	
	# Display note if that's the right kind of item
	match inv[slot].type:
		"note":
			$UI/Note/Label.text = inv[slot].text
			$UI/Note.show()
			
			$UI/LeftArrow.hide()
			$UI/RightArrow.hide()
		"fuel":
			# Mark burnconfirm with current fuel
			$UI/BurnConfirm.set_meta("to_burn", slot)
			$UI/BurnConfirm/VBoxContainer/ItemIcon.texture = inv[slot].icon
			
			$UI/BurnConfirm.show()
			
			$UI/LeftArrow.hide()
			$UI/RightArrow.hide()
		"item":
			if $UI/Inventory.get_child(slot).is_pressed():
				active_item = inv[slot].name
			else:
				active_item = ""




func _on_burn_no_pressed():
	$UI/BurnConfirm.hide()
	
	# Re-enable controls
	$UI/LeftArrow.show()
	$UI/RightArrow.show()
	


func _on_burn_yes_pressed():
	
	# Remove item
	var slot = $UI/BurnConfirm.get_meta("to_burn")
	
	# Expand radius
	create_tween().tween_property($CF3D/Darkness, "max_size", inv[slot].radius, 3.0)
	
	ditch_item(slot)
	
	$UI/BurnConfirm.hide()
	
	# Re-enable controls
	$UI/LeftArrow.show()
	$UI/RightArrow.show()


func ditch_item(slot: int):
	
	# For each slot to right of thing
	# if slot is filled
	# 	move item to left
	
	var currSlot = slot
	
#	if currSlot == $UI/Inventory.get_child_count() - 1:
	
	
	while currSlot < $UI/Inventory.get_child_count() - 1:
		
		if $UI/Inventory.get_child(currSlot + 1).visible:
			$UI/Inventory.get_child(currSlot).get_child(0).texture = inv[currSlot + 1].icon
			$UI/Inventory.get_child(currSlot).toggle_mode = $UI/Inventory.get_child(currSlot + 1).toggle_mode
			inv[currSlot] = inv[currSlot + 1]
			inv[currSlot + 1] = null
			
			$UI/Inventory.get_child(currSlot + 1).hide()
			$UI/Inventory.get_child(currSlot + 1).toggle_mode = false
		else:
			break
		
		currSlot += 1
	
	if currSlot == slot:
		$UI/Inventory.get_child(currSlot).hide()
		$UI/Inventory.get_child(currSlot).toggle_mode = false
		inv[currSlot] = null
	
