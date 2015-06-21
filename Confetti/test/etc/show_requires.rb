alias :orig_require :require
def require s
  print "Requires #{s}\n" if orig_require(s)
end
