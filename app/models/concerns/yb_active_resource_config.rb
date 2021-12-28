module YbActiveResourceConfig
    extend ActiveSupport::Concern
  
    included do
      self.site                   = ENV['YB_API_URL']
      self.prefix                 = '/api/admin/'
      self.format                 = FormatApiResponse
      self.include_format_in_path = false
    end
  end
  