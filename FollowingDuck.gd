extends RigidBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var child = null
var parent = null
var player = null

func is_follow_duck():
    pass

func _process(delta):
    var target_angle = -global_rotation
    
    $AnimatedSprite.rotate(target_angle - $AnimatedSprite.rotation)
    z_index = to_global(position).y + 7
    if linear_velocity.x > 0 and abs(linear_velocity.x) > abs(linear_velocity.y):
        $AnimatedSprite.animation = "right"
    elif linear_velocity.x < 0 and abs(linear_velocity.x) > abs(linear_velocity.y):
        $AnimatedSprite.animation = "left"
    elif linear_velocity.y > 0 and abs(linear_velocity.y) > abs(linear_velocity.x):
        $AnimatedSprite.animation = "down"
    elif linear_velocity.y < 0 and abs(linear_velocity.y) > abs(linear_velocity.x):
        $AnimatedSprite.animation = "up"


func count():
    if child:
        return child.count() + 1
    else:
        return 1

func kill_me():
    if child:
        child.kill_me()
    if parent:
        parent.get_node('joint').queue_free()
        parent.child = null
    queue_free()

func _ready():
    # Called every time the node is added to the scene.
    # Initialization here
    pass

func add_duck(duck, behind):
    var new_behind = - self.linear_velocity
    if new_behind.length() == 0:
        new_behind = behind
    if child:
        child.add_duck(duck, new_behind)
    else:
        child = duck
        var spring = PinJoint2D.new()
        spring.set_name('joint')
        duck.set_name('duck')
        duck.position = new_behind.normalized() * 30
        self.add_child(duck)
        duck.set_owner(self)
        self.add_child(spring)
        spring.set_node_a('..')
        spring.set_node_b('../duck')
        duck.parent = self