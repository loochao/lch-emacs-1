class Stack:
    def __init__(self):
        self.stack = []
    def push(self, obj):
        self.stack.append(obj)
    def pop(self):
        return self.stack.pop()
    def len(self):
        return len(self.stack)

stk = Stack()
stk.push("foo")
if stk.len() != 1: print "error"
if stk.pop() != "foo": print "error"
del stk

