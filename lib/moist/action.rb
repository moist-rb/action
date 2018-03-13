require 'dry/validation'
require 'fear/either'
require 'moist/action/version'

module Moist
  # This module provides validation logic for controller actions.
  # @example
  #   class RegisterUser
  #     include Moist::Action
  #
  #     params do
  #       required(:name).filled(:str?)
  #       required(:email).filled(format?: EMAIL_REGEX)
  #       required(:age).maybe(:int?)
  #     end
  #
  #     def perform(params)
  #       User.create(params)
  #     end
  #
  module Action
    include Fear::Either::Mixin

    module Params # rubocop:disable Style/Documentation
      EMPTY_FORM = Dry::Validation.Form()

      # Specify params validator
      # @example
      #   class ChangeUsername
      #     include Moist::Action
      #
      #     params do
      #       required(:username).filled?(:str?)
      #     end
      #   end
      #
      # @see http://dry-rb.org/gems/dry-validation/forms/
      def params(&block)
        if block_given?
          @params = Dry::Validation.Form(&block)
        else
          @params || EMPTY_FORM
        end
      end
    end

    class << self
      def included(base)
        base.extend(Params)
      end
    end

    # @param params [{Symbol => any}]
    # @return [Fear::Right<any>, Fear::Left<{Symbol => <String>}>] returns +Fear::Right+ in
    #   case of successful validation or +Fear::Left+ in case of error.
    #
    def call(params)
      validation_result = self.class.params.(params)
      if validation_result.success?
        Right(perform(validation_result.output))
      else
        Left(validation_result.messages)
      end
    end

    # Template method to be overridden by an Action
    # @param _params [{Symbol => any}]
    # @return [<any>]
    def perform(_params)
      raise NotImplementedError
    end
  end
end
