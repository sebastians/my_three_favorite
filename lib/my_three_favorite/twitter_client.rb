module MyThreeFavorite
  class TwitterClient

    def self.get(method_name, params, ordered=false)
      new(method_name, params, ordered).send(:get)
    end

    def initialize(method_name, params, ordered)
      @method_name  = method_name.to_sym
      @params       = params ? params.reject { |name| name.empty? } : []
      @ordered      = ordered
    end

    private

    attr_reader :method_name, :params, :ordered

    def get
      if ordered
        fetch_from_twitter.sort{ |a, b| b.created_at <=> a.created_at }
      else
        fetch_from_twitter
      end
    end

    def fetch_from_twitter
      begin
        build_response_array
      rescue Twitter::Error::TooManyRequests, Twitter::Error::NotFound => error
        Rails.logger.info "An error occurred #{error.to_s}"
        []
      end
    end

    def build_response_array
      params.each_with_object([]) do |param, array|
        array << Twitter.send(method_name, param)
      end.flatten
    end
  end
end
