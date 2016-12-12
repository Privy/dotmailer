module DotMailer
  class ImportNotFinished < StandardError; end

  class InvalidFromAddress < StandardError; end

  class InvalidRequest < StandardError; end

  class NotFound < StandardError; end

  class UnknownDataField < StandardError; end

  class UnknownOptInType < StandardError; end
end
