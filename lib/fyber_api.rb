class FyberApi
  class ResponseSignatureIsNotValid < RuntimeError; end
  class ResponseNotSuccessfull < RuntimeError; end
  class MissingAPIKey < RuntimeError; end
end
