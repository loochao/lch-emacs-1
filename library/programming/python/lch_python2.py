import sys

food = [ 'beer', 'pizza', 'coffee' ]
food.append('coke')
for i in range(1, len(sys.argv)):
    if i < len(sys.argv):
        print argv[i],
    else:
        print argv[i]
