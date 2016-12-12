module DotMailer
  class DotmailerError < StandardError; end

  class ImportNotFinished < DotMailerError; end

  class InvalidFromAddress < DotMailerError; end

  class InvalidRequest < DotMailerError; end

  class NotFound < DotMailerError; end

  class UnknownDataField < DotMailerError; end

  class UnknownOptInType < DotMailerError; end
end
