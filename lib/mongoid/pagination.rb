
module Mongoid
  module Criterion
    module Pagination
      def paginate(opts = {})
        return criteria if opts[:limit].blank? &&
          opts[:page].blank? &&
          opts[:offset].blank?

        limit = (opts[:limit] || 25).to_i
        page  = (opts[:page]  || 1).to_i

        if opts[:page].blank?
          offset = (opts[:offset] || 0)
        else
          if page > 1
            offset = (page - 1) * limit
          else
            offset = 0
          end
        end

        per_page(limit).offset(offset)
      end

      # Limit the result set
      #
      # @param [Integer] page_limit the max number of results to return
      # @return [Mongoid::Criteria]
      def per_page(page_limit = 25)
        limit(page_limit.to_i)
      end
    end
  end

  class Criteria
    include Criterion::Pagination
  end

  module Pagination
    extend Origin::Forwardable
    select_with :with_default_scope

    delegate :paginate, :per_page, to: :with_default_scope
  end

  module Document
    included { extend Mongoid::Pagination }
  end
end

