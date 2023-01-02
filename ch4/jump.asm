jmp Label1
print "skiped"
Label1: print "jump here"

push 0
jz Label2
print "top is not zero"
Label2: print "top is zero"

exit 0