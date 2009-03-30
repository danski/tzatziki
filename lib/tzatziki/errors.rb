module Tzatziki
  
  # Raised when a circular dependency is encountered in the specification logic.
  class RecursiveSpecificationError < ArgumentError; end
  
  # Raise when a document is encountered that uses more than one signing specification.
  # signing specifications are able to modify the request based on hashes of it's properties,
  # and so anything more than one signing specification is a circular dependency.
  class MultipleSigningSpecificationError < ArgumentError; end
  
end