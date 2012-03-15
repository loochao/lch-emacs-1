import string
import sys

def cvt(s):
    while len(s) > 0:
        try:
            return string.atof(s)
        except:
            s = s[:-1]

s = sys.stdin.readline()
while s != '':
    print '\t %g' % cvt(s)
    s = sys.stdin.readline()
