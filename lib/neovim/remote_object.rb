module Neovim
  # @abstract Superclass for all +nvim+ remote objects.
  #
  # @see Buffer
  # @see Window
  # @see Tabpage
  class RemoteObject
    attr_reader :index

    def initialize(index, session)
      @index = index
      @session = session
      @api = session.api
    end

    # Serialize object to MessagePack.
    #
    # @param packer [MessagePack::Packer]
    # @return [String]
    def to_msgpack(packer)
      packer.pack(@index)
    end

    # Intercept method calls and delegate to appropriate RPC methods.
    def method_missing(method_name, *args)
      if func = @api.function_for_object_method(self, method_name)
        func.call(@session, @index, *args)
      else
        super
      end
    end

    # Extend +respond_to?+ to support RPC methods.
    def respond_to?(method_name)
      super || rpc_methods.include?(method_name.to_sym)
    end

    # Extend +methods+ to include RPC methods
    def methods(*args)
      super | rpc_methods
    end

    # Extend +==+ to only look at class and index.
    def ==(other)
      other.class.equal?(self.class) && @index == other.index
    end

    private

    def rpc_methods
      @api.functions_for_object(self).map(&:method_name)
    end
  end
end
