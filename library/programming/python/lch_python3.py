import sys, string, fileinput
val = {}
line = sys.stdin.readline()
while (line != ""):
    (n,v) = line.strip().split()
    if val.has_key(n):
        val[n] += string.atof(v)
    else:
        val[n] = string.atof(v)
    line = sys.stdin.readline()
for i in val:
    print "%s \t %g" % (i, val[i])

