extends RigidBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var child = null

func count():
    if child:
        return child.count() + 1
    else:
        return 1

func delete():
    if child:
        child.delete()
    queue_free()

func _ready():
    # Called every time the node is added to the scene.
    # Initialization here
    pass

func add_duck(duck, behind):
    if child:
        print("can't add duck already have child")
        return
    child = duck
    var new_behind = - self.linear_velocity
    if new_behind.length() == 0:
        new_behind = behind
    var spring = PinJoint2D.new()
    spring.set_name('joint')
    duck.set_name('duck')
    duck.position = new_behind.normalized() * 30
    self.add_child(duck)
    duck.set_owner(self)
    self.add_child(spring)
    spring.set_node_a('..')
    spring.set_node_b('../duck')