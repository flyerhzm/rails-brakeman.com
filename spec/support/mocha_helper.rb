module MochaHelper
  def stub_chain(*methods)
    if methods.length > 1
      next_in_chain = ::Object.new
      stubs(methods.shift).returns(next_in_chain)
      next_in_chain.stub_chain(*methods)
    else
      stubs(methods.shift)
    end
  end
end

Object.send(:include, MochaHelper)
